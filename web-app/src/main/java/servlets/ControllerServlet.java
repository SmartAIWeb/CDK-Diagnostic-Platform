package servlets;

import db.DAOClass;
import beans.User;
import beans.Prediction;
import beans.AdminRequest;

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
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.Collections;
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
      } else if("history".equals(requestType)) {
        rd = handleHistory(req, res);
      } else if("admin".equals(requestType)) {
        rd = handleAdmin(req, res);
      } else if("logout".equals(requestType)) {
        rd = handleLogout(req, res);
      } else if("predict".equals(requestType)) {
        rd = req.getRequestDispatcher("/predict.jsp");
      } else {
        rd = req.getRequestDispatcher("/error.jsp");
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
      } else if("predict".equals(requestType)) {
        rd = handlePrediction(req, res);
      } else if("submit_mod_request".equals(requestType)) {
        rd = handleSubmitModRequest(req, res);
      } else if("approve_moderator".equals(requestType)) { 
        handleApproveModerator(req, res);
        return ;
      } else if("reject_moderator".equals(requestType)) { 
        handleRejectModerator(req, res);
        return ;
      } else {
        rd = req.getRequestDispatcher("/error.jsp");
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
      return req.getRequestDispatcher("/profile.jsp");
    } else {
      req.setAttribute("error_msg", "Email already linked to an account");
    }
    return req.getRequestDispatcher("/register.jsp");
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
      return req.getRequestDispatcher("/profile.jsp");

    } else {
      req.setAttribute("error_msg", "Invalid Credentials");
    }
    return req.getRequestDispatcher("/login.jsp");
  }

  RequestDispatcher handleProfile(HttpServletRequest req, HttpServletResponse res) 
      throws SQLException {
    String userToken=getSessionToken(req);
    if (userToken!=null && loggedInUsers.containsKey(userToken)){
      User currentUser = loggedInUsers.get(userToken);
      req.setAttribute("user_info" , currentUser);

      return req.getRequestDispatcher("/profile.jsp");
    }else{
      req.setAttribute("error_msg", "Access denied , please log in first");
      return req.getRequestDispatcher("/login.jsp"); 
    }
  }

  RequestDispatcher handlePrediction(HttpServletRequest req, HttpServletResponse res)
      throws SQLException {
    String userToken = getSessionToken(req);
    if (userToken == null || !loggedInUsers.containsKey(userToken)) {
      req.setAttribute("error_msg", "Access denied, please log in first");
      return req.getRequestDispatcher("/login.jsp");
    }
    User currentUser = loggedInUsers.get(userToken);
    req.setAttribute("user_info", currentUser);

    Scanner scanner = null;
    HttpURLConnection conn = null;

    try {
      URL url = new URL(System.getenv("ML_API_URL"));
      conn = (HttpURLConnection) url.openConnection();

      String unprocessedFeatures = extractFeaturesFromReq(req);
      String processedFeatures = buildEncodedJsonFeatures(req);

      conn.setRequestMethod("POST");
      conn.setRequestProperty("Content-Type", "application/json");
      conn.setDoOutput(true);
      conn.getOutputStream().write(processedFeatures.getBytes("UTF-8"));

      scanner = new Scanner(conn.getInputStream()).useDelimiter("\\A");
      String predictionRes = scanner.hasNext() ? scanner.next() : "";
      JsonObject predictionResJson = new Gson().fromJson(predictionRes, JsonObject.class);

      int prediction_value = predictionResJson.get("prediction").getAsInt();
      int prediction_probability = predictionResJson.get("probability").getAsInt();

      req.setAttribute("prediction_result", prediction_value);
      req.setAttribute("prediction_probability", prediction_probability);

      db.insertNewPrediction(
        currentUser.getUserId(),
        unprocessedFeatures, 
        prediction_value,
        prediction_probability
      );
    } catch (Exception e) {
      req.setAttribute("error_msg", "Error with the Flask API: " + e.getMessage());
      return req.getRequestDispatcher("/error.jsp");
    } finally {
      if(conn != null) conn.disconnect();
      if(scanner != null) scanner.close();
    }
    return req.getRequestDispatcher("/predict.jsp");
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
        return req.getRequestDispatcher("/history.jsp");
    } else {
        req.setAttribute("error_msg", "Access denied, please log in first");
        return req.getRequestDispatcher("/login.jsp");
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
        ArrayList<AdminRequest> ModRequest = db.getPendingModRequests();
        req.setAttribute("mod_requests", db.getPendingModRequests());
        return req.getRequestDispatcher("/admin.jsp");
      } else {
        req.setAttribute("error_msg", "Access denied: Admins only");
        return req.getRequestDispatcher("/profile.jsp");
      }
    } else {
      req.setAttribute("error_msg", "Please log in first");
      return req.getRequestDispatcher("/login.jsp");
    }
  }

  RequestDispatcher handleEditUserProfile(HttpServletRequest req, HttpServletResponse res)
      throws SQLException {
    String userToken = getSessionToken(req);
    if (userToken != null && loggedInUsers.containsKey(userToken)) {
      User oldUserInfo = loggedInUsers.get(userToken);
      User targetUser = parseUserInfo(req);
      req.setAttribute("user_info", oldUserInfo);
      if(oldUserInfo.getEmail().equals(targetUser.getEmail())) {
        if(db.updateUserInfo(targetUser)) {
          User updatedUserInfo = db.getUser(oldUserInfo.getEmail());
          updatedUserInfo.setPassword(null);
          loggedInUsers.put(userToken, updatedUserInfo);
          req.setAttribute("user_info", updatedUserInfo);
          return req.getRequestDispatcher("/profile.jsp");
        } else {
          req.setAttribute("error_msg", "Database update failed");
          return req.getRequestDispatcher("/profile.jsp");
        }
      } else {
        req.setAttribute("error_msg", "Email cannot be changed");
        return req.getRequestDispatcher("/profile.jsp");
      }
    } else {
      req.setAttribute("error_msg", "Session expired");
      return req.getRequestDispatcher("/login.jsp");
    }
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
    return req.getRequestDispatcher("/login.jsp");
  }

 RequestDispatcher handleSubmitModRequest(HttpServletRequest req, HttpServletResponse res) 
  throws SQLException {
    String userToken = getSessionToken(req);
    if (userToken == null || !loggedInUsers.containsKey(userToken)) {
        return req.getRequestDispatcher("/login.jsp");
    }
    User currentUser = loggedInUsers.get(userToken);
    String message = req.getParameter("message");
    try {
        db.createModRequest(currentUser.getUserId(), message);
        req.setAttribute("msg", "Votre demande a ete envoyee aux administrateurs.");
    } catch (Exception e) {
        req.setAttribute("error_msg", "Error sending: " + e.getMessage());
    }
    return req.getRequestDispatcher("/profile.jsp");
}

  public void  handleApproveModerator(HttpServletRequest req, HttpServletResponse res)
    throws SQLException, IOException {
      int requestId = Integer.parseInt(req.getParameter("request_id"));
      int userId = Integer.parseInt(req.getParameter("user_id"));
      db.updateUserRole(userId, "admin");
      db.updateRequestStatus(requestId, "approved");
      res.sendRedirect("/controller?request_type=admin");
  }

  public void  handleRejectModerator(HttpServletRequest req, HttpServletResponse res) 
  throws SQLException, IOException{
    int requestId = Integer.parseInt(req.getParameter("request_id"));
    db.updateRequestStatus(requestId, "rejected");
    res.sendRedirect("/controller?request_type=admin");
}
  private double parseOrDefault(HttpServletRequest req, String k) {
    String v = req.getParameter(k);
    return (v == null || v.isEmpty()) 
      ? 0.0 
     : Double.parseDouble(v);
  }

  private void oneHotFeatures(HttpServletRequest req, String k, double[] f, int i, String... opts) {
    String v = req.getParameter(k);
    for (String o : opts) f[i++] = o.equals(v) ? 1.0 : 0.0;
  }


  private String buildEncodedJsonFeatures(HttpServletRequest req) {
    String[] numFields = {
      "age","blood_pressure","urine_specific_gravity","albumin","sugar",
      "blood_glucose_random","blood_urea","serum_creatinine","sodium","potassium",
      "hemoglobin","packed_cell_volume","white_blood_cell_count","red_blood_cell_count"
    };
    double[] features = new double[44];
    for (int i = 0; i < numFields.length; i++)
      features[i] = parseOrDefault(req, numFields[i]);

    oneHotFeatures(req, "red_blood_cells_urine", features, 14, "missing","normal","abnormal");
    oneHotFeatures(req, "pus_cells", features, 17, "normal","abnormal","missing");
    oneHotFeatures(req, "pus_cell_clumps", features, 20, "notpresent","present","missing");
    oneHotFeatures(req, "bacteria", features, 23, "notpresent","present","missing");
    oneHotFeatures(req, "hypertension", features, 26, "yes","no","missing");
    oneHotFeatures(req, "diabetes_mellitus", features, 29, "yes","no","missing");
    oneHotFeatures(req, "coronary_artery_disease", features, 32, "no","yes","missing");
    oneHotFeatures(req, "appetite", features, 35, "good","poor","missing");
    oneHotFeatures(req, "pedal_edema", features, 38, "no","yes","missing");
    oneHotFeatures(req, "anemia", features, 41, "no","yes","missing");

    Map<String, Object> payload = new HashMap<>();
    payload.put("request_type", "prediction");
    payload.put("nom_de_modele", "random_forest.pkl");
    payload.put("features", features);
    return new Gson().toJson(payload);
  }

  static String[] allFeatures = {
    "age", "blood_pressure", "urine_specific_gravity", "albumin", "sugar",
    "blood_glucose_random", "blood_urea", "serum_creatinine", "sodium", "potassium",
    "hemoglobin", "packed_cell_volume", "white_blood_cell_count", "red_blood_cell_count",
    "red_blood_cells_urine", "pus_cells", "pus_cell_clumps", "bacteria",
    "hypertension", "diabetes_mellitus", "coronary_artery_disease", "appetite",
    "pedal_edema", "anemia"
  };

  public static String extractFeaturesFromReq(HttpServletRequest request) {
    JsonObject json = new JsonObject();

    for (String field : allFeatures) {
      String raw = request.getParameter(field);
      if (raw != null && !raw.isBlank()) {
        try {
          if (!raw.contains(".")) {
            json.addProperty(field, Long.parseLong(raw.trim()));
          } else {
            json.addProperty(field, Double.parseDouble(raw.trim()));
          }
        } catch (NumberFormatException e) {
          json.addProperty(field, raw.trim());
        }
      }
    }

    return new Gson().toJson(json);
  }

  private void reverseOneHot(Map<String, String> params, String key, double[] features, int startIndex, String... opts) {
    String resolved = null;
    for (int i = 0; i < opts.length; i++) {
      if (features[startIndex + i] == 1.0) {
        resolved = opts[i];
        break;
      }
    }
    if (resolved != null && !resolved.equals("missing"))
      params.put(key, resolved);
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
