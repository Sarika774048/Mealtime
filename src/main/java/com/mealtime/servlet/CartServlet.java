package com.mealtime.servlet;

import java.io.IOException;

import com.mealtime.daoimplementation.MenuDaoImpl;
import com.mealtime.model.Cart;
import com.mealtime.model.CartItem;
import com.mealtime.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		Cart cart = (Cart) session.getAttribute("cart");
		Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");
		
		String restaurantIdStr = req.getParameter("restaurantId");
		int newRestaurantId = 0;
		
		if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
			try {
				newRestaurantId = Integer.parseInt(restaurantIdStr.trim());
			} catch (NumberFormatException e) {
				if (sessionRestaurantId != null) {
					newRestaurantId = sessionRestaurantId;
				}
			}
		} else if (sessionRestaurantId != null) {
			newRestaurantId = sessionRestaurantId;
		}

		if (cart == null || sessionRestaurantId == null || (newRestaurantId > 0 && sessionRestaurantId != newRestaurantId)) {
			cart = new Cart();
			session.setAttribute("cart", cart);
			if (newRestaurantId > 0) {
				session.setAttribute("restaurantId", newRestaurantId);
			}
		}
		
		String action = req.getParameter("action");
		
		if (action != null) {
			if (action.equalsIgnoreCase("add")) {
				addToCart(req, cart);
			} else if (action.equalsIgnoreCase("update")) {
				updateCart(req, cart);
			} else if (action.equalsIgnoreCase("delete")) {
				deleteCartItem(req, cart);
			}
		}
		
		resp.sendRedirect("cart.jsp");
	}

	private void deleteCartItem(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
			try {
				int menuId = Integer.parseInt(menuIdStr.trim());
				cart.removeItem(menuId);
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
	}

	private void updateCart(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
			try {
				int menuId = Integer.parseInt(menuIdStr.trim());
				CartItem existingItem = cart.getItems().get(menuId);
				if (existingItem != null) {
					int newQuantity = existingItem.getQuantity() - 1;
					if (newQuantity <= 0) {
						cart.removeItem(menuId);
					} else {
						cart.updateItem(menuId, newQuantity);
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
	}

	private void addToCart(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		String quantityStr = req.getParameter("quantity");
		
		if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
			try {
				int menuId = Integer.parseInt(menuIdStr.trim());
				int quantity = 1;
				if (quantityStr != null && !quantityStr.trim().isEmpty()) {
					quantity = Integer.parseInt(quantityStr.trim());
				}
				
				MenuDaoImpl menuDaoImpl = new MenuDaoImpl();
				Menu menu = menuDaoImpl.getMenuById(menuId);
				
				if (menu != null) {
					CartItem cartItem = new CartItem(menuId, menu.getRestaurantId(), menu.getItemName(), menu.getPrice(), quantity);
					cart.addItem(cartItem);
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
	}
}

