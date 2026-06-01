package db;

import beans.User;
import beans.Prediction;
import beans.AdminRequest;

import org.mindrot.jbcrypt.BCrypt;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;

import java.util.ArrayList;
public class DAOClass {
  String dbHost = System.getenv("DB_HOST");
  String dbName = System.getenv("DB_NAME");
  String dbPort = System.getenv("DB_PORT");
  String dbUser = System.getenv("DB_USER");
  String dbPassword = System.getenv("DB_PASSWORD");
  Connection connection = null;

  public DAOClass() 
      throws SQLException, ClassNotFoundException {
    Class.forName("org.mariadb.jdbc.Driver");
    String dbUrl = String.format("jdbc:mariadb://%s:%s/%s", dbHost, dbPort, dbName);
    connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
  }

  ResultSet findUserByEmail(String email) 
      throws SQLException{
    String sql = "SELECT * FROM Users WHERE email=?";
    PreparedStatement stmt = connection.prepareStatement(sql);
    stmt.setString(1, email);
    return stmt.executeQuery();
  }

  boolean insertNewUser(User newUser)
      throws SQLException {
    String sql =  
      "INSERT INTO Users (firstName, lastName, age, gender, email, password) " +
      "VALUES (?, ?, ?, ?, ?, ?)";
    try(PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, newUser.getFirstName());
      stmt.setString(2, newUser.getLastName());
      stmt.setInt(3, newUser.getAge());
      stmt.setString(4, newUser.getGender());
      stmt.setString(5, newUser.getEmail());
      stmt.setString(6, BCrypt.hashpw(newUser.getPassword(), BCrypt.gensalt()));
      return stmt.executeUpdate() != 0;
    }
  }

  public User validateLogin(User targetInfo)
      throws SQLException {
    try(ResultSet row = findUserByEmail(targetInfo.getEmail())) {
      if(row.next()) {
        User fetchedUser = new User(row);
        if(BCrypt.checkpw(targetInfo.getPassword(), fetchedUser.getPassword())) {
          return fetchedUser;
        }
      }
      return null;
    }
  }

  public User registerNewUser(User targetInfo)
      throws SQLException {
    try(ResultSet row = findUserByEmail(targetInfo.getEmail())) {
      if(!row.next()) {
        if(insertNewUser(targetInfo))
          return getUser(targetInfo.getEmail());
      }
      return null;
    }
  }

  public boolean updateUserInfo(User targetInfo) 
      throws SQLException {
    String sql =
      "UPDATE Users SET firstName = ?, lastName = ?, age = ?, gender = ? " +
      "WHERE email = ?";
    try(PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, targetInfo.getFirstName());
      stmt.setString(2, targetInfo.getLastName());
      stmt.setInt(3, targetInfo.getAge());
      stmt.setString(4, targetInfo.getGender());
      stmt.setString(5, targetInfo.getEmail());
      return stmt.executeUpdate() != 0;
    }
  }

  public ArrayList<Prediction> getUserHistory(int userId) throws SQLException {
    ArrayList<Prediction> historyList = new ArrayList<>();
    String sql = "SELECT * FROM History WHERE user_id = ? ORDER BY created_at DESC";
    try(PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setInt(1, userId);
      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          Prediction pre = new Prediction();
          pre.setHistoryId(rs.getInt("history_id"));
          pre.setUserId(rs.getInt("user_id"));
          pre.setInputFeatures(rs.getString("inputed_features"));
          pre.setPredictionRes(rs.getInt("prediction_res"));
          pre.setPredictionProbability(rs.getInt("prediction_probability"));
          pre.setDate(rs.getString("created_at"));
          historyList.add(pre);
        }
      }
    }
    return historyList; 
  }

  public User getUser(String email) 
    throws SQLException {
    try(ResultSet row = findUserByEmail(email)) {
      if(row.next()) {
        return new User(row);
      }
      return null;
    }
  }

  public ArrayList<User> getAllUsers() throws SQLException {
    ArrayList<User> allusers = new ArrayList<>();
    String sql = "SELECT * FROM Users ORDER BY created_at DESC";
    try (Statement stmt = connection.createStatement()) {
      try (ResultSet rs = stmt.executeQuery(sql);) {
        while (rs.next()) {
          User user = new User();
          user.setUserId(rs.getInt("user_id"));
          user.setFirstName(rs.getString("firstName"));
          user.setLastName(rs.getString("lastName"));
          user.setAge(rs.getInt("age"));
          user.setGender(rs.getString("gender"));
          user.setEmail(rs.getString("email"));
          allusers.add(user);
        }
      }
    }
    return allusers ; 
  }
  
  public boolean insertNewPrediction(int userId, String features, int predictionRes, int PredictionProbability ) 
      throws SQLException {
    String sql = 
      "INSERT INTO History (user_id, inputed_features, prediction_res, prediction_probability)" +
      "VALUES (?, ?, ?, ?)";

      try(PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        stmt.setString(2, features);
        stmt.setInt(3, predictionRes);
        stmt.setInt(4, PredictionProbability);
        return stmt.executeUpdate() != 0;
      }
  }
  public void createModRequest(int userId, String message) throws SQLException {
    String sql = "INSERT INTO moderation_requests (user_id, message) VALUES (?, ?)";
    try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
        pstmt.setInt(1, userId);
        pstmt.setString(2, message);
        pstmt.executeUpdate();
    }
  }
  public ArrayList<AdminRequest> getPendingModRequests() throws SQLException {
    ArrayList<AdminRequest> requests = new ArrayList<>();
    String sql = "SELECT mr.id, mr.user_id, mr.message, u.email "+
                 "FROM Admin_requests mr "+
                 "JOIN Users u ON mr.user_id=u.user_id "+
                 "WHERE mr.status='pending'";
                 
    try(Statement stmt = connection.createStatement();
         ResultSet rs = stmt.executeQuery(sql)){
        while (rs.next()) {
            AdminRequest req = new AdminRequest();
            req.setId(rs.getInt("id"));
            req.setUserId(rs.getInt("user_id"));
            req.setMessage(rs.getString("message"));
            req.setEmail(rs.getString("email"));
            requests.add(req);
        }
    }
    return requests;
}
  public void updateUserRole(int userId, String role) throws SQLException {
      String sql = "UPDATE Users SET role = ? WHERE user_id = ?";
      try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
          pstmt.setString(1, role);
          pstmt.setInt(2, userId);
          pstmt.executeUpdate();
      }
    }
    public void updateRequestStatus(int requestId, String status) throws SQLException {
    String sql = "UPDATE moderation_requests SET status = ? WHERE id = ?";
    try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
        pstmt.setString(1, status);
        pstmt.setInt(2, requestId);
        pstmt.executeUpdate();
    }
  }
}
