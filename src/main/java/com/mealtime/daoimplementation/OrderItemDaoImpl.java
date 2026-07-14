package com.mealtime.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.mealtime.dao.OrderItemDao;
import com.mealtime.model.OrderItem;
import com.mealtime.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao{
	
	private static final String INSERT_QUERY = "INSERT INTO `orderitem` (`orderId`, `menuid`, `quantity`, `totalPrice`) values (?, ?, ?, ?)";
	
	private static final String GET_ORDER_ITEM = "SELECT * FROM `orderItem` WHERE `orderItemId` = ?";
	
	private static final String DELETE_ORDER_ITEM = "DELETE FROM `orderitem` where `orderItemId` = ? ";
	
	private static final String GET_ALL_ORDER_ITEMS = "SELECT * FROM `orderitem` WHERE `orderId` = ?";
	
	private static final String UPDATE_ORDER_ITEM = "UPDATE `orderitem` SET `quantity` = ? WHERE `orderItemId` = ?";
	


	@Override
	public void addOrderItem(OrderItem orderItem) {
		
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(INSERT_QUERY);){
			
			statement.setInt(1, orderItem.getOrderId());
			statement.setInt(2, orderItem.getMenuId());
			statement.setInt(3, orderItem.getQuantity());
			statement.setDouble(4, orderItem.getTotalPrice()); 
			
			statement.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	

	@Override
	public OrderItem getOrderItem(int orderItemId) {
		
		OrderItem orderItem = null;
		
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(GET_ORDER_ITEM);){
				statement.setInt(1, orderItemId);
				ResultSet executeQuery = statement.executeQuery();
				
				if(executeQuery.next()) {
				orderItem = extractOrderItem(executeQuery);
				}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return orderItem;
	}

	

	@Override
	public void updateOrderItem(OrderItem orderItem) {
		
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(UPDATE_ORDER_ITEM);)
		{	
			statement.setInt(1, orderItem.getQuantity());
			statement.setInt(2, orderItem.getOrderItemId());
			statement.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteOrderItem(int orderItemId) {
		
		try(Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(DELETE_ORDER_ITEM);)
		{	
			statement.setInt(1, orderItemId);
			statement.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
 
	@Override
	public List<OrderItem> getOrderItemByOrder(int orderId) {
		
		List<OrderItem> list = new ArrayList<>();
		
		try(	Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(GET_ALL_ORDER_ITEMS);){
			statement.setInt(1, orderId);
			ResultSet executeQuery = statement.executeQuery();
			while(executeQuery.next()) {
				list.add(extractOrderItem(executeQuery));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
	
		return list;
	}
	
	
	private OrderItem extractOrderItem(ResultSet executeQuery) {
		
		OrderItem orderItem = new OrderItem();
		
		try {
			
			orderItem.setOrderItemId(executeQuery.getInt("orderItemId"));
			orderItem.setOrderId(executeQuery.getInt("orderId"));
			orderItem.setMenuId(executeQuery.getInt("menuId"));
			orderItem.setQuantity(executeQuery.getInt("quantity"));
			orderItem.setTotalPrice(executeQuery.getDouble("totalPrice"));
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		return orderItem;
	}
	
	

}
