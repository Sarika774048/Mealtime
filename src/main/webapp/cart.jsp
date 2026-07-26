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

    <!-- Modern Web Design System & Interactions -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Embedded Modern Styling for Cart Components -->
    <style>
        body {
            background-color: #F8F3EC !important;
            color: #42341E !important;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
            margin: 0;
            padding: 0;
        }

        .cart-page {
            min-height: 100vh;
            padding: 110px 7% 60px !important;
            color: #42341E;
            background: #F8F3EC;
        }

        .back-link {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            color: #CB4F1B !important;
            background: #FFF7ED !important;
            border: 1px solid #FFEDD5 !important;
            padding: 8px 20px !important;
            border-radius: 30px !important;
            text-decoration: none !important;
            font-size: 0.88rem !important;
            font-weight: 600 !important;
            margin-bottom: 24px !important;
            transition: all 0.25s ease !important;
        }

        .back-link:hover {
            background: #CB4F1B !important;
            color: #ffffff !important;
            border-color: #CB4F1B !important;
            transform: translateX(-4px) !important;
        }

        .cart-header-row {
            margin-bottom: 32px !important;
        }

        .cart-title-area h1 {
            font-size: clamp(2rem, 3.5vw, 2.6rem) !important;
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
            background: #FFF7ED !important;
            color: #CB4F1B !important;
            border: 1px solid #FFEDD5 !important;
        }

        /* ===== EMPTY CART CARD COMPONENT ===== */
        .empty-cart-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 24px !important;
            padding: 70px 40px !important;
            text-align: center !important;
            max-width: 560px !important;
            margin: 40px auto !important;
            box-shadow: 0 10px 40px rgba(66, 52, 30, 0.07) !important;
        }

        .empty-cart-badge {
            width: 96px !important;
            height: 96px !important;
            border-radius: 50% !important;
            background: linear-gradient(135deg, #FFF7ED 0%, #FFEDD5 100%) !important;
            border: 3px solid #FFD8A8 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            margin: 0 auto 26px !important;
            box-shadow: 0 8px 24px rgba(234, 88, 12, 0.15) !important;
        }

        .empty-cart-icon {
            font-size: 3rem !important;
        }

        .empty-cart-card h2 {
            font-size: 1.8rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
            margin: 0 0 12px 0 !important;
        }

        .empty-cart-card p {
            color: #7A6C5B !important;
            font-size: 1rem !important;
            margin: 0 0 34px 0 !important;
            line-height: 1.6 !important;
        }

        .explore-btn {
            display: inline-flex !important;
            align-items: center !important;
            gap: 12px !important;
            padding: 17px 40px !important;
            background: linear-gradient(135deg, #CB4F1B 0%, #D9381E 100%) !important;
            color: #FFFFFF !important;
            border-radius: 50px !important;
            text-decoration: none !important;
            font-weight: 800 !important;
            font-size: 1.05rem !important;
            box-shadow: 0 8px 25px rgba(203, 79, 27, 0.35) !important;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1) !important;
        }

        .explore-btn:hover {
            background: linear-gradient(135deg, #B53F0F 0%, #C42B12 100%) !important;
            transform: translateY(-3px) scale(1.02) !important;
            box-shadow: 0 14px 35px rgba(203, 79, 27, 0.5) !important;
            color: #FFFFFF !important;
        }

        .btn-arrow {
            font-size: 1.2rem !important;
            transition: transform 0.2s ease !important;
        }

        .explore-btn:hover .btn-arrow {
            transform: translateX(6px) !important;
        }

        /* ===== ACTIVE CART CONTAINER & CARDS ===== */
        .cart-container {
            display: grid !important;
            grid-template-columns: 1fr 360px !important;
            gap: 36px !important;
            align-items: start !important;
        }

        .cart-items-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 20px !important;
            padding: 32px 36px !important;
            box-shadow: 0 6px 30px rgba(66, 52, 30, 0.05) !important;
        }

        .cart-items-header {
            display: grid !important;
            grid-template-columns: 2.5fr 1fr 1fr 1fr 40px !important;
            align-items: center !important;
            padding-bottom: 18px !important;
            border-bottom: 1px solid #EFE6D8 !important;
            color: #B3A492 !important;
            font-size: 0.78rem !important;
            font-weight: 800 !important;
            text-transform: uppercase !important;
            letter-spacing: 1.5px !important;
        }

        .cart-item-row {
            display: grid !important;
            grid-template-columns: 2.5fr 1fr 1fr 1fr 40px !important;
            align-items: center !important;
            padding: 20px 24px !important;
            background: #FAF6F0 !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 14px !important;
            margin-top: 14px !important;
            transition: all 0.25s ease !important;
        }

        .cart-item-row:hover {
            background: #F7F0E6 !important;
            border-color: #E6D9C5 !important;
            transform: translateY(-1px) !important;
        }

        .cart-item-info {
            display: flex !important;
            align-items: center !important;
            gap: 18px !important;
        }

        .cart-item-icon {
            width: 54px !important;
            height: 54px !important;
            border-radius: 12px !important;
            background: #ffffff !important;
            border: 1px solid #E3D9CC !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.7rem !important;
            flex-shrink: 0 !important;
            box-shadow: 0 2px 8px rgba(66, 52, 30, 0.04) !important;
        }

        .cart-item-details h3 {
            font-size: 1.05rem !important;
            color: #3E3220 !important;
            font-weight: 700 !important;
            margin: 0 0 4px 0 !important;
        }

        .cart-item-details .restaurant-tag {
            font-size: 0.8rem !important;
            color: #9E8F7C !important;
        }

        .cart-item-price {
            font-size: 0.96rem !important;
            font-weight: 700 !important;
            color: #524436 !important;
        }

        .quantity-control {
            display: inline-flex !important;
            align-items: center !important;
            gap: 10px !important;
        }

        .qty-btn {
            width: 28px !important;
            height: 28px !important;
            border-radius: 50% !important;
            border: 1px solid #DFD6C8 !important;
            background: #ffffff !important;
            color: #524436 !important;
            font-size: 1.1rem !important;
            font-weight: 700 !important;
            cursor: pointer !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            transition: all 0.2s ease !important;
        }

        .qty-btn:hover {
            background: #CB4F1B !important;
            color: #ffffff !important;
            border-color: #CB4F1B !important;
        }

        .qty-value {
            font-size: 0.98rem !important;
            font-weight: 700 !important;
            min-width: 18px !important;
            text-align: center !important;
            color: #42341E !important;
        }

        .cart-item-subtotal {
            font-size: 1.05rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
        }

        .cart-item-action-col {
            display: flex !important;
            justify-content: flex-end !important;
        }

        .cart-item-remove-btn {
            background: transparent !important;
            border: none !important;
            cursor: pointer !important;
            font-size: 1.2rem !important;
            opacity: 0.6 !important;
            transition: opacity 0.2s ease, transform 0.2s ease !important;
        }

        .cart-item-remove-btn:hover {
            opacity: 1 !important;
            transform: scale(1.15) !important;
        }

        /* ===== TABLE ACTIONS ===== */
        .cart-table-actions {
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
            margin-top: 28px !important;
            padding-top: 10px !important;
            flex-wrap: wrap !important;
            gap: 16px !important;
        }

        .coupon-box {
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
        }

        .coupon-input {
            padding: 11px 18px !important;
            border: 1px solid #DCD1C2 !important;
            border-radius: 8px !important;
            outline: none !important;
            background: #FFFFFF !important;
            font-size: 0.9rem !important;
            color: #42341E !important;
            width: 140px !important;
            font-family: inherit !important;
        }

        .coupon-btn {
            background: linear-gradient(135deg, #CB4F1B 0%, #D9381E 100%) !important;
            color: #FFFFFF !important;
            border: none !important;
            border-radius: 30px !important;
            padding: 12px 26px !important;
            font-size: 0.88rem !important;
            font-weight: 700 !important;
            cursor: pointer !important;
            font-family: inherit !important;
            box-shadow: 0 4px 14px rgba(203, 79, 27, 0.25) !important;
            transition: all 0.2s ease !important;
        }

        .coupon-btn:hover {
            background: linear-gradient(135deg, #B53F0F 0%, #C42B12 100%) !important;
            transform: translateY(-2px) !important;
        }

        .update-cart-btn {
            background: #FFF3E0 !important;
            color: #E65100 !important;
            border: 1px solid #FFCC80 !important;
            border-radius: 30px !important;
            padding: 12px 26px !important;
            font-size: 0.88rem !important;
            font-weight: 700 !important;
            cursor: pointer !important;
            font-family: inherit !important;
            box-shadow: 0 2px 8px rgba(230, 81, 0, 0.08) !important;
            transition: all 0.2s ease !important;
        }

        .update-cart-btn:hover {
            background: #FFE0B2 !important;
            color: #CB4F1B !important;
            transform: translateY(-2px) !important;
        }

        /* ===== ORDER SUMMARY SIDEBAR ===== */
        .bill-summary-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 20px !important;
            padding: 36px 30px !important;
            box-shadow: 0 8px 30px rgba(66, 52, 30, 0.05) !important;
        }

        .bill-summary-card h2 {
            font-size: 1.35rem !important;
            font-weight: 800 !important;
            color: #3D3121 !important;
            margin: 0 0 28px 0 !important;
        }

        .summary-row {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            margin-bottom: 20px !important;
            font-size: 0.8rem !important;
            font-weight: 800 !important;
            letter-spacing: 1px !important;
            color: #7A6C5B !important;
            text-transform: uppercase !important;
        }

        .summary-row span:last-child {
            color: #3D3121 !important;
            font-size: 0.98rem !important;
            font-weight: 800 !important;
            text-transform: none !important;
            letter-spacing: 0 !important;
        }

        .summary-row.total-row {
            margin-top: 24px !important;
            padding-top: 18px !important;
            border-top: 1px dashed #CFC3B3 !important;
            font-size: 0.9rem !important;
            color: #3D3121 !important;
        }

        .summary-row.total-row span:last-child {
            font-size: 1.25rem !important;
            font-weight: 800 !important;
            color: #CB4F1B !important;
        }

        .checkout-btn {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            width: 100% !important;
            margin-top: 32px !important;
            padding: 17px 24px !important;
            background: linear-gradient(135deg, #CB4F1B 0%, #D9381E 100%) !important;
            color: #FFFFFF !important;
            font-family: inherit !important;
            font-size: 1.05rem !important;
            font-weight: 800 !important;
            border: none !important;
            border-radius: 50px !important;
            text-decoration: none !important;
            cursor: pointer !important;
            box-shadow: 0 8px 25px rgba(203, 79, 27, 0.35) !important;
            transition: all 0.3s ease !important;
            box-sizing: border-box !important;
        }

        .checkout-btn:hover {
            background: linear-gradient(135deg, #B53F0F 0%, #C42B12 100%) !important;
            transform: translateY(-3px) !important;
            box-shadow: 0 12px 32px rgba(203, 79, 27, 0.5) !important;
            color: #ffffff !important;
        }

        .free-tag {
            color: #047857 !important;
            font-weight: 800 !important;
        }

        /* ===== BOTTOM FEATURES SHOWCASE CARD COMPONENT ===== */
        .cart-features-bar {
            margin-top: 60px !important;
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 20px !important;
            padding: 36px 28px !important;
            display: grid !important;
            grid-template-columns: repeat(4, 1fr) !important;
            gap: 24px !important;
            box-shadow: 0 6px 30px rgba(66, 52, 30, 0.05) !important;
        }

        .cart-feature-col {
            display: flex !important;
            align-items: center !important;
            gap: 16px !important;
            padding-right: 20px !important;
            border-right: 1px solid #F3EDE3 !important;
        }

        .cart-feature-col:last-child {
            border-right: none !important;
        }

        .feature-icon-box {
            width: 52px !important;
            height: 52px !important;
            border-radius: 14px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.6rem !important;
            flex-shrink: 0 !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03) !important;
        }

        .feature-icon-box.green {
            background: #ECFDF5 !important;
            border: 1px solid #A7F3D0 !important;
        }

        .feature-icon-box.amber {
            background: #FFFBEB !important;
            border: 1px solid #FDE68A !important;
        }

        .feature-icon-box.blue {
            background: #EFF6FF !important;
            border: 1px solid #BFDBFE !important;
        }

        .feature-icon-box.purple {
            background: #F5F3FF !important;
            border: 1px solid #DDD6FE !important;
        }

        .feature-info h3 {
            font-size: 1rem !important;
            font-weight: 700 !important;
            color: #3E3220 !important;
            margin: 0 0 3px 0 !important;
        }

        .feature-info p {
            font-size: 0.82rem !important;
            color: #8C7B68 !important;
            margin: 0 !important;
            font-weight: 500 !important;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .cart-container {
                grid-template-columns: 1fr !important;
            }
            .cart-features-bar {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 24px !important;
            }
            .cart-feature-col {
                border-right: none !important;
                border-bottom: 1px solid #F3EDE3 !important;
                padding-bottom: 18px !important;
            }
            .cart-feature-col:nth-child(3),
            .cart-feature-col:nth-child(4) {
                border-bottom: none !important;
                padding-bottom: 0 !important;
            }
        }

        @media (max-width: 640px) {
            .cart-items-card {
                padding: 20px 16px !important;
            }
            .cart-items-header {
                display: none !important;
            }
            .cart-item-row {
                grid-template-columns: 1fr !important;
                gap: 14px !important;
            }
            .cart-features-bar {
                grid-template-columns: 1fr !important;
            }
            .cart-feature-col {
                border-bottom: 1px solid #F3EDE3 !important;
                padding-bottom: 16px !important;
            }
            .cart-feature-col:last-child {
                border-bottom: none !important;
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
            <a href="login.html" class="login-link">Log in</a>
            <a href="register.html" class="signup-btn">Sign up</a>
        </div>
    </header>

    <main class="cart-page">
        <a href="<%= backToMenuUrl %>" class="back-link">← Back to Menu</a>

        <div class="cart-header-row">
            <div class="cart-title-area">
                <h1>Shopping Cart <% if (totalItemsCount > 0) { %><span class="cart-count-badge"><%= totalItemsCount %> <%= totalItemsCount == 1 ? "Item" : "Items" %></span><% } %></h1>
            </div>
        </div>

        <% if (items == null || items.isEmpty()) { %>
            <!-- Empty Cart State Component -->
            <div class="empty-cart-card">
                <div class="empty-cart-badge">
                    <span class="empty-cart-icon">🛒</span>
                </div>
                <h2>Your cart feels empty</h2>
                <p>Good food is always waiting for you. Explore our top restaurants and add your favorite dishes to your cart!</p>
                <a href="home" class="explore-btn">
                    <span>Explore Restaurants</span>
                    <span class="btn-arrow">→</span>
                </a>
            </div>
        <% } else { %>
            <!-- Active Cart Container -->
            <div class="cart-container">
                
                <!-- Left Column: Items List -->
                <div class="cart-items-card">
                    <div class="cart-items-header">
                        <span>PRODUCT</span>
                        <span>PRICE</span>
                        <span>QUANTITY</span>
                        <span>SUBTOTAL</span>
                        <span>ACTION</span>
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

                            <div class="cart-item-action-col">
                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit" class="cart-item-remove-btn" title="Remove item">🗑️</button>
                                </form>
                            </div>
                        </div>
                    <% } %>

                    <!-- Table Bottom Actions (Coupon & Update Cart) -->
                    <div class="cart-table-actions">
                        <div class="coupon-box">
                            <input type="text" placeholder="Code" class="coupon-input">
                            <button type="button" class="coupon-btn">Enter Coupon</button>
                        </div>
                        <button type="button" class="update-cart-btn" onclick="window.location.reload();">Update cart</button>
                    </div>
                </div>

                <!-- Right Column: Order Summary -->
                <div class="bill-summary-card">
                    <h2>Order Summary</h2>

                    <div class="summary-row">
                        <span>SUBTOTAL</span>
                        <span>₹<%= String.format("%.2f", itemSubtotal) %></span>
                    </div>

                    <div class="summary-row">
                        <span>DELIVERY FEE</span>
                        <span>
                            <% if (deliveryFee == 0.0) { %>
                                <span class="free-tag">FREE</span>
                            <% } else { %>
                                ₹<%= String.format("%.2f", deliveryFee) %>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span>TAXES & PACKAGING</span>
                        <span>₹<%= String.format("%.2f", taxAndPackaging) %></span>
                    </div>

                    <div class="summary-row total-row">
                        <span>TOTAL</span>
                        <span>₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>
                    
                    <a href="<%= checkoutTargetUrl %>" class="checkout-btn">
                        <span>Checkout</span>
                    </a>
                </div>

            </div>
        <% } %>

        <!-- Bottom Features Showcase Bar Component -->
        <section class="cart-features-bar">
            <div class="cart-feature-col">
                <div class="feature-icon-box green">🚚</div>
                <div class="feature-info">
                    <h3>Free Delivery</h3>
                    <p>For all orders over ₹500.00</p>
                </div>
            </div>
            <div class="cart-feature-col">
                <div class="feature-icon-box amber">🛡️</div>
                <div class="feature-info">
                    <h3>Fresh Guarantee</h3>
                    <p>100% Quality & Hygiene assurance</p>
                </div>
            </div>
            <div class="cart-feature-col">
                <div class="feature-icon-box blue">💳</div>
                <div class="feature-info">
                    <h3>Secure Payment</h3>
                    <p>100% Encrypted & Safe Payments</p>
                </div>
            </div>
            <div class="cart-feature-col">
                <div class="feature-icon-box purple">🎧</div>
                <div class="feature-info">
                    <h3>24/7 Support</h3>
                    <p>Dedicated instant customer support</p>
                </div>
            </div>
        </section>
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
