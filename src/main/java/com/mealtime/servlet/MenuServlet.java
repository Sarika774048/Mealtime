package com.mealtime.servlet;

import java.io.IOException;
import java.util.List;

import com.mealtime.daoimplementation.MenuDaoImpl;
import com.mealtime.daoimplementation.RestaurantDaoImpl;
import com.mealtime.model.Menu;
import com.mealtime.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/menu")
public class MenuServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		MenuDaoImpl menuDaoImpl = new MenuDaoImpl();
		int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
		List<Menu> allMenusByRestaurant = menuDaoImpl.getAllMenusByRestaurant(restaurantId);
		
		for(Menu menu : allMenusByRestaurant) {
			System.out.println(menu);
		}
		
		req.setAttribute("menu", allMenusByRestaurant);
		
		RequestDispatcher requestDispatcher = req.getRequestDispatcher("menu.jsp");
		
		requestDispatcher.forward(req, resp);
		
	}

}
