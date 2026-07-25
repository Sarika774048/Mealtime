package com.mealtime.servlet;

import java.io.IOException;
import java.util.Date;

import com.mealtime.daoimplementation.OrderDaoImple;
import com.mealtime.daoimplementation.OrderItemDaoImpl;
import com.mealtime.daoimplementation.UserDaoImple;
import com.mealtime.model.Cart;
import com.mealtime.model.CartItem;
import com.mealtime.model.Order;
import com.mealtime.model.OrderItem;
import com.mealtime.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect("checkout.jsp?error=Your+cart+is+empty.");
            return;
        }

        // Form parameters from checkout.jsp
        String restaurantIdStr = req.getParameter("restaurantId");
        String paymentMode = req.getParameter("paymentMode");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Save delivery info in session for pre-filling in future
        if (name != null) session.setAttribute("name", name);
        if (phone != null) session.setAttribute("phone", phone);
        if (address != null) session.setAttribute("address", address);

        // Calculate order amounts
        double itemSubtotal = 0.0;
        int restaurantId = 0;

        for (CartItem item : cart.getItems().values()) {
            itemSubtotal += item.getTotalprice();
            if (restaurantId == 0) {
                restaurantId = item.getRestaurantId();
            }
        }

        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantIdStr);
            } catch (NumberFormatException e) {
                // keep default extracted from cart items
            }
        }

        double deliveryFee = (itemSubtotal > 500 || itemSubtotal == 0) ? 0.0 : 40.0;
        double taxAndPackaging = (itemSubtotal > 0) ? Math.round((itemSubtotal * 0.05 + 15) * 100.0) / 100.0 : 0.0;
        double grandTotal = itemSubtotal + deliveryFee + taxAndPackaging;

        // Resolve logged-in User
        User user = (User) session.getAttribute("user");
        String email = (String) session.getAttribute("email");
        if (user == null && email != null && !email.trim().isEmpty()) {
            user = new UserDaoImple().getUserByEmail(email.trim());
            if (user != null) {
                session.setAttribute("user", user);
            }
        }

        // Strictly enforce authentication before placing order
        if (user == null) {
            session.setAttribute("redirectAfterLogin", "checkout.jsp");
            resp.sendRedirect("login.html?error=Please+login+or+sign+up+to+complete+your+order.");
            return;
        }

        int userId = user.getUserId();

        // Construct and insert Order into Database
        Order order = new Order();
        order.setUserId(userId);
        order.setRestaurantId(restaurantId);
        order.setOrderDate(new Date());
        order.setTotalAmount(grandTotal);
        order.setStatus("Placed");
        order.setPaymentMode(paymentMode != null ? paymentMode : "Cash on Delivery");

        OrderDaoImple orderDao = new OrderDaoImple();
        int orderId = orderDao.addOrder(order);

        // Insert individual OrderItems into Database
        if (orderId > 0) {
            OrderItemDaoImpl orderItemDao = new OrderItemDaoImpl();
            for (CartItem item : cart.getItems().values()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setMenuId(item.getMenuId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setTotalPrice(item.getTotalprice());

                orderItemDao.addOrderItem(orderItem);
            }
        }

        // Store latest order details in session & clear cart
        session.setAttribute("orderId", orderId);
        session.setAttribute("latestOrder", order);
        cart.clear();

        // Redirect to order confirmation page
        resp.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("checkout.jsp");
    }
}
