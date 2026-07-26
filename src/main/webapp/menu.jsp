<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mealtime.model.Restaurant" %>
<%@ page import="com.mealtime.model.Menu" %>
<%@ page import="com.mealtime.model.User" %>
<%@ page import="com.mealtime.model.Cart" %>
<%@ page import="com.mealtime.daoimplementation.RestaurantDaoImpl" %>

<%
    String restaurantIdStr = request.getParameter("restaurantId");
    int restaurantId = 1;
    if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
        try {
            restaurantId = Integer.parseInt(restaurantIdStr);
        } catch (NumberFormatException e) {
            restaurantId = 1;
        }
    }

    RestaurantDaoImpl restaurantDaoImpl = new RestaurantDaoImpl();
    Restaurant restaurant = restaurantDaoImpl.getRestaurat(restaurantId);

    String defaultBannerImg = (restaurant != null && restaurant.getImagePath() != null && !restaurant.getImagePath().isEmpty())
            ? restaurant.getImagePath() 
            : "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1000&q=85";

    String userEmail = (String) session.getAttribute("email");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= restaurant != null ? restaurant.getName() : "Menu" %> | Mealtime</title>

    <!-- External CSS files -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">

    <!-- Modern Web Engine JS -->
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body style="background-color: #FBF4EB !important; color: #42341E !important; font-family: 'Poppins', sans-serif !important;">

    <!-- Header / Navbar -->
    <header class="navbar" style="background: rgba(251, 244, 235, 0.96) !important; border-bottom: 1px solid rgba(66, 52, 30, 0.08) !important;">
        <a href="home" class="logo" style="color: #42341E !important;">
            <span class="logo-icon">🍽</span>
            Meal<span style="color: #CB4F1B !important;">time</span>
        </a>

        <nav class="nav-links">
            <a href="home" style="color: #42341E !important;">Home</a>
            <a href="home#restaurants" style="color: #42341E !important;">Restaurants</a>
            <a href="cart.jsp" style="color: #42341E !important;">Cart</a>
            <a href="orderHistory.jsp" style="color: #42341E !important;">Orders</a>
        </nav>

        <div class="nav-actions">
            <%
                Cart sessionCart = (Cart) session.getAttribute("cart");
                int cartItemCount = 0;
                if (sessionCart != null && sessionCart.getItems() != null) {
                    cartItemCount = sessionCart.getItems().size();
                }
            %>
            <a href="cart.jsp" class="nav-cart-pill" title="View Cart" style="background: rgba(66, 52, 30, 0.08) !important; color: #42341E !important; border-color: rgba(66, 52, 30, 0.15) !important;">
                🛒 Cart <% if (cartItemCount > 0) { %><span class="cart-badge"><%= cartItemCount %></span><% } %>
            </a>

            <% 
                User sessionUser = (User) session.getAttribute("user");
                String displayName = (sessionUser != null && sessionUser.getName() != null && !sessionUser.getName().isEmpty()) ? sessionUser.getName() : userEmail;
            %>
            <% if (userEmail != null && !userEmail.isEmpty()) { %>
                <div class="user-dropdown-container" id="menuUserDropdownContainer">
                    <button type="button" class="user-pill-btn" id="menuUserMenuBtn" style="background: rgba(66, 52, 30, 0.08) !important; color: #42341E !important; border-color: rgba(66, 52, 30, 0.15) !important;">
                        <span class="user-avatar">👤</span>
                        <span class="user-name-text"><%= displayName %></span>
                        <span class="dropdown-chevron">▼</span>
                    </button>
                    <div class="user-dropdown-menu" id="menuUserDropdownMenu">
                        <div class="dropdown-header">
                            <div class="dropdown-user-name"><%= displayName %></div>
                            <div class="dropdown-user-email"><%= userEmail %></div>
                        </div>
                        <div class="dropdown-divider"></div>
                        <a href="orderHistory.jsp" class="dropdown-item">📦 My Orders</a>
                        <a href="cart.jsp" class="dropdown-item">🛒 My Cart</a>
                        <div class="dropdown-divider"></div>
                        <a href="logout" class="dropdown-item logout-item">🚪 Logout</a>
                    </div>
                </div>
            <% } else { %>
                <a href="login.html" class="login-link" style="color: #42341E !important;">Log in</a>
                <a href="register.html" class="signup-btn" style="background: linear-gradient(135deg, #CB4F1B 0%, #E4A56E 100%) !important; color: #ffffff !important;">Sign up</a>
            <% } %>
        </div>
    </header>

    <main class="menu-page" style="min-height: 100vh; padding: 100px 8% 70px; background-color: #FBF4EB !important; color: #42341E !important;">

        <a href="home" class="back-link" style="color: #CB4F1B !important; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 24px;">← Back to restaurants</a>

        <!-- Restaurant details hero banner -->
        <% if (restaurant != null) { %>
            <section class="restaurant-banner" style="display: grid !important; grid-template-columns: minmax(260px, 1fr) 1.5fr !important; background: #ffffff !important; border: 1px solid rgba(66, 52, 30, 0.08) !important; border-radius: 24px !important; box-shadow: 0 8px 40px rgba(66, 52, 30, 0.08) !important; margin-bottom: 40px !important; overflow: hidden !important;">
                <img id="restaurantImage"
                     class="restaurant-banner-image"
                     src="<%= defaultBannerImg %>"
                     alt="<%= restaurant.getName() %>"
                     style="width: 100% !important; height: 100% !important; min-height: 240px !important; max-height: 300px !important; object-fit: cover !important;">

                <div class="restaurant-banner-content" style="padding: 30px 34px !important; display: flex !important; flex-direction: column !important; justify-content: center !important;">
                    <h1 id="restaurantName" style="color: #42341E !important; font-size: 2.2rem !important; font-weight: 800 !important; margin-bottom: 6px !important;"><%= restaurant.getName() %></h1>

                    <p class="cuisine" id="restaurantCuisine" style="color: #CB4F1B !important; font-weight: 600 !important; margin-bottom: 12px !important;">
                        <%= restaurant.getCuisineType() != null ? restaurant.getCuisineType() : "Multi-Cuisine" %>
                    </p>

                    <p class="restaurant-description" style="color: #7C6C58 !important; font-size: 0.9rem !important; margin-bottom: 18px !important; line-height: 1.6 !important;">
                        Explore delicious, freshly cooked food from <%= restaurant.getName() %>. Select your favorite dishes below and get them delivered hot to your doorstep.
                    </p>

                    <div class="restaurant-details" style="display: flex !important; flex-wrap: wrap !important; gap: 10px !important; align-items: center !important;">
                        <span class="rating-badge-hero" id="restaurantRating" style="background: #6A884F !important; color: #ffffff !important; padding: 6px 14px !important; border-radius: 8px !important; font-weight: 700 !important;">★ <%= restaurant.getRating() > 0 ? restaurant.getRating() : 4.5 %></span>
                        <span class="detail-pill" id="restaurantEta" style="background: #F5E8D8 !important; color: #42341E !important; padding: 6px 14px !important; border-radius: 50px !important; border: 1px solid rgba(66, 52, 30, 0.08) !important;">⚡ <%= restaurant.getEta() != null ? restaurant.getEta() : "30-40" %> min</span>
                        <span class="detail-pill" style="background: #F5E8D8 !important; color: #42341E !important; padding: 6px 14px !important; border-radius: 50px !important; border: 1px solid rgba(66, 52, 30, 0.08) !important;">₹250 for one</span>
                        <span class="detail-pill" style="background: #F5E8D8 !important; color: #6A884F !important; font-weight: 600 !important; padding: 6px 14px !important; border-radius: 50px !important; border: 1px solid rgba(66, 52, 30, 0.08) !important;">● Open now</span>
                    </div>
                </div>
            </section>
        <% } %>

        <!-- Food menu - Exact Swiggy Style List View with Side-by-Side Flex Layout -->
        <section class="menu-section" style="max-width: 860px !important; margin: 0 auto !important;">
            
            <%
            @SuppressWarnings("unchecked")
            List<Menu> menu = (List<Menu>) request.getAttribute("menu");
            int itemCount = (menu != null) ? menu.size() : 0;
            %>

            <div class="category-header" style="display: flex !important; justify-content: space-between !important; align-items: center !important; padding: 16px 0 !important; border-bottom: 2px solid rgba(66, 52, 30, 0.08) !important; margin-bottom: 20px !important;">
                <div class="category-title" style="font-size: 1.35rem !important; font-weight: 800 !important; color: #42341E !important; display: flex !important; align-items: center !important; gap: 8px !important;">
                    Recommended <span class="category-count" style="color: #A39380 !important;">(<%= itemCount %>)</span>
                </div>
                <span class="collapse-icon" style="color: #A39380 !important;">▲</span>
            </div>

            <div class="swiggy-menu-list" style="display: flex !important; flex-direction: column !important; gap: 16px !important;">
            
            <%
            if (menu != null && !menu.isEmpty()) {
                for (Menu m : menu) {
                    String itemImg = (m.getImagePath() != null && !m.getImagePath().trim().isEmpty()) 
                            ? m.getImagePath() 
                            : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80";
                    
                    boolean isVeg = m.getItemName().toLowerCase().contains("paneer") 
                                 || m.getItemName().toLowerCase().contains("veg") 
                                 || m.getItemName().toLowerCase().contains("pizza");
            %>
                    <article class="swiggy-menu-item" style="display: flex !important; flex-direction: row !important; justify-content: space-between !important; align-items: flex-start !important; gap: 24px !important; padding: 22px 20px !important; background: #ffffff !important; border: 1px solid rgba(66, 52, 30, 0.08) !important; border-radius: 18px !important; box-shadow: 0 4px 16px rgba(66, 52, 30, 0.04) !important;">
                        
                        <!-- Left Side: Details -->
                        <div class="swiggy-item-details" style="flex: 1 !important; min-width: 0 !important; display: flex !important; flex-direction: column !important;">
                            
                            <div class="swiggy-badge-row" style="display: flex !important; align-items: center !important; gap: 8px !important; margin-bottom: 6px !important;">
                                <% if (isVeg) { %>
                                    <div class="veg-icon-box" title="Pure Veg" style="width: 16px !important; height: 16px !important; border: 2px solid #6A884F !important; border-radius: 3px !important; display: flex !important; align-items: center !important; justify-content: center !important;"><div class="veg-dot" style="width: 8px !important; height: 8px !important; border-radius: 50% !important; background: #6A884F !important;"></div></div>
                                <% } else { %>
                                    <div class="non-veg-icon-box" title="Non-Veg" style="width: 16px !important; height: 16px !important; border: 2px solid #CB4F1B !important; border-radius: 3px !important; display: flex !important; align-items: center !important; justify-content: center !important;"><div class="non-veg-triangle" style="width: 0 !important; height: 0 !important; border-left: 4px solid transparent !important; border-right: 4px solid transparent !important; border-bottom: 7px solid #CB4F1B !important;"></div></div>
                                <% } %>
                                <span class="bestseller-tag" style="font-size: 0.76rem !important; font-weight: 700 !important; color: #CB4F1B !important; background: rgba(203, 79, 27, 0.08) !important; padding: 2px 8px !important; border-radius: 6px !important;">★ Bestseller</span>
                            </div>

                            <h3 class="swiggy-item-name" style="font-size: 1.12rem !important; font-weight: 700 !important; color: #42341E !important; margin-bottom: 4px !important;"><%= m.getItemName() %></h3>
                            <div class="swiggy-item-price" style="font-size: 1.05rem !important; font-weight: 700 !important; color: #42341E !important; margin-bottom: 6px !important;">₹<%= String.format("%.0f", m.getPrice()) %></div>

                            <div class="swiggy-rating-row" style="display: flex !important; align-items: center !important; gap: 6px !important; margin-bottom: 8px !important;">
                                <span class="star-rating" style="font-size: 0.82rem !important; font-weight: 700 !important; color: #6A884F !important;">★ <%= m.getRatings() > 0 ? m.getRatings() : 4.7 %></span>
                                <span class="rating-count" style="font-size: 0.78rem !important; color: #A39380 !important;">(1.5K+)</span>
                            </div>

                            <p class="swiggy-item-desc" style="font-size: 0.86rem !important; color: #7C6C58 !important; line-height: 1.5 !important; margin-top: 4px !important; max-width: 540px !important;">
                                <%= m.getDescription() != null && !m.getDescription().isEmpty() 
                                        ? m.getDescription() 
                                        : "Prepared with authentic house spices and served fresh with delicious raita and gravy." %>
                                <span class="more-link" style="color: #CB4F1B !important; font-weight: 600 !important; cursor: pointer !important;">more</span>
                            </p>
                        </div>

                        <!-- Right Side: Food Image & Overlapping Swiggy ADD Button -->
                        <div class="swiggy-item-action" style="width: 140px !important; flex-shrink: 0 !important; display: flex !important; flex-direction: column !important; align-items: center !important;">
                            <div class="swiggy-img-box" style="position: relative !important; width: 140px !important; height: 110px !important; display: flex !important; justify-content: center !important;">
                                <img src="<%= itemImg %>" 
                                     alt="<%= m.getItemName() %>" 
                                     class="swiggy-food-img"
                                     width="140"
                                     height="110"
                                     style="width: 140px !important; max-width: 140px !important; height: 110px !important; max-height: 110px !important; object-fit: cover !important; border-radius: 16px !important; display: block !important;">

                                <form action="CartServlet" method="post" class="swiggy-add-form" style="position: absolute !important; bottom: -14px !important; left: 50% !important; transform: translateX(-50%) !important; z-index: 5 !important;">
                                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= m.getRestaurantId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="action" value="add">
                                    <button type="submit" class="swiggy-btn-add" <%= !m.isAvailable() ? "disabled" : "" %> style="width: 96px !important; height: 36px !important; background: #ffffff !important; color: #6A884F !important; font-size: 0.92rem !important; font-weight: 800 !important; border: 2px solid #6A884F !important; border-radius: 10px !important; box-shadow: 0 3px 10px rgba(106, 136, 79, 0.15) !important; cursor: pointer !important; text-align: center !important; display: flex !important; align-items: center !important; justify-content: center !important;">
                                        <%= m.isAvailable() ? "ADD" : "SOLD OUT" %>
                                    </button>
                                </form>
                            </div>
                            <span class="customisable-text" style="display: block !important; margin-top: 18px !important; font-size: 0.72rem !important; color: #A39380 !important; text-align: center !important;">Customisable</span>
                        </div>

                    </article>
            <%
                }
            } else {
            %>
                <div class="no-data" style="text-align: center; padding: 40px; color: #A39380;">
                    <p>No menu items currently available for this restaurant.</p>
                </div>
            <%
            }
            %>

            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer id="about" style="padding: 40px 8% 28px; border-top: 1px solid rgba(66, 52, 30, 0.08); background: #ffffff; text-align: center;">
        <a href="home" class="logo footer-logo" style="color: #42341E !important;">
            <span class="logo-icon">🍽</span>
            Meal<span style="color: #CB4F1B !important;">time</span>
        </a>
        <p style="color: #A39380 !important; font-size: 0.85rem; margin-top: 8px;">© 2026 Mealtime. Made for food lovers.</p>
    </footer>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const menuContainer = document.getElementById("menuUserDropdownContainer");
            const menuBtn = document.getElementById("menuUserMenuBtn");

            if (menuContainer && menuBtn) {
                menuBtn.addEventListener("click", function(e) {
                    e.stopPropagation();
                    menuContainer.classList.toggle("active");
                });

                document.addEventListener("click", function(e) {
                    if (!menuContainer.contains(e.target)) {
                        menuContainer.classList.remove("active");
                    }
                });
            }
        });
    </script>
</body>
</html>