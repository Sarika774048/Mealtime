package com.mealtime.dao;

import java.util.List;

import com.mealtime.model.Menu;

public interface MenuDao {
	void getMenu(int menuId);
	void updateMenu(Menu menu);
	void deleteMenu(int menuId);
	List<Menu> getAllMenusByRestaurant(int restaurantId);
	void addMenu(Menu menu);
}
