<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mealtime.model.Order" %>
<%@ page import="com.mealtime.daoimplementation.OrderDaoImple" %>

<%
    String orderIdParam = request.getParameter("orderId");
    Order order = (Order) session.getAttribute("latestOrder");

    if (order == null && orderIdParam != null) {
        try {
            int orderId = Integer.parseInt(orderIdParam);
            order = new OrderDaoImple().getOrder(orderId);
        } catch (Exception e) {
            order = null;
        }
    }

    String customerName = (String) session.getAttribute("name");
    String customerAddress = (String) session.getAttribute("address");
    if (customerName == null) customerName = "Customer";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | Mealtime</title>

    <!-- External CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/cart.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/checkout.css?v=999">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

</head>
<body style="background-color: #FBF4EB !important; color: #42341E !important;">

    <!-- Header / Navbar -->
    <header class="navbar">
        <a href="home" class="logo">
            <span class="logo-icon">🍽</span>
            Meal<span>time</span>
        </a>

        <nav class="nav-links">
            <a href="home">Home</a>
            <a href="home#restaurants">Restaurants</a>
            <a href="orderHistory.jsp">Order History</a>
            <a href="home#about">About Us</a>
        </nav>
    </header>

    <main class="checkout-page">
        <div class="confirmation-card">
            <div class="success-icon-badge">✓</div>
            <h1>Order Placed Successfully!</h1>
            <p class="confirmation-subtitle">Thank you for ordering with Mealtime. Your delicious food is being prepared!</p>

            <% if (order != null) { %>
                <div class="receipt-box">
                    <div class="receipt-row">
                        <span class="receipt-label">Order Reference ID</span>
                        <span class="receipt-val" style="color: var(--primary);">#ORD-<%= order.getOrderId() %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Order Date & Time</span>
                        <span class="receipt-val"><%= order.getOrderDate() != null ? order.getOrderDate() : "Just now" %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Total Amount Paid</span>
                        <span class="receipt-val" style="color: var(--primary); font-weight: 700;">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Payment Mode</span>
                        <span class="receipt-val"><%= order.getPaymentMode() %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Status</span>
                        <span class="receipt-val" style="color: var(--green);">● <%= order.getStatus() %></span>
                    </div>

                    <% if (customerAddress != null && !customerAddress.trim().isEmpty()) { %>
                        <div class="receipt-row">
                            <span class="receipt-label">Deliver To</span>
                            <span class="receipt-val" style="text-align: right; max-width: 260px;"><%= customerAddress %></span>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <div class="action-btns-row">
                <a href="orderHistory.jsp" class="btn-secondary">📋 View Order History</a>
                <a href="home" class="explore-btn">🍽 Order More Food</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer id="about">
        <a href="home" class="logo footer-logo">
            <span class="logo-icon">🍽</span>
            Meal<span>time</span>
        </a>
        <p>© 2026 Mealtime. Made for food lovers.</p>
    </footer>

</body>
</html>
