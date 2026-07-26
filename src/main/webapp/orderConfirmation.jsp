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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">

    <!-- Modern Web Engine JS -->
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Embedded High-Priority Modern CSS Styling for Receipt & Buttons -->
    <style>
        body {
            background-color: #F8F3EC !important;
            color: #42341E !important;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
        }

        .confirmation-card {
            background: #ffffff !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 24px !important;
            padding: 50px 44px !important;
            text-align: center !important;
            max-width: 640px !important;
            margin: 40px auto !important;
            box-shadow: 0 10px 40px rgba(66, 52, 30, 0.07) !important;
        }

        .success-icon-badge {
            width: 72px !important;
            height: 72px !important;
            border-radius: 50% !important;
            background: #ECFDF5 !important;
            border: 2px solid #A7F3D0 !important;
            color: #047857 !important;
            font-size: 2.2rem !important;
            font-weight: 800 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            margin: 0 auto 20px !important;
            box-shadow: 0 4px 16px rgba(4, 120, 87, 0.15) !important;
        }

        .confirmation-card h1 {
            font-size: 2.1rem !important;
            color: #3D3121 !important;
            font-weight: 800 !important;
            margin: 0 0 10px 0 !important;
        }

        .confirmation-subtitle {
            color: #7A6C5B !important;
            font-size: 1rem !important;
            margin: 0 0 28px 0 !important;
            line-height: 1.5 !important;
        }

        /* ===== RECEIPT CARD COMPONENT ===== */
        .receipt-box {
            background: #FAF6F0 !important;
            border: 1px solid #EFE6D8 !important;
            border-radius: 18px !important;
            padding: 24px 28px !important;
            text-align: left !important;
            margin: 28px 0 36px 0 !important;
            box-shadow: 0 4px 20px rgba(66, 52, 30, 0.04) !important;
        }

        .receipt-row {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding: 12px 0 !important;
            border-bottom: 1px dashed #E3D9CC !important;
        }

        .receipt-row:last-child {
            border-bottom: none !important;
            padding-bottom: 0 !important;
        }

        .receipt-label {
            font-size: 0.92rem !important;
            color: #7A6C5B !important;
            font-weight: 600 !important;
        }

        .receipt-val {
            font-size: 0.96rem !important;
            color: #3E3220 !important;
            font-weight: 700 !important;
        }

        .ord-id-badge {
            background: #FFF7ED !important;
            color: #CB4F1B !important;
            border: 1px solid #FFEDD5 !important;
            padding: 4px 14px !important;
            border-radius: 6px !important;
            font-weight: 800 !important;
            font-size: 0.92rem !important;
        }

        .paid-amount-badge {
            background: #FFFBEB !important;
            color: #B45309 !important;
            border: 1px solid #FDE68A !important;
            padding: 5px 16px !important;
            border-radius: 8px !important;
            font-size: 1.1rem !important;
            font-weight: 800 !important;
        }

        .status-placed-badge {
            background: #ECFDF5 !important;
            color: #047857 !important;
            border: 1px solid #A7F3D0 !important;
            padding: 4px 14px !important;
            border-radius: 20px !important;
            font-weight: 800 !important;
            font-size: 0.86rem !important;
        }

        /* ===== ACTION BUTTONS ===== */
        .action-btns-row {
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            gap: 20px !important;
            margin-top: 32px !important;
            flex-wrap: wrap !important;
        }

        .btn-secondary {
            display: inline-flex !important;
            align-items: center !important;
            gap: 10px !important;
            padding: 15px 32px !important;
            background: #ffffff !important;
            color: #4E4133 !important;
            border: 2px solid #4E4133 !important;
            border-radius: 50px !important;
            font-size: 0.98rem !important;
            font-weight: 800 !important;
            text-decoration: none !important;
            cursor: pointer !important;
            box-shadow: 0 4px 14px rgba(78, 65, 51, 0.1) !important;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1) !important;
        }

        .btn-secondary:hover {
            background: #4E4133 !important;
            color: #ffffff !important;
            transform: translateY(-3px) !important;
            box-shadow: 0 8px 24px rgba(78, 65, 51, 0.25) !important;
        }

        .explore-btn {
            display: inline-flex !important;
            align-items: center !important;
            gap: 10px !important;
            padding: 16px 36px !important;
            background: linear-gradient(135deg, #FFC107 0%, #F59E0B 100%) !important;
            color: #3D3121 !important;
            border-radius: 50px !important;
            font-size: 1.02rem !important;
            font-weight: 800 !important;
            text-decoration: none !important;
            cursor: pointer !important;
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.35) !important;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1) !important;
        }

        .explore-btn:hover {
            background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%) !important;
            transform: translateY(-3px) scale(1.02) !important;
            box-shadow: 0 12px 32px rgba(245, 158, 11, 0.5) !important;
            color: #3D3121 !important;
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
            <a href="orderHistory.jsp">Order History</a>
            <a href="home#about">About Us</a>
        </nav>
    </header>

    <main class="checkout-page">
        <div class="confirmation-card">
            <!-- Animated Food Delivery Driver Scooter Hero -->
            <div class="lottie-animation-wrapper">
                <div class="delivery-scooter-hero">
                    <div class="scooter-motion-container">
                        <!-- Speed / Wind Lines -->
                        <div class="speed-lines">
                            <span class="line line1"></span>
                            <span class="line line2"></span>
                            <span class="line line3"></span>
                        </div>
                        
                        <!-- Scooter & Driver Vector Graphic -->
                        <svg class="scooter-svg" viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg">
                            <!-- Ground Shadow -->
                            <ellipse cx="100" cy="108" rx="65" ry="5" fill="rgba(66,52,30,0.15)">
                                <animate attributeName="rx" values="65;58;65" dur="0.5s" repeatCount="indefinite" />
                            </ellipse>

                            <!-- Bouncing Scooter & Rider Body -->
                            <g class="scooter-body">
                                <!-- Mealtime Delivery Box -->
                                <rect x="26" y="30" width="36" height="36" rx="6" fill="#CB4F1B" />
                                <rect x="29" y="33" width="30" height="30" rx="4" fill="#E4A56E" opacity="0.35" />
                                <text x="44" y="53" font-size="16" text-anchor="middle" fill="#FFFFFF">🍽️</text>
                                
                                <!-- Scooter Frame -->
                                <path d="M 48 68 L 125 68 L 142 42 L 118 42" stroke="#CB4F1B" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" fill="none" />
                                <path d="M 125 68 L 145 90" stroke="#CB4F1B" stroke-width="5" stroke-linecap="round" />
                                <path d="M 58 68 L 58 90" stroke="#CB4F1B" stroke-width="5" stroke-linecap="round" />

                                <!-- Driver Body -->
                                <path d="M 72 65 L 88 38 L 115 42" stroke="#42341E" stroke-width="11" stroke-linecap="round" stroke-linejoin="round" fill="none" />
                                <path d="M 88 42 L 122 43" stroke="#42341E" stroke-width="5" stroke-linecap="round" fill="none" />
                                
                                <!-- Red Helmet & Head -->
                                <circle cx="94" cy="22" r="13" fill="#CB4F1B" />
                                <path d="M 97 18 A 8 8 0 0 1 105 26 L 97 26 Z" fill="#42341E" />

                                <!-- Scooter Front Shield & Light -->
                                <path d="M 130 38 L 146 75 L 124 75 Z" fill="#CB4F1B" />
                                <circle cx="146" cy="48" r="5" fill="#FFC107" />
                                <path d="M 151 43 L 185 32 L 185 64 L 151 53 Z" fill="rgba(255, 193, 7, 0.28)" />

                                <!-- Spinning Back Wheel -->
                                <g class="wheel wheel-back">
                                    <circle cx="58" cy="90" r="16" fill="#3D3121" />
                                    <circle cx="58" cy="90" r="10" fill="#EFE8DF" />
                                    <circle cx="58" cy="90" r="4" fill="#3D3121" />
                                    <line x1="58" y1="74" x2="58" y2="106" stroke="#3D3121" stroke-width="2" />
                                    <line x1="42" y1="90" x2="74" y2="90" stroke="#3D3121" stroke-width="2" />
                                </g>

                                <!-- Spinning Front Wheel -->
                                <g class="wheel wheel-front">
                                    <circle cx="145" cy="90" r="16" fill="#3D3121" />
                                    <circle cx="145" cy="90" r="10" fill="#EFE8DF" />
                                    <circle cx="145" cy="90" r="4" fill="#3D3121" />
                                    <line x1="145" y1="74" x2="145" y2="106" stroke="#3D3121" stroke-width="2" />
                                    <line x1="129" y1="90" x2="161" y2="90" stroke="#3D3121" stroke-width="2" />
                                </g>
                            </g>
                        </svg>

                        <!-- Moving Road Surface -->
                        <div class="scooter-road">
                            <div class="road-line"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="success-icon-badge">✓</div>
            <h1>Order Placed Successfully!</h1>
            <p class="confirmation-subtitle">Thank you for ordering with Mealtime. Your food delivery driver is on the way!</p>

            <% if (order != null) { %>
                <div class="receipt-box">
                    <div class="receipt-row">
                        <span class="receipt-label">Order Reference ID</span>
                        <span class="ord-id-badge">#ORD-<%= order.getOrderId() %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Order Date & Time</span>
                        <span class="receipt-val"><%= order.getOrderDate() != null ? order.getOrderDate() : "Just now" %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Total Amount Paid</span>
                        <span class="paid-amount-badge">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Payment Mode</span>
                        <span class="receipt-val"><%= order.getPaymentMode() %></span>
                    </div>

                    <div class="receipt-row">
                        <span class="receipt-label">Status</span>
                        <span class="status-placed-badge">● <%= order.getStatus() %></span>
                    </div>

                    <% if (customerAddress != null && !customerAddress.trim().isEmpty()) { %>
                        <div class="receipt-row">
                            <span class="receipt-label">Deliver To</span>
                            <span class="receipt-val" style="text-align: right; max-width: 280px;">📍 <%= customerAddress %></span>
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
