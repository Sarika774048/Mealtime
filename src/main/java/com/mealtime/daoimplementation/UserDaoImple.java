package com.mealtime.daoimplementation;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import com.mealtime.dao.UserDao;
import com.mealtime.model.User;
import com.mealtime.util.DBConnection;

public class UserDaoImple implements UserDao {

	private static final String INSERT_USER_QUERY = "INSERT INTO `users`(`name`, `username`, `password`, `email`, `phone`, `address`, `role`, `created_date`) VALUES(?, ?, ?, ?, ?, ?, ?, CURDATE())";
	private static final String SELECT_QUERY = "SELECT * FROM `users` WHERE user_id = ?";
	private static final String UPDATE_QUERY = "UPDATE `users` SET `name` = ?, `password` = ?, `phone` = ?, `address` = ?, `role` = ? WHERE `user_id` = ?";
	private static final String DELETE_USER = "DELETE FROM `users` WHERE `user_id` = ?";
	private static final String GET_ALL_USERS = "SELECT * FROM `users`";
	
	// Query adjusted to match the new encryption verification logic
	private static final String GET_USER_BY_EMAIL = "SELECT `password` FROM `users` WHERE `email` = ?";

	// Helper method to hash plaintext strings into SHA-256 strings using standard Java
	private String hashPassword(String plaintextPassword) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hashBytes = digest.digest(plaintextPassword.getBytes(StandardCharsets.UTF_8));
			return Base64.getEncoder().encodeToString(hashBytes); // Converts raw bytes into a safe text string
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return plaintextPassword; // Fallback
		}
	}

	@Override
	public int addUser(User user) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement prepareStatement = connection.prepareStatement(INSERT_USER_QUERY)) {

			prepareStatement.setString(1, user.getName());
			prepareStatement.setString(2, user.getUsername());
			
			// Encrypt password natively before database insertion
			String securePassword = hashPassword(user.getPassword());
			prepareStatement.setString(3, securePassword);
			
			prepareStatement.setString(4, user.getEmail());
			prepareStatement.setString(5, user.getPhone());
			prepareStatement.setString(6, user.getAddress());
			prepareStatement.setString(7, user.getRole());
			
			return prepareStatement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public User getUser(int userId) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(SELECT_QUERY)) {
			
			preparedStatement.setInt(1, userId);
			try (ResultSet res = preparedStatement.executeQuery()) {
				return extractUser(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void updateUser(User user) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY)) {
			
			preparedStatement.setString(1, user.getName());
			preparedStatement.setString(2, hashPassword(user.getPassword())); // Encrypt on update too
			preparedStatement.setString(3, user.getPhone());
			preparedStatement.setString(4, user.getAddress());
			preparedStatement.setString(5, user.getRole());
			preparedStatement.setInt(6, user.getUserId());
			
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deletUser(int userId) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(DELETE_USER)) {	
			
			preparedStatement.setInt(1, userId);
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<User> getAllUsers() {
		List<User> list = new ArrayList<>();
		try (Connection connection = DBConnection.getConnection();
			 Statement statement = connection.createStatement();
			 ResultSet res = statement.executeQuery(GET_ALL_USERS)) {
			
			while (res.next()) {
				String name = res.getString("name");
				String username = res.getString("username");
				String password = res.getString("password");
				String email = res.getString("email");
				String phone = res.getString("phone");
				String address = res.getString("address");
				String role = res.getString("role");
				
				User user = new User(name, username, password, email, phone, address, role, null, null);
				user.setUserId(res.getInt("user_id"));
				list.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	} 

	private User extractUser(ResultSet res) throws SQLException {
		if (res.next()) { // Corrected pointer movement
			String name = res.getString("name");
			String username = res.getString("username");
			String password = res.getString("password");
			String email = res.getString("email");
			String phone = res.getString("phone");
			String address = res.getString("address");
			String role = res.getString("role");
			
			User user = new User(name, username, password, email, phone, address, role, null, null);
			user.setUserId(res.getInt("user_id"));
			return user;
		}
		return null;
	}

	public int getUserByEmailAndPassword(String email, String plainPassword) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement stmt = connection.prepareStatement(GET_USER_BY_EMAIL)) { // Fixed variable reference syntax
			
			stmt.setString(1, email);
			try (ResultSet executeQuery = stmt.executeQuery()) {
				if (executeQuery.next()) {
					String storedHashedPassword = executeQuery.getString("password");
					
					// Hash the incoming login attempt text and check if it matches the stored hash
					String incomingHashedPassword = hashPassword(plainPassword);
					if (incomingHashedPassword.equals(storedHashedPassword) || plainPassword.equals(storedHashedPassword)) {
						return 1; 
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
}
