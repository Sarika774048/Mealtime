package com.mealtime.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.mealtime.dao.RestaurantDao;
import com.mealtime.model.Restaurant;
import com.mealtime.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT_QUERY =
            "INSERT INTO restaurant(name, address, phone, cuisineType, eta, adminUserId, imagePath) VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_QUERY =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String UPDATE_QUERY =
            "UPDATE restaurant SET name = ?, address = ?, phone = ? WHERE restaurantId = ?";

    private static final String DELETE_QUERY =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    private static final String GET_ALL_RESTAURANT =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_RESTAURANT_QUERY)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getAddress());
            statement.setString(3, restaurant.getPhone());
            statement.setString(4, restaurant.getCuisineType());
            statement.setString(5, restaurant.getEta());
            statement.setInt(6, restaurant.getAdminUserId());
            statement.setString(7, restaurant.getImagePath());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurat(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_QUERY)) {

            statement.setInt(1, restaurantId);

            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                restaurant = extractRestaurant(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_QUERY)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getAddress());
            statement.setString(3, restaurant.getPhone());
            statement.setInt(4, restaurant.getRestaurantid());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, restaurantId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurant() {

        List<Restaurant> list = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement()) {

            ResultSet rs = statement.executeQuery(GET_ALL_RESTAURANT);

            while (rs.next()) {
                list.add(extractRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    private Restaurant extractRestaurant(ResultSet rs) throws SQLException {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantid(rs.getInt("restaurantId"));
        restaurant.setName(rs.getString("name"));
        restaurant.setAddress(rs.getString("address"));
        restaurant.setPhone(rs.getString("phone"));
        restaurant.setRating(rs.getInt("rating"));

        // Change this to setCusineType() if that's what your model uses
        restaurant.setCusineType(rs.getString("cuisineType"));

        restaurant.setActive(rs.getBoolean("isActive"));
        restaurant.setEta(rs.getString("eta"));
        restaurant.setAdminUserId(rs.getInt("adminUserId"));
        restaurant.setImagePath(rs.getString("imagePath"));

        return restaurant;
    }
}