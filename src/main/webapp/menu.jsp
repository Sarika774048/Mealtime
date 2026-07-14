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

            <div class="restaurant-banner-content">
                <h1 id="restaurantName">Restaurant Name</h1>

                <p class="cuisine" id="restaurantCuisine">
                    Italian, Pizza
                </p>

                <p class="restaurant-description">
                    Explore delicious food from this restaurant. Select your favourite
                    dish and get it delivered fresh to your doorstep.
                </p>

                <div class="restaurant-details">
                    <span class="rating" id="restaurantRating">★ 4.5</span>
                    <span class="detail-pill" id="restaurantEta">⚡ 30–40 min</span>
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
                    		
            for(Menu m : menu){
            	
            	%>
            	
            	   <article class="menu-item-card">
                    <img
                        src="<%= m.getImagePath() %>"
                        alt="Margherita Pizza">

                    <div class="menu-item-content">
                        <div class="menu-item-title">
                            <h3><%= m.getItemName() %></h3>
                            <span class="food-price">₹<%=m.getPrice() %></span>
                        </div>

                        <p>
                            <%= m.getDescription() %>
                        </p>

                        <div class="menu-item-footer">
                            <span>★ <%= m.getRatings() %></span>
                            <span class="availability"><%= m.isAvailable() %></span>
                        </div>
                    </div>
                </article>

                
            	
            	
            	<%
            	
            }
            %>


             

                
            </div>
        </section>
    </main>

 
</body>
</html>