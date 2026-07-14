package com.mealtime.servlet;

import java.io.IOException;
import java.util.List;

import com.mealtime.daoimplementation.RestaurantDaoImpl;
import com.mealtime.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		RestaurantDaoImpl restaurant = new RestaurantDaoImpl();
		List<Restaurant> allRestaurant = restaurant.getAllRestaurant();
		
		
		
		req.setAttribute("list", allRestaurant);
		
		RequestDispatcher requestDispatcher = req.getRequestDispatcher("Restaurant.jsp");
		requestDispatcher.forward(req, resp);
		
	}
}
