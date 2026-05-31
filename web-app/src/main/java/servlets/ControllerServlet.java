package servlets;

import db.DAOClass;
import beans.User;
import beans.Prediction;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Base64;
import java.util.concurrent.ConcurrentHashMap;
import java.io.IOException;
import java.net.*;
import java.util.*;


@WebServlet("/controller")
public class ControllerServlet extends HttpServlet {
  DAOClass db = null;
  ConcurrentHashMap<String, User> loggedInUsers = new ConcurrentHashMap<>();

  @Override
  public void init() throws ServletException {
    try {
      db = new DAOClass();
    } catch(SQLException | ClassNotFoundException e) {
      throw new ServletException("DB init failed", e);
    }
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) 
      throws ServletException, IOException {

    RequestDispatcher rd = null;
    String requestType = req.getParameter("request_type");

    try {
      if("profile".equals(requestType)) {
        rd = handleProfile(req,res);
      } else if("predict".equals(requestType)) {
        rd = handlePrediction(req, res);
      } else if("history".equals(requestType)) {
        rd = handleHistory(req, res);
      } else if("admin".equals(requestType)) {
        rd = handleAdmin(req, res);
      } else if("logout".equals(requestType)) {
        rd = handleLogout(req, res);
      } else {
        rd = req.getRequestDispatcher("/JSP/error.jsp");
        req.setAttribute("error_msg", "Unsupported Request Type");
      }
      
    } catch(SQLException e) {
      throw new ServletException("DB querying failed", e);
    }
    if(rd != null)
      rd.forward(req, res);
  }


  public void doPost(HttpServletRequest req, HttpServletResponse res) 
      throws ServletException, IOException {
    RequestDispatcher rd = null;
    String requestType = req.getParameter("request_type");

    try {
      if("register".equals(requestType)) {
        rd = handleRegistering(req, res);
      } else if("login".equals(requestType)) {
        rd = handleLogin(req, res);
      } else if("edit_info".equals(requestType)) {
        rd = handleEditUserProfile(req, res);
      } else {
        rd = req.getRequestDispatcher("/JSP/error.jsp");
        req.setAttribute("error_msg", "Unsupported Request Type");
      }

    } catch(SQLException e) {
      throw new ServletException("DB querying failed", e);
    }
    if(rd != null)
      rd.forward(req, res);
  }

  RequestDispatcher handleRegistering(HttpServletRequest req , HttpServletResponse res) 
      throws SQLException {
    User newUser = parseUserInfo(req);
    newUser = db.registerNewUser(newUser);
    if(newUser != null) {
      newUser.setPassword(null);
      String sessionToken = generateSessionToken();
      loggedInUsers.put(sessionToken, newUser);
      res.addCookie(createSessionTokenCookie(sessionToken));
      req.setAttribute("user_info", newUser);
      return req.getRequestDispatcher("/JSP/profile.jsp");
    } else {
      req.setAttribute("error_msg", "Email already linked to an account");
    }
    return req.getRequestDispatcher("/JSP/register.jsp");
  }

  RequestDispatcher handleLogin(HttpServletRequest req, HttpServletResponse res) 
      throws SQLException {
    User candidateUser = parseUserInfo(req); 
    candidateUser = db.validateLogin(candidateUser);
    if(candidateUser != null) {
      candidateUser.setPassword(null);
      String sessionToken = generateSessionToken();
      loggedInUsers.put(sessionToken, candidateUser);
      res.addCookie(createSessionTokenCookie(sessionToken));
      req.setAttribute("user_info", candidateUser);
      return req.getRequestDispatcher("/JSP/profile.jsp");

    } else {
      req.setAttribute("error_msg", "Invalid Credentials");
    }
    return req.getRequestDispatcher("/JSP/login.jsp");
  }

  RequestDispatcher handleProfile(HttpServletRequest req, HttpServletResponse res) 
      throws SQLException {
    String userToken=getSessionToken(req);
    if (userToken!=null && loggedInUsers.containsKey(userToken)){
      User currentUser = loggedInUsers.get(userToken);
      req.setAttribute("user_info" , currentUser);

      return req.getRequestDispatcher("/JSP/profile.jsp");
    }else{
      req.setAttribute("error_msg", "Access denied , please log in first");
      return req.getRequestDispatcher("/JSP/login.jsp"); 
    }
  }

  RequestDispatcher handlePrediction(HttpServletRequest req , HttpServletResponse res) 
      throws SQLException {
    String userToken=getSessionToken(req);
    if (userToken!=null && loggedInUsers.containsKey(userToken)){
      User currentUser = loggedInUsers.get(userToken);
      req.setAttribute("user_info" , currentUser);
      try{
        String jsonPayload = req.getParameter("json_data");
        //la connection au api 
        URL url = new URL("http://localhost:5000/predict");
        HttpURLConnection conn= (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        //Envoi du json au api 
        conn.getOutputStream().write(jsonPayload.getBytes("UTF-8"));

        Scanner sc = new Scanner(conn.getInputStream()).useDelimiter("\\A");
        String predictionresult =sc.hasNext() ? sc.next() : "";
        sc.close();
        req.setAttribute("prediction_result",predictionresult);
        conn.disconnect();
      }catch (Exception e) {
          req.setAttribute("error_msg", "Error with the Flask API: " + e.getMessage());
      }
      return req.getRequestDispatcher("/JSP/predict.jsp");
    }else{
      req.setAttribute("error_msg", "Access denied , please log in first");
      return req.getRequestDispatcher("/JSP/login.jsp"); 
    }
  }


RequestDispatcher handleHistory(HttpServletRequest req, HttpServletResponse res) 
      throws SQLException{
    String userToken = getSessionToken(req);
    if (userToken != null && loggedInUsers.containsKey(userToken)) {
        User currentUser = loggedInUsers.get(userToken);
        String userIdParam = req.getParameter("userId");
        int targetUserId;
        if (userIdParam != null && "admin".equalsIgnoreCase(currentUser.getRole())) {
            targetUserId = Integer.parseInt(userIdParam);
        } else {
            targetUserId = currentUser.getUserId();
        }
        req.setAttribute("user_info", currentUser);
        try {
            ArrayList<Prediction> userHistory = db.getUserHistory(targetUserId);
            req.setAttribute("prediction_history", userHistory);
        } catch(Exception e) {
            req.setAttribute("error_msg", "Error fetching history: " + e.getMessage());
        }
        return req.getRequestDispatcher("/JSP/history.jsp");
    } else {
        req.setAttribute("error_msg", "Access denied, please log in first");
        return req.getRequestDispatcher("/JSP/login.jsp");
    }
}

  RequestDispatcher handleAdmin(HttpServletRequest req , HttpServletResponse res) 
      throws SQLException {
    String userToken=getSessionToken(req);
    if (userToken != null && loggedInUsers.containsKey(userToken)) {
      User currentUser = loggedInUsers.get(userToken);
      //Verification si admin
      if ("admin".equalsIgnoreCase(currentUser.getRole())) { 
        req.setAttribute("user_info", currentUser);
        ArrayList<User> AllUsers = db.getAllUsers();
        req.setAttribute("all_users",AllUsers);
        return req.getRequestDispatcher("/JSP/admin.jsp");
      } else {
        req.setAttribute("error_msg", "Access denied: Admins only");
        return req.getRequestDispatcher("/JSP/profile.jsp");
      }
    } else {
      req.setAttribute("error_msg", "Please log in first");
      return req.getRequestDispatcher("/JSP/login.jsp");
    }
  }

  RequestDispatcher handleEditUserProfile(HttpServletRequest req, HttpServletResponse res)
      throws SQLException {
    String userToken = getSessionToken(req);
    if (userToken != null && loggedInUsers.containsKey(userToken)) {
      User targetUser = parseUserInfo(req);
      if(db.updateUserInfo(targetUser)) {
        User oldUserInfo = loggedInUsers.get(userToken);
        User updatedUserInfo = db.getUser(oldUserInfo.getEmail());
        loggedInUsers.put(userToken, updatedUserInfo);
        req.setAttribute("user_info", updatedUserInfo);
        return req.getRequestDispatcher("/JSP/profile.jsp");
      } else {
        req.setAttribute("error_msg", "Failed to update user profile");
      }
    } else {
      req.setAttribute("error_msg", "Failed to update user profile");
      return req.getRequestDispatcher("/JSP/login.jsp");
    }
    return req.getRequestDispatcher("/JSP/profile.jsp");
  }


  RequestDispatcher handleLogout(HttpServletRequest req, HttpServletResponse res) 
     throws SQLException {
    String userToken = getSessionToken(req);
    if (userToken != null && loggedInUsers.containsKey(userToken)) {
      loggedInUsers.remove(userToken);
      clearCookies(req, res);
    } else {
      req.setAttribute("error_msg", "Please log in first");
    }
    return req.getRequestDispatcher("/JSP/login.jsp");
  }

  Cookie createSessionTokenCookie(String sessionToken) {
    Cookie sessionCookie = new Cookie("session_token", sessionToken);
    sessionCookie.setHttpOnly(true);
    sessionCookie.setSecure(true);
    sessionCookie.setPath("/");
    sessionCookie.setMaxAge(3600 * 24); //24h
    return sessionCookie;
  }

  User parseUserInfo(HttpServletRequest req) {
    User user = new User();
    user.setFirstName(req.getParameter("firstName"));
    user.setLastName(req.getParameter("lastName"));
    String ageParam = req.getParameter("age");
    if (ageParam != null && !ageParam.isEmpty()) {
      try {
        user.setAge(Integer.parseInt(ageParam));
      } catch (NumberFormatException e) {
        user.setAge(-1);
      }
    }
    user.setGender(req.getParameter("gender"));
    user.setEmail(req.getParameter("email"));
    user.setPassword(req.getParameter("password"));
    return user;
  }

  static SecureRandom sr = new SecureRandom();
  String generateSessionToken() {
    byte[] randomBytes = new byte[24];
    sr.nextBytes(randomBytes);
    return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
  }

  //recuperer le token du cookie
  private String getSessionToken(HttpServletRequest req) {
    Cookie[] cookies = req.getCookies();
    if (cookies != null) {
      for (Cookie c : cookies) {
        if ("session_token".equals(c.getName())) {
          return c.getValue();
        }
      }
    }
    return null;
  }

  private void clearCookies(HttpServletRequest req, HttpServletResponse res) {
    Cookie[] cookies = req.getCookies();
    if (cookies != null) {
      for (Cookie c : cookies) {
        c.setValue("");
        c.setMaxAge(0);
        c.setPath("/");
        res.addCookie(c);
      }
    }
  }
}