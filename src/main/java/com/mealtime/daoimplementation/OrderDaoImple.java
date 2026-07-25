package com.mealtime.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.mealtime.dao.OrderDao;
import com.mealtime.model.Order;
import com.mealtime.util.DBConnection;

public class OrderDaoImple implements OrderDao {

    private static final String INSERT_ORDER_QUERY = 
            "INSERT INTO `orders` (`user_id`, `restaurant_id`, `order_date`, `total_amount`, `status`, `payment_mode`) VALUES (?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_ORDER_QUERY = 
            "SELECT * FROM `orders` WHERE `order_id` = ?";
    
    private static final String UPDATE_ORDER_QUERY = 
            "UPDATE `orders` SET `status` = ? WHERE `order_id` = ?";
    
    private static final String DELETE_ORDER_QUERY = 
            "DELETE FROM `orders` WHERE `order_id` = ?";
    
    private static final String GET_ALL_ORDER_BY_USER = 
            "SELECT * FROM `orders` WHERE `user_id` = ? ORDER BY `order_date` DESC";

    @Override
    public int addOrder(Order order) {
        int generatedOrderId = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_ORDER_QUERY, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, order.getUserId());
            statement.setInt(2, order.getRestaurantId());
            
            Timestamp orderTimestamp = (order.getOrderDate() != null) 
                    ? new Timestamp(order.getOrderDate().getTime()) 
                    : new Timestamp(System.currentTimeMillis());
            statement.setTimestamp(3, orderTimestamp);
            
            statement.setDouble(4, order.getTotalAmount());
            statement.setString(5, order.getStatus() != null ? order.getStatus() : "Placed");
            statement.setString(6, order.getPaymentMode());

            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedOrderId = generatedKeys.getInt(1);
                        order.setOrderId(generatedOrderId);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedOrderId;
    }

    @Override
    public Order getOrder(int orderId) {
        Order order = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ORDER_QUERY)) {
            
            statement.setInt(1, orderId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    order = extractOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public void updateOrder(Order order) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ORDER_QUERY)) {
            
            statement.setString(1, order.getStatus());
            statement.setInt(2, order.getOrderId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_ORDER_QUERY)) {
            
            statement.setInt(1, orderId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrderByUser(int userId) {
        List<Order> list = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_ORDER_BY_USER)) {
            
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getInt("restaurant_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMode(rs.getString("payment_mode"));
        return order;
    }
}
