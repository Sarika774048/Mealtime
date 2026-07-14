package com.mealtime.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mealtime.dao.MenuDao;
import com.mealtime.model.Menu;
import com.mealtime.util.DBConnection;

public class MenuDaoImpl implements MenuDao{
	private static final String GET_MENU_BY_RESTAURANT = "SELECT * FROM menu WHERE restaurant_id = ?";
	

	@Override
	public void getMenu(int menuId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMenu(Menu menu) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteMenu(int menuId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Menu> getAllMenusByRestaurant(int restaurantId) {
		
		List<Menu> list = new ArrayList<>();
		
		
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(GET_MENU_BY_RESTAURANT);){
			
				statement.setInt(1, restaurantId);
				ResultSet executeQuery = statement.executeQuery();
				
				while(executeQuery.next()) {
				
				list.add(extractResult(executeQuery));
				
				}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		return list;
		
		
	}

	private Menu extractResult(ResultSet executeQuery) throws SQLException {
//		private int menuId;
//		private int restaurantId;
//		private String itemName;
//		private String description;
//		private double price;
//		private int ratings;
//		private boolean isAvailable;
//		private String imagePath;
		
		int menuId = executeQuery.getInt("menu_Id");
		int restaurantId = executeQuery.getInt("restaurant_Id");
		String itemName = executeQuery.getString("item_name");
		String description = executeQuery.getString("description");
		double price = executeQuery.getDouble("price");
		int ratings = executeQuery.getInt("ratings");
		boolean isAvailable = executeQuery.getBoolean("is_available");
		String imagePath = executeQuery.getString("image_path");
		
		return new Menu(menuId, restaurantId, itemName, description, price, ratings, isAvailable, imagePath);
		
	}

	@Override
	public void addMenu(Menu menu) {
		// TODO Auto-generated method stub
		
	}

}
