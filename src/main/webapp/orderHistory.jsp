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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">

    <!-- Modern Web Engine JS -->
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Embedded High-Priority Modern CSS Styling for Order History -->
    <style>
        body {
            background-color: #F8F3EC !important;
            color: #42341E !important;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
        }

        .history-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 20px !important;
            padding: 28px 32px !important;
            margin-bottom: 24px !important;
            box-shadow: 0 6px 24px rgba(66, 52, 30, 0.05) !important;
            transition: all 0.25s ease !important;
        }

        .history-card:hover {
            box-shadow: 0 10px 32px rgba(66, 52, 30, 0.08) !important;
            transform: translateY(-2px) !important;
        }

        .history-header {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding-bottom: 16px !important;
            border-bottom: 1px solid #EFE6D8 !important;
            margin-bottom: 18px !important;
        }

        .order-id-tag {
            font-size: 1.05rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }

        .order-date-text {
            font-size: 0.84rem !important;
            color: #8C7B68 !important;
            font-weight: 500 !important;
        }

        .status-pill {
            background: #ECFDF5 !important;
            color: #047857 !important;
            border: 1px solid #A7F3D0 !important;
            padding: 5px 16px !important;
            border-radius: 20px !important;
            font-size: 0.85rem !important;
            font-weight: 800 !important;
        }

        .history-items-list {
            display: flex !important;
            flex-direction: column !important;
            gap: 10px !important;
            margin-bottom: 20px !important;
        }

        .history-item-row {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding: 12px 18px !important;
            background: #FAF6F0 !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 12px !important;
            font-size: 0.95rem !important;
            color: #3E3220 !important;
            font-weight: 600 !important;
        }

        .history-footer {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding-top: 18px !important;
            border-top: 1px dashed #DCD1C2 !important;
            font-size: 0.92rem !important;
            color: #7A6C5B !important;
            font-weight: 600 !important;
        }

        .total-amount-val {
            font-size: 1.2rem !important;
            font-weight: 800 !important;
            color: #CB4F1B !important;
            background: #FFFBEB !important;
            border: 1px solid #FDE68A !important;
            padding: 4px 16px !important;
            border-radius: 8px !important;
        }
    </style>
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
                                    String itemName = (menuItem != null && menuItem.getItemName() != null && !menuItem.getItemName().isEmpty()) 
                                                     ? menuItem.getItemName() 
                                                     : "Food Item #" + (item.getMenuId() > 0 ? item.getMenuId() : "1");
                                    double priceVal = item.getTotalPrice() > 0 ? item.getTotalPrice() : ord.getTotalAmount();
                            %>
                                <div class="history-item-row">
                                    <span>🍲 <%= item.getQuantity() > 0 ? item.getQuantity() : 1 %>x <%= itemName %></span>
                                    <span>₹<%= String.format("%.2f", priceVal) %></span>
                                </div>
                            <%  } 
                               } else { %>
                                <div class="history-item-row">
                                    <span>🍲 1x Prepared Meal Order</span>
                                    <span>₹<%= String.format("%.2f", ord.getTotalAmount()) %></span>
                                </div>
                            <% } %>
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
