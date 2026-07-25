<%@page import="com.mealtime.model.Restaurant"%>
<%@page import="com.mealtime.daoimplementation.RestaurantDaoImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.util.*" %>
 <%@ page import="com.mealtime.model.Menu" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu | Mealtime</title>

    <!-- External CSS files -->
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/menu.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>

<body>


    <main class="menu-page">

        <a href="home" class="back-link">← Back to restaurants</a>

        <!-- Restaurant details -->
        <section class="restaurant-banner">
            <img
                id="restaurantImage"
                class="restaurant-banner-image"
                src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1000&q=85"
                alt="Restaurant image">


<% int restaurantId =  Integer.parseInt(request.getParameter("restaurantId")); 
	RestaurantDaoImpl restaurantDaoImpl = new RestaurantDaoImpl();
	Restaurant restaurant = restaurantDaoImpl.getRestaurat(restaurantId);

%>

            <div class="restaurant-banner-content">
                <h1 id="restaurantName"><%= restaurant.getName() %></h1>
                

                <p class="cuisine" id="restaurantCuisine">
                    <%= restaurant.getCuisineType() %>
                </p>

                <p class="restaurant-description">
                    Explore delicious food from this restaurant. Select your favourite
                    dish and get it delivered fresh to your doorstep.
                </p>

                <div class="restaurant-details">
                    <span class="rating" id="restaurantRating">★ <%= restaurant.getRating() %></span>
                    <span class="detail-pill" id="restaurantEta">⚡ <%= restaurant.getEta() %> min</span>
                    <span class="detail-pill">₹250 for one</span>
                    <span class="detail-pill">Open now</span>
                </div>
            </div>
        </section>

        <!-- Food menu -->
        <section class="menu-section">
            <div class="menu-heading">
                <p>RESTAURANT MENU</p>
                <h2>What’s available</h2>
            </div>

            <div class="menu-grid">
            
            <%
            List<Menu> menu = (List<Menu>)request.getAttribute("menu");
            if (menu != null && !menu.isEmpty()) {
                for(Menu m : menu){
            %>
            	   <article class="menu-item-card">
                    <img
                        src="<%= m.getImagePath() %>"
                        alt="<%= m.getItemName() %>">

                    <div class="menu-item-content">
                        <div class="menu-item-title">
                            <h3><%= m.getItemName() %></h3>
                            <span class="food-price">₹<%= m.getPrice() %></span>
                        </div>

                        <p>
                            <%= m.getDescription() %>
                        </p>

                        <div class="menu-item-footer">
                            <div class="menu-item-meta">
                                <span class="rating-pill">★ <%= m.getRatings() %></span>
                                <span class="<%= m.isAvailable() ? "availability" : "not-available" %>">
                                    <%= m.isAvailable() ? "Available" : "Sold Out" %>
                                </span>
                            </div>

                            <form action="CartServlet" method="post" class="add-to-cart-form">
                                <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                <input type="hidden" name="restaurantId" value="<%= m.getRestaurantId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="action" value="add">
                                <button style="background-color: green; padding : 10px; type="submit" class="add-to-cart-btn" <%= !m.isAvailable() ? "disabled" : "" %>>
                                    <span " class="cart-icon">🛒</span> Add to Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            <%
                }
            } else {
            %>
                <p class="no-data">No menu items available for this restaurant.</p>
            <%
            }
            %>


             

                
            </div>
        </section>
    </main>

 
</body>
</html>