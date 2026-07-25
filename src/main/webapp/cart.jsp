<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.mealtime.model.Cart" %>
<%@ page import="com.mealtime.model.CartItem" %>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> items = null;
    double itemSubtotal = 0.0;
    int totalItemsCount = 0;
    
    if (cart != null && cart.getItems() != null && !cart.getItems().isEmpty()) {
        items = cart.getItems();
        for (CartItem item : items.values()) {
            itemSubtotal += item.getTotalprice();
            totalItemsCount += item.getQuantity();
        }
    }
    
    double deliveryFee = (itemSubtotal > 500 || itemSubtotal == 0) ? 0.0 : 40.0;
    double taxAndPackaging = (itemSubtotal > 0) ? Math.round((itemSubtotal * 0.05 + 15) * 100.0) / 100.0 : 0.0;
    double grandTotal = itemSubtotal + deliveryFee + taxAndPackaging;

    Object sessionRestaurantId = session.getAttribute("restaurantId");
    String backToMenuUrl = (sessionRestaurantId != null) ? "menu?restaurantId=" + sessionRestaurantId : "home";

    boolean isLoggedIn = (session.getAttribute("user") != null || session.getAttribute("email") != null);
    String checkoutTargetUrl = isLoggedIn ? "checkout.jsp" : "login.html?error=Please+log+in+or+sign+up+to+proceed+with+checkout.";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | Mealtime</title>

    <!-- External CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/cart.css?v=999">

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
            <a href="home#offers">Offers</a>
            <a href="home#about">About Us</a>
        </nav>

        <div class="nav-actions">
            <a href="login.html" class="login-link">Log in</a>
            <a href="register.html" class="signup-btn">Sign up</a>
        </div>
    </header>

    <main class="cart-page">
        <a href="<%= backToMenuUrl %>" class="back-link">← Back to Menu</a>

        <div class="cart-header-row">
            <div class="cart-title-area">
                <h1>Your Cart <% if (totalItemsCount > 0) { %><span class="cart-count-badge"><%= totalItemsCount %> <%= totalItemsCount == 1 ? "Item" : "Items" %></span><% } %></h1>
            </div>
        </div>

        <% if (items == null || items.isEmpty()) { %>
            <!-- Empty Cart State -->
            <div class="empty-cart-card">
                <span class="empty-cart-icon">🛒</span>
                <h2>Your cart is empty</h2>
                <p>Good food is always waiting for you. Explore our top restaurants and add your favorite dishes to the cart!</p>
                <a href="home" class="explore-btn">
                    <span>Explore Restaurants</span> →
                </a>
            </div>
        <% } else { %>
            <!-- Active Cart Container -->
            <div class="cart-container">
                
                <!-- Left Column: Items List -->
                <div class="cart-items-card">
                    <div class="cart-items-header">
                        <span>Item</span>
                        <span>Price</span>
                        <span>Quantity</span>
                        <span>Subtotal</span>
                        <span>Action</span>
                    </div>

                    <% for (CartItem item : items.values()) { %>
                        <div class="cart-item-row">
                            <div class="cart-item-info">
                                <div class="cart-item-icon">🍲</div>
                                <div class="cart-item-details">
                                    <h3><%= item.getName() %></h3>
                                    <span class="restaurant-tag">Item #<%= item.getMenuId() %></span>
                                </div>
                            </div>

                            <div class="cart-item-price">
                                ₹<%= String.format("%.2f", item.getPrice()) %>
                            </div>

                            <div class="quantity-control">
                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="action" value="update">
                                    <button type="submit" class="qty-btn" title="Decrease quantity">-</button>
                                </form>

                                <span class="qty-value"><%= item.getQuantity() %></span>

                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="action" value="add">
                                    <button type="submit" class="qty-btn" title="Increase quantity">+</button>
                                </form>
                            </div>

                            <div class="cart-item-subtotal">
                                ₹<%= String.format("%.2f", item.getTotalprice()) %>
                            </div>

                            <div>
                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit" class="cart-item-remove-btn" title="Remove item">🗑️</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Right Column: Order Summary -->
                <div class="bill-summary-card">
                    <h2>Order Summary</h2>

                    <div class="summary-row">
                        <span>Item Subtotal</span>
                        <span>₹<%= String.format("%.2f", itemSubtotal) %></span>
                    </div>

                    <div class="summary-row">
                        <span>Delivery Fee</span>
                        <span>
                            <% if (deliveryFee == 0.0) { %>
                                <span class="free-tag">FREE</span>
                            <% } else { %>
                                ₹<%= String.format("%.2f", deliveryFee) %>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span>Taxes & Packaging</span>
                        <span>₹<%= String.format("%.2f", taxAndPackaging) %></span>
                    </div>

                    <div class="summary-row total-row">
                        <span>Total Payable</span>
                        <span>₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>
                    
                    <a href="<%= checkoutTargetUrl %>" class="checkout-btn">
                        <span>Proceed to Checkout</span> →
                    </a>
                </div>

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
