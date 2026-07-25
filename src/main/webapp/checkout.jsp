<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.mealtime.model.Cart" %>
<%@ page import="com.mealtime.model.CartItem" %>
<%@ page import="com.mealtime.model.User" %>

<%
    // Fetch cart from HTTP Session
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
    
    // Fee calculations matching Cart page logic
    double deliveryFee = (itemSubtotal > 500 || itemSubtotal == 0) ? 0.0 : 40.0;
    double taxAndPackaging = (itemSubtotal > 0) ? Math.round((itemSubtotal * 0.05 + 15) * 100.0) / 100.0 : 0.0;
    double grandTotal = itemSubtotal + deliveryFee + taxAndPackaging;

    // Fetch user details from session if logged in
    User sessionUser = (User) session.getAttribute("user");
    String defaultEmail = (String) session.getAttribute("email");

    if (sessionUser == null && defaultEmail != null && !defaultEmail.trim().isEmpty()) {
        sessionUser = new com.mealtime.daoimplementation.UserDaoImple().getUserByEmail(defaultEmail.trim());
        if (sessionUser != null) {
            session.setAttribute("user", sessionUser);
        }
    }

    // REQUIRE LOGIN FOR CHECKOUT
    if (sessionUser == null && (defaultEmail == null || defaultEmail.trim().isEmpty())) {
        session.setAttribute("redirectAfterLogin", "checkout.jsp");
        response.sendRedirect("login.html?error=Please+login+or+sign+up+to+proceed+with+checkout.");
        return;
    }

    String defaultName = (sessionUser != null && sessionUser.getName() != null) ? sessionUser.getName() : "";
    String defaultPhone = (sessionUser != null && sessionUser.getPhone() != null) ? sessionUser.getPhone() : "";
    String defaultAddress = (sessionUser != null && sessionUser.getAddress() != null) ? sessionUser.getAddress() : "";

    Object sessionRestaurantId = session.getAttribute("restaurantId");
    String backToCartUrl = "cart.jsp";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | Mealtime</title>

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
            <a href="home#offers">Offers</a>
            <a href="home#about">About Us</a>
        </nav>

        <div class="nav-actions">
            <% if (defaultEmail != null && !defaultEmail.isEmpty()) { %>
                <span class="login-link" style="cursor: default; color: var(--primary); font-weight: 600;">👤 <%= defaultEmail %></span>
            <% } else { %>
                <a href="login.html" class="login-link">Log in</a>
                <a href="register.html" class="signup-btn">Sign up</a>
            <% } %>
        </div>
    </header>

    <main class="checkout-page">
        <a href="<%= backToCartUrl %>" class="back-link">← Back to Cart</a>

        <div class="checkout-header-row">
            <div class="checkout-title-area">
                <h1>Checkout Order <% if (totalItemsCount > 0) { %><span class="cart-count-badge"><%= totalItemsCount %> <%= totalItemsCount == 1 ? "Item" : "Items" %></span><% } %></h1>
            </div>
        </div>

        <% if (items == null || items.isEmpty()) { %>
            <!-- Empty Cart State -->
            <div class="empty-cart-card">
                <span class="empty-cart-icon">🛒</span>
                <h2>Your cart is empty</h2>
                <p>You cannot proceed to checkout with an empty cart. Please add food items to your cart first!</p>
                <a href="home" class="explore-btn">
                    <span>Explore Restaurants</span> →
                </a>
            </div>
        <% } else { %>
            <!-- Active Checkout Container -->
            <form action="OrderServlet" method="post" class="checkout-container">
                <input type="hidden" name="totalAmount" value="<%= grandTotal %>">
                <% if (sessionRestaurantId != null) { %>
                    <input type="hidden" name="restaurantId" value="<%= sessionRestaurantId %>">
                <% } %>

                <!-- Left Column: Customer Details & Payment Form -->
                <div class="checkout-form-section">
                    
                    <!-- Customer Information Card -->
                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="form-card-icon">📍</div>
                            <h2>Delivery Details</h2>
                        </div>

                        <div class="form-grid">
                            <!-- Full Name -->
                            <div class="form-group">
                                <label for="name">Full Name <span class="required-asterisk">*</span></label>
                                <input type="text" 
                                       id="name" 
                                       name="name" 
                                       class="form-control" 
                                       placeholder="John Doe" 
                                       value="<%= defaultName %>" 
                                       required>
                            </div>

                            <!-- Phone Number -->
                            <div class="form-group">
                                <label for="phone">Phone Number <span class="required-asterisk">*</span></label>
                                <input type="tel" 
                                       id="phone" 
                                       name="phone" 
                                       class="form-control" 
                                       placeholder="e.g. 9876543210" 
                                       pattern="[0-9]{10}"
                                       title="Please enter a valid 10-digit phone number"
                                       value="<%= defaultPhone %>" 
                                       required>
                            </div>

                            <!-- Delivery Address -->
                            <div class="form-group full-width">
                                <label for="address">Delivery Address <span class="required-asterisk">*</span></label>
                                <textarea id="address" 
                                          name="address" 
                                          class="form-control" 
                                          rows="3" 
                                          placeholder="House/Flat No., Building Name, Street, Landmark, City..." 
                                          required><%= defaultAddress %></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Mode Card -->
                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="form-card-icon">💳</div>
                            <h2>Select Payment Mode</h2>
                        </div>

                        <div class="payment-options-grid">
                            
                            <!-- Cash on Delivery -->
                            <label class="payment-option-card">
                                <input type="radio" name="paymentMode" value="Cash on Delivery" checked required>
                                <div class="payment-card-content">
                                    <div class="payment-icon">💵</div>
                                    <div class="payment-info">
                                        <span class="payment-title">Cash on Delivery</span>
                                        <span class="payment-desc">Pay cash upon order arrival</span>
                                    </div>
                                </div>
                            </label>

                            <!-- UPI / GPay / PhonePe -->
                            <label class="payment-option-card">
                                <input type="radio" name="paymentMode" value="UPI" required>
                                <div class="payment-card-content">
                                    <div class="payment-icon">📱</div>
                                    <div class="payment-info">
                                        <span class="payment-title">UPI / Google Pay</span>
                                        <span class="payment-desc">Pay via UPI QR / VPA</span>
                                    </div>
                                </div>
                            </label>

                            <!-- Credit / Debit Card -->
                            <label class="payment-option-card">
                                <input type="radio" name="paymentMode" value="Credit/Debit Card" required>
                                <div class="payment-card-content">
                                    <div class="payment-icon">💳</div>
                                    <div class="payment-info">
                                        <span class="payment-title">Credit / Debit Card</span>
                                        <span class="payment-desc">Visa, Mastercard, RuPay</span>
                                    </div>
                                </div>
                            </label>

                            <!-- Net Banking -->
                            <label class="payment-option-card">
                                <input type="radio" name="paymentMode" value="Net Banking" required>
                                <div class="payment-card-content">
                                    <div class="payment-icon">🏦</div>
                                    <div class="payment-info">
                                        <span class="payment-title">Net Banking</span>
                                        <span class="payment-desc">All major Indian banks</span>
                                    </div>
                                </div>
                            </label>

                        </div>
                    </div>

                </div>

                <!-- Right Column: Order Summary from Session Cart -->
                <div class="checkout-summary-card">
                    <h2>Order Summary</h2>

                    <!-- Cart Items from Session -->
                    <div class="checkout-items-list">
                        <% for (CartItem item : items.values()) { %>
                            <div class="summary-item-row">
                                <div class="summary-item-left">
                                    <span class="summary-item-badge"><%= item.getQuantity() %>x</span>
                                    <span class="summary-item-name"><%= item.getName() %></span>
                                </div>
                                <span class="summary-item-price">₹<%= String.format("%.2f", item.getTotalprice()) %></span>
                            </div>
                        <% } %>
                    </div>

                    <div class="summary-divider"></div>

                    <!-- Pricing Calculation -->
                    <div class="summary-row">
                        <span>Items Subtotal</span>
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
                        <span>Total Amount</span>
                        <span>₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>

                    <!-- Place Order Button -->
                    <button type="submit" class="place-order-btn">
                        <span>Confirm & Place Order</span> →
                    </button>
                </div>

            </form>
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
