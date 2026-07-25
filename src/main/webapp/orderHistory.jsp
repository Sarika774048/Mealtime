<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mealtime.model.Order" %>
<%@ page import="com.mealtime.model.OrderItem" %>
<%@ page import="com.mealtime.model.User" %>
<%@ page import="com.mealtime.model.Menu" %>
<%@ page import="com.mealtime.daoimplementation.OrderDaoImple" %>
<%@ page import="com.mealtime.daoimplementation.OrderItemDaoImpl" %>
<%@ page import="com.mealtime.daoimplementation.UserDaoImple" %>
<%@ page import="com.mealtime.daoimplementation.MenuDaoImpl" %>

<%
    User sessionUser = (User) session.getAttribute("user");
    String email = (String) session.getAttribute("email");

    if (sessionUser == null && email != null && !email.trim().isEmpty()) {
        sessionUser = new UserDaoImple().getUserByEmail(email.trim());
        if (sessionUser != null) {
            session.setAttribute("user", sessionUser);
        }
    }

    int userId = (sessionUser != null) ? sessionUser.getUserId() : 1;

    OrderDaoImple orderDao = new OrderDaoImple();
    OrderItemDaoImpl orderItemDao = new OrderItemDaoImpl();
    MenuDaoImpl menuDao = new MenuDaoImpl();

    List<Order> orderList = orderDao.getAllOrderByUser(userId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | Mealtime</title>

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
            <a href="orderHistory.jsp" class="active" style="color: var(--primary); font-weight: 600;">Order History</a>
            <a href="home#about">About Us</a>
        </nav>
    </header>

    <main class="checkout-page">
        <a href="home" class="back-link">← Back to Home</a>

        <div class="checkout-header-row">
            <div class="checkout-title-area">
                <h1>Your Order History <% if (orderList != null && !orderList.isEmpty()) { %><span class="cart-count-badge"><%= orderList.size() %> <%= orderList.size() == 1 ? "Order" : "Orders" %></span><% } %></h1>
            </div>
        </div>

        <% if (orderList == null || orderList.isEmpty()) { %>
            <div class="empty-cart-card">
                <span class="empty-cart-icon">📜</span>
                <h2>No Orders Found</h2>
                <p>You haven't placed any orders yet. Check out our menu and place your first order!</p>
                <a href="home" class="explore-btn">
                    <span>Explore Restaurants</span> →
                </a>
            </div>
        <% } else { %>
            <div style="max-width: 800px; margin: 0 auto;">
                <% for (Order ord : orderList) { 
                    List<OrderItem> items = orderItemDao.getOrderItemByOrder(ord.getOrderId());
                %>
                    <div class="history-card">
                        <div class="history-header">
                            <div class="order-id-tag">
                                📦 Order #ORD-<%= ord.getOrderId() %>
                                <span class="order-date-text">• <%= ord.getOrderDate() %></span>
                            </div>
                            <span class="status-pill">● <%= ord.getStatus() %></span>
                        </div>

                        <div class="history-items-list">
                            <% if (items != null && !items.isEmpty()) { 
                                for (OrderItem item : items) { 
                                    Menu menuItem = menuDao.getMenuById(item.getMenuId());
                                    String itemName = (menuItem != null) ? menuItem.getItemName() : "Item #" + item.getMenuId();
                            %>
                                <div class="history-item-row">
                                    <span><%= item.getQuantity() %>x <%= itemName %></span>
                                    <span>₹<%= String.format("%.2f", item.getTotalPrice()) %></span>
                                </div>
                            <%  } 
                               } %>
                        </div>

                        <div class="history-footer">
                            <span style="color: var(--text-secondary);">Payment: <strong style="color: var(--heading);"><%= ord.getPaymentMode() %></strong></span>
                            <div>
                                <span style="color: var(--text-secondary); margin-right: 8px;">Total:</span>
                                <span class="total-amount-val">₹<%= String.format("%.2f", ord.getTotalAmount()) %></span>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
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
