package com.mealtime.dao;

import java.util.List;

import com.mealtime.model.User;

public interface UserDao {
	int addUser(User user);
	User getUser(int userId);
	void updateUser(User user);
	void deletUser(int userId);
	List<User> getAllUsers();
}
