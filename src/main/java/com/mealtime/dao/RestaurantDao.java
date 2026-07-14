package com.mealtime.dao;

import java.util.List;

import com.mealtime.model.Restaurant;

public interface RestaurantDao {
	
	void addRestaurant(Restaurant restaurant);
	Restaurant getRestaurat(int restaurantId);
	void updateRestaurant(Restaurant restaurant);
	void deleteRestaurant(int restaurantId);
	List<Restaurant> getAllRestaurant();
}
