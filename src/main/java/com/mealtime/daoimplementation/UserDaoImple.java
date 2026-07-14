package com.mealtime.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.mealtime.dao.UserDao;
import com.mealtime.model.User;
import com.mealtime.util.DBConnection;

public class UserDaoImple implements UserDao{

	private static final String INSERT_USER_QUERY = "INSERT INTO `user`(`name`, `username`, `password`, `email`, `phone`, `address`, `role`) VALUES(?, ?, ?, ?, ?, ?, ?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM `user` WHERE userId= ? ";
	
	private static final String UPDATE_QUERY = "UPDATE `user` SET `name` = ?, `password` = ?, `phone` = ?, `address ` = ?, `role`  = ?";
	
	private static final String DELETE_USER= "DELETE FROM `user` WHERE `userId` = ?";
	
	private static final String GET_ALL_USERS = "SELECT * FROM `user`" ;
	
	@Override
	public void addUser(User user) {
	
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement prepareStatement = connection.prepareStatement(INSERT_USER_QUERY);
			){

			prepareStatement.setString(1, user.getName());
			prepareStatement.setString(2, user.getUsername());
			prepareStatement.setString(3, user.getPassword());
			prepareStatement.setString(4, user.getEmail());
			prepareStatement.setString(5, user.getPhone());
			prepareStatement.setString(6, user.getAddress());
			prepareStatement.setString(7, user.getRole());
			
			int res = prepareStatement.executeUpdate();
			System.out.println(res);
						
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public User getUser(int userId) {
	
		User user = null;
		
		try(Connection connection = DBConnection.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_QUERY);){
			
			preparedStatement.setInt(1, userId);
			
			ResultSet res = preparedStatement.executeQuery();	
			user = extractUser(res);
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		return user;
	}

	@Override
	public void updateUser(User user) {
				
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY);){
			
		preparedStatement.setString(1, user.getName());
		preparedStatement.setString(2, user.getPassword());
		preparedStatement.setString(3, user.getPhone());
		preparedStatement.setString(4, user.getAddress());
		preparedStatement.setString(5, user.getRole());
		
		int executeUpdate = preparedStatement.executeUpdate();
		
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deletUser(int userId) {
			
			try(Connection connection = DBConnection.getConnection();
					PreparedStatement preparedStatement = connection.prepareStatement(DELETE_USER);){	
				
			preparedStatement.setInt(1, userId);
			int executeUpdate = preparedStatement.executeUpdate();
			
			}catch(SQLException e) {
				e.printStackTrace();
			}
	}

	@Override
	public List<User> getAllUsers() {

		List<User> list = new ArrayList<User>();
		try (Connection connection = DBConnection.getConnection();
				Statement statement = connection.createStatement();){
			
				ResultSet res = statement.executeQuery(GET_ALL_USERS);
				while(res.next()) {
					User user = extractUser(res);
					list.add(user);
				}
				
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return list;
	} 

	User extractUser(ResultSet res) throws SQLException{
		
		int userId = res.getInt("userId");
		String name = res.getString("name");
		String username = res.getString("username");
		String password = res.getString("password");
		String email = res.getString("email");
		String phone = res.getString("phone");
		String address = res.getString("address");
		String role = res.getString("role");
		
		User user = new User(userId, name, username, password, email, phone, address, role, null, null);
		
		return user;
	}
	
}