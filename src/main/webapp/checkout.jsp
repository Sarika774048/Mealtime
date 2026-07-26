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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">

    <!-- Modern Web Engine JS -->
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Embedded High-Priority Modern CSS Grid & Component Styling -->
    <style>
        body {
            background-color: #F8F3EC !important;
            color: #42341E !important;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
            margin: 0;
            padding: 0;
        }

        .checkout-page {
            min-height: 100vh;
            padding: 110px 7% 60px !important;
            color: #42341E;
            background: #F8F3EC;
        }

        .back-link {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            color: #524436 !important;
            background: #EFE8DF !important;
            border: 1px solid #E2D7C8 !important;
            padding: 8px 20px !important;
            border-radius: 30px !important;
            text-decoration: none !important;
            font-size: 0.88rem !important;
            font-weight: 600 !important;
            margin-bottom: 24px !important;
            transition: all 0.25s ease !important;
        }

        .back-link:hover {
            background: #4E4133 !important;
            color: #ffffff !important;
            border-color: #4E4133 !important;
            transform: translateX(-4px) !important;
        }

        .checkout-header-row {
            margin-bottom: 32px !important;
        }

        .checkout-title-area h1 {
            font-size: clamp(2rem, 3.5vw, 2.5rem) !important;
            color: #3D3121 !important;
            font-weight: 800 !important;
            display: flex !important;
            align-items: center !important;
            gap: 16px !important;
            letter-spacing: -0.5px !important;
            margin: 0 !important;
        }

        .cart-count-badge {
            font-size: 0.85rem !important;
            font-weight: 700 !important;
            padding: 5px 16px !important;
            border-radius: 50px !important;
            background: #EFE6D9 !important;
            color: #7A6956 !important;
            border: 1px solid #DFCFC0 !important;
        }

        /* ===== MAIN CHECKOUT GRID ===== */
        .checkout-container {
            display: grid !important;
            grid-template-columns: 1fr 380px !important;
            gap: 36px !important;
            align-items: start !important;
        }

        .checkout-form-section {
            display: flex !important;
            flex-direction: column !important;
            gap: 28px !important;
        }

        /* ===== CARDS COMPONENT DESIGN ===== */
        .form-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 20px !important;
            padding: 32px !important;
            box-shadow: 0 6px 24px rgba(66, 52, 30, 0.05) !important;
        }

        .form-card-header {
            display: flex !important;
            align-items: center !important;
            gap: 14px !important;
            margin-bottom: 24px !important;
        }

        .form-card-header.flex-between {
            justify-content: space-between !important;
        }

        .header-left {
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
        }

        .form-card-icon {
            width: 42px !important;
            height: 42px !important;
            border-radius: 12px !important;
            background: #FFF7ED !important;
            border: 1px solid #FFEDD5 !important;
            color: #EA580C !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.3rem !important;
            flex-shrink: 0 !important;
        }

        .form-card-header h2 {
            font-size: 1.25rem !important;
            color: #3D3121 !important;
            font-weight: 800 !important;
            margin: 0 !important;
        }

        .confirm-badge {
            background: #FFC107 !important;
            color: #3D3121 !important;
            font-size: 0.85rem !important;
            font-weight: 800 !important;
            padding: 6px 22px !important;
            border-radius: 30px !important;
            display: inline-block !important;
            box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3) !important;
        }

        /* ===== MY CART ITEMS COMPONENT ===== */
        .my-cart-items {
            display: flex !important;
            flex-direction: column !important;
            gap: 12px !important;
            margin-bottom: 20px !important;
        }

        .my-cart-item-row {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding: 16px 20px !important;
            background: #FAF6F0 !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 14px !important;
            transition: all 0.25s ease !important;
        }

        .my-cart-item-row:hover {
            background: #F7F0E6 !important;
            border-color: #E6D9C5 !important;
        }

        .my-cart-item-left {
            display: flex !important;
            align-items: center !important;
            gap: 16px !important;
        }

        .my-cart-item-thumb {
            width: 52px !important;
            height: 52px !important;
            border-radius: 12px !important;
            background: #ffffff !important;
            border: 1px solid #E3D9CC !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.6rem !important;
            flex-shrink: 0 !important;
            box-shadow: 0 2px 6px rgba(66, 52, 30, 0.04) !important;
        }

        .my-cart-item-info h3 {
            font-size: 1rem !important;
            font-weight: 700 !important;
            color: #3E3220 !important;
            margin: 0 0 3px 0 !important;
        }

        .my-cart-item-desc {
            font-size: 0.8rem !important;
            color: #8C7B68 !important;
            margin: 0 !important;
        }

        .my-cart-item-right {
            display: flex !important;
            align-items: center !important;
            gap: 14px !important;
        }

        .my-cart-qty-pill {
            font-size: 0.82rem !important;
            font-weight: 800 !important;
            color: #EA580C !important;
            background: #FFF7ED !important;
            padding: 4px 12px !important;
            border-radius: 6px !important;
            border: 1px solid #FFEDD5 !important;
        }

        .my-cart-price-val {
            font-size: 1.05rem !important;
            font-weight: 800 !important;
            color: #3E3220 !important;
        }

        /* ===== CART FOOTER (DISCOUNT & BORDERLESS TABLE) ===== */
        .my-cart-footer {
            display: flex !important;
            justify-content: space-between !important;
            align-items: flex-end !important;
            margin-top: 20px !important;
            padding-top: 20px !important;
            border-top: 1px solid #EBE3D7 !important;
            flex-wrap: wrap !important;
            gap: 20px !important;
        }

        .add-discount-btn {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            padding: 11px 24px !important;
            background: linear-gradient(135deg, #FFF3E0 0%, #FFE0B2 100%) !important;
            color: #E65100 !important;
            border: 1px solid #FFCC80 !important;
            border-radius: 30px !important;
            font-weight: 800 !important;
            font-size: 0.88rem !important;
            font-family: inherit !important;
            cursor: pointer !important;
            transition: all 0.25s ease !important;
            box-shadow: 0 2px 8px rgba(230, 81, 0, 0.08) !important;
        }

        .add-discount-btn:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 16px rgba(230, 81, 0, 0.18) !important;
        }

        .my-cart-footer-right {
            min-width: 250px !important;
        }

        .borderless-summary-table {
            width: 100% !important;
            border-collapse: collapse !important;
            border: none !important;
            margin-left: auto !important;
        }

        .borderless-summary-table tr,
        .borderless-summary-table td {
            border: none !important;
            padding: 5px 0 !important;
            background: transparent !important;
        }

        .table-label {
            font-size: 0.88rem !important;
            color: #7A6C5B !important;
            font-weight: 500 !important;
            text-align: left !important;
            padding-right: 28px !important;
        }

        .table-val {
            font-size: 0.94rem !important;
            color: #3E3220 !important;
            font-weight: 700 !important;
            text-align: right !important;
        }

        .table-total-row td {
            padding-top: 12px !important;
            border-top: 1px dashed #DCD1C2 !important;
        }

        .table-label-total {
            font-size: 0.98rem !important;
            font-weight: 800 !important;
            color: #3E3220 !important;
            text-align: left !important;
        }

        .table-val-total {
            font-size: 1.18rem !important;
            font-weight: 800 !important;
            color: #CB4F1B !important;
            text-align: right !important;
        }

        /* ===== DELIVERY FORM GRID ===== */
        .form-grid {
            display: grid !important;
            grid-template-columns: repeat(2, 1fr) !important;
            gap: 20px !important;
        }

        .form-group {
            display: flex !important;
            flex-direction: column !important;
            gap: 8px !important;
        }

        .form-group.full-width {
            grid-column: 1 / -1 !important;
        }

        .form-group label {
            font-size: 0.88rem !important;
            font-weight: 700 !important;
            color: #3E3220 !important;
        }

        .required-asterisk {
            color: #CB4F1B !important;
        }

        .form-control {
            width: 100% !important;
            padding: 14px 18px !important;
            background: #FAF6F0 !important;
            border: 1px solid #E3D9CC !important;
            border-radius: 12px !important;
            color: #3E3220 !important;
            font-family: inherit !important;
            font-size: 0.95rem !important;
            transition: all 0.25s ease !important;
            outline: none !important;
            box-sizing: border-box !important;
        }

        .form-control:focus {
            border-color: #FFC107 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 4px rgba(255, 193, 7, 0.2) !important;
        }

        /* ===== PAYMENT MODE SELECTION GRID ===== */
        .payment-options-grid {
            display: grid !important;
            grid-template-columns: repeat(2, 1fr) !important;
            gap: 16px !important;
        }

        .payment-option-card {
            cursor: pointer !important;
            user-select: none !important;
        }

        .payment-option-card input[type="radio"] {
            display: none !important;
        }

        .payment-card-content {
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
            gap: 14px !important;
            padding: 18px 20px !important;
            background: #FAF6F0 !important;
            border: 2px solid #EAE0D3 !important;
            border-radius: 14px !important;
            transition: all 0.25s ease !important;
        }

        .payment-icon {
            font-size: 1.6rem !important;
        }

        .payment-info {
            display: flex !important;
            flex-direction: column !important;
            gap: 3px !important;
            flex-grow: 1 !important;
        }

        .payment-title {
            font-size: 0.95rem !important;
            font-weight: 700 !important;
            color: #3E3220 !important;
        }

        .payment-desc {
            font-size: 0.78rem !important;
            color: #8C7B68 !important;
        }

        .payment-badge {
            font-size: 0.76rem !important;
            font-weight: 700 !important;
            color: #8C7B68 !important;
            background: #EFE8DF !important;
            padding: 4px 12px !important;
            border-radius: 20px !important;
        }

        .payment-option-card input[type="radio"]:checked + .payment-card-content {
            border-color: #FFC107 !important;
            background: #FFFDF5 !important;
            box-shadow: 0 4px 16px rgba(255, 193, 7, 0.2) !important;
            transform: translateY(-2px) !important;
        }

        .payment-option-card input[type="radio"]:checked + .payment-card-content .payment-badge {
            background: #FFC107 !important;
            color: #3E3220 !important;
        }

        /* ===== RIGHT SIDEBAR: TOTAL PAYMENT CARD ===== */
        .checkout-summary-card {
            background: linear-gradient(180deg, #EFE8DF 0%, #E8E0D5 100%) !important;
            border: 1px solid #E4DACB !important;
            border-radius: 20px !important;
            padding: 36px 30px !important;
            box-shadow: 0 6px 24px rgba(66, 52, 30, 0.04) !important;
        }

        .checkout-summary-card h2 {
            font-size: 1.35rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
            margin: 0 0 28px 0 !important;
        }

        .summary-row {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            margin-bottom: 18px !important;
            font-size: 0.9rem !important;
            color: #7A6C5B !important;
            font-weight: 600 !important;
        }

        .summary-row span:last-child {
            color: #3D3121 !important;
            font-weight: 700 !important;
        }

        .summary-divider {
            height: 1px !important;
            background: #DCD1C2 !important;
            margin: 22px 0 !important;
        }

        .summary-row.total-row {
            margin-top: 10px !important;
            padding-top: 18px !important;
            border-top: 1px dashed #CFC3B3 !important;
            font-size: 1rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
        }

        .summary-row.total-row span:last-child {
            font-size: 1.25rem !important;
            font-weight: 800 !important;
            color: #CB4F1B !important;
        }

        .place-order-btn {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            width: 100% !important;
            margin-top: 32px !important;
            padding: 18px 24px !important;
            background: linear-gradient(135deg, #FFC107 0%, #F59E0B 100%) !important;
            color: #3D3121 !important;
            font-family: inherit !important;
            font-size: 1.08rem !important;
            font-weight: 800 !important;
            border: none !important;
            border-radius: 50px !important;
            cursor: pointer !important;
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.35) !important;
            transition: all 0.3s ease !important;
            box-sizing: border-box !important;
        }

        .place-order-btn:hover {
            background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%) !important;
            transform: translateY(-3px) !important;
            box-shadow: 0 12px 32px rgba(245, 158, 11, 0.5) !important;
        }

        .checkout-footer-note {
            margin-top: 20px !important;
            font-size: 0.8rem !important;
            color: #8A7B6A !important;
            line-height: 1.5 !important;
            text-align: center !important;
        }

        .free-tag {
            color: #047857 !important;
            font-weight: 800 !important;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .checkout-container {
                grid-template-columns: 1fr !important;
            }
        }

        @media (max-width: 640px) {
            .form-grid,
            .payment-options-grid {
                grid-template-columns: 1fr !important;
            }

            .form-card {
                padding: 20px 16px !important;
            }

            .my-cart-item-row {
                flex-direction: column !important;
                align-items: flex-start !important;
                gap: 12px !important;
            }

            .my-cart-item-right {
                align-self: flex-end !important;
            }
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
        <a href="<%= backToCartUrl %>" class="back-link">← Back</a>

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

                <!-- Left Column: Cart Preview, Customer Details & Payment Form -->
                <div class="checkout-form-section">
                    
                    <!-- My Cart Summary Card (Attractive Component Layout) -->
                    <div class="form-card my-cart-card">
                        <div class="form-card-header flex-between">
                            <div class="header-left">
                                <span class="form-card-icon">🛒</span>
                                <h2>My cart</h2>
                            </div>
                            <span class="confirm-badge">Confirm</span>
                        </div>

                        <!-- Items List Components -->
                        <div class="my-cart-items">
                            <% for (CartItem item : items.values()) { %>
                                <div class="my-cart-item-row">
                                    <div class="my-cart-item-left">
                                        <div class="my-cart-item-thumb">🍲</div>
                                        <div class="my-cart-item-info">
                                            <h3><%= item.getName() %></h3>
                                            <p class="my-cart-item-desc">Freshly prepared dish • Item #<%= item.getMenuId() %></p>
                                        </div>
                                    </div>
                                    <div class="my-cart-item-right">
                                        <span class="my-cart-qty-pill"><%= item.getQuantity() %>X</span>
                                        <span class="my-cart-price-val">₹<%= String.format("%.2f", item.getTotalprice()) %></span>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <!-- Cart Bottom Section (Discount Button & Borderless Table) -->
                        <div class="my-cart-footer">
                            <div class="my-cart-footer-left">
                                <button type="button" class="add-discount-btn">
                                    <span class="discount-icon">🏷️</span>
                                    <span>Add discount</span>
                                </button>
                            </div>

                            <div class="my-cart-footer-right">
                                <table class="borderless-summary-table">
                                    <tr>
                                        <td class="table-label">Subtotal</td>
                                        <td class="table-val">₹<%= String.format("%.2f", itemSubtotal) %></td>
                                    </tr>
                                    <tr>
                                        <td class="table-label">Delivery fee</td>
                                        <td class="table-val">
                                            <% if (deliveryFee == 0.0) { %>
                                                <span class="free-tag">FREE</span>
                                            <% } else { %>
                                                ₹<%= String.format("%.2f", deliveryFee) %>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="table-label">Taxes & Packaging</td>
                                        <td class="table-val">₹<%= String.format("%.2f", taxAndPackaging) %></td>
                                    </tr>
                                    <tr class="table-total-row">
                                        <td class="table-label-total">TOTAL</td>
                                        <td class="table-val-total">₹<%= String.format("%.2f", grandTotal) %></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Customer Information Card -->
                    <div class="form-card">
                        <div class="form-card-header">
                            <span class="form-card-icon">📍</span>
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
                            <span class="form-card-icon">💳</span>
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
                                    <span class="payment-badge">Selected</span>
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
                                    <span class="payment-badge">Available</span>
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
                                    <span class="payment-badge">Available</span>
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
                                    <span class="payment-badge">Available</span>
                                </div>
                            </label>

                        </div>
                    </div>

                </div>

                <!-- Right Column: Total Payment Sidebar -->
                <div class="checkout-summary-card">
                    <h2>Total payment</h2>

                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<%= String.format("%.2f", itemSubtotal) %></span>
                    </div>

                    <div class="summary-row">
                        <span>Delivery fee</span>
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

                    <div class="summary-divider"></div>

                    <div class="summary-row total-row">
                        <span>Total Payable</span>
                        <span>₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>

                    <!-- Confirm Order Button -->
                    <button type="submit" class="place-order-btn">
                        <span>Confirm & Place Order</span>
                    </button>

                    <p class="checkout-footer-note">
                        Your order details are verified. Your food will be dispatched right after order placement.
                    </p>
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
