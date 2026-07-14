package com.mealtime.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	private static final String URL="jdbc:mysql://localhost:3306/mealtimedb";
	private static final String USERNAME = "root";
	private static final String PASSWORD = "Sarika9#";
	
	
	public static final Connection getConnection(){
		Connection connection = null;
		
		try {
			// load the driver
			Class.forName("com.mysql.cj.jdbc.Driver");
			// establish a connection
			connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;	
	}
}
 