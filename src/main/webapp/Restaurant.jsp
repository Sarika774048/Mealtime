<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mealtime.model.Restaurant" %>
<%@ page import="com.mealtime.model.User" %>
<%@ page import="com.mealtime.model.Cart" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mealtime | Food & Restaurant</title>

    <!-- External Stylesheets -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css?v=999">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-design.css?v=999">

    <!-- Modern Web Engine JS -->
    <script src="<%= request.getContextPath() %>/js/modern-app.js" defer></script>

    <!-- Google font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Navigation bar -->
    <header class="navbar" id="mainNavbar">
        <a href="#" class="logo">
            <span class="logo-icon">🍽</span>
            Meal<span>time</span>
        </a>

        <nav class="nav-links">
            <a href="#home" class="active">Home</a>
            <a href="#restaurants">Restaurants</a>
            <a href="cart.jsp">Cart</a>
            <a href="orderHistory.jsp">Orders</a>
        </nav>

        <div class="nav-actions">
            <%
                Cart sessionCart = (Cart) session.getAttribute("cart");
                int cartItemCount = 0;
                if (sessionCart != null && sessionCart.getItems() != null) {
                    cartItemCount = sessionCart.getItems().size();
                }
            %>
            <a href="cart.jsp" class="nav-cart-pill" title="View Cart">
                🛒 Cart <% if (cartItemCount > 0) { %><span class="cart-badge"><%= cartItemCount %></span><% } %>
            </a>

            <% 
                User sessionUser = (User) session.getAttribute("user");
                String userEmail = (String) session.getAttribute("email"); 
                String displayName = (sessionUser != null && sessionUser.getName() != null && !sessionUser.getName().isEmpty()) ? sessionUser.getName() : userEmail;
            %>
            <% if (userEmail != null && !userEmail.isEmpty()) { %>
                <!-- Swiggy / Zomato User Dropdown Pill -->
                <div class="user-dropdown-container" id="userDropdownContainer">
                    <button type="button" class="user-pill-btn" id="userMenuBtn">
                        <span class="user-avatar">👤</span>
                        <span class="user-name-text"><%= displayName %></span>
                        <span class="dropdown-chevron">▼</span>
                    </button>
                    <div class="user-dropdown-menu" id="userDropdownMenu">
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
                <a href="login.html" class="login-link">Log in</a>
                <a href="register.html" class="signup-btn">Sign up</a>
            <% } %>
        </div>
    </header>

    <main>
        <!-- LUXURY HERO SECTION (SMOOTH REVEAL) -->
        <section class="luxury-hero-container" id="home">
            
            <!-- Hero Main Text Content Column -->
            <div class="hero-main-content reveal-on-scroll">
                <h1 class="huge-hero-title">FOOD <span class="accent-ampersand">&amp;</span><br>RESTAURANT</h1>
                
                <div class="title-underline-divider"></div>

                <p class="hero-description">
                    Discover authentic gourmet dishes, top-rated local kitchens, and get delicious meals delivered straight to your door in minutes.
                </p>

                <!-- Floating Glassmorphic Search Bar -->
                <div class="dark-search-wrap">
                    <span style="font-size: 1.25rem; color: #D9381E; margin-right: 10px;">📍</span>
                    <input type="text" id="searchInput" placeholder="Search by restaurant name or cuisine...">
                    <button type="button" id="searchBtn">Find Food</button>
                </div>

                <!-- Action Track Slider -->
                <div class="hero-action-track">
                    <span class="action-track-label">EXPLORE MORE RECIPES & RESTAURANTS</span>
                    <div class="action-track-controls">
                        <span style="font-size: 1.2rem; color: #ffffff;">+</span>
                        <div class="control-arrow-btn" id="heroPrevBtn">‹</div>
                        <div class="control-arrow-btn" id="heroNextBtn">›</div>
                    </div>
                </div>
            </div>

            <!-- Right Column Feast Image & Floating Preview -->
            <div class="hero-feast-side reveal-on-scroll reveal-delay-1">
                <img src="https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1400&q=85" alt="Gourmet Food Feast" class="feast-main-image">
                
                <!-- Floating Video / Dish Badge Preview -->
                <div class="floating-video-thumb">
                    <div class="play-circle-icon">▶</div>
                    <div class="video-thumb-text">
                        <h4>Chef's Special Feast</h4>
                        <p>⚡ 25 Min Express Delivery</p>
                    </div>
                </div>
            </div>

        </section>

        <!-- Right-Scrollable Cravings / Food Spotlight Carousel Section -->
        <section class="cravings-section reveal-on-scroll">
            <div class="section-heading" style="display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <p class="section-tag">WHAT'S ON YOUR MIND?</p>
                    <h2>In the spotlight: Food cravings</h2>
                </div>
                <span style="font-size: 0.84rem; color: #7C6C58; font-weight: 600;">Scroll right to explore →</span>
            </div>

            <div class="cravings-wrapper">
                <button type="button" class="scroll-btn left" id="scrollLeftBtn" aria-label="Scroll left">‹</button>

                <div class="cravings-carousel" id="cravingsCarousel">
                    <div class="craving-card active-filter" data-cuisine="all">
                        <div class="craving-icon-circle">🍽️</div>
                        <span style="font-size: 0.84rem; font-weight: 700; color: #CB4F1B; text-align: center;">All Cravings</span>
                    </div>

                    <div class="craving-card" data-cuisine="Italian,Pizza">
                        <div class="craving-icon-circle">🍕</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Hot Pizza</span>
                    </div>

                    <div class="craving-card" data-cuisine="Fast Food,Chicken,Biryani,Punjabi,Burger">
                        <div class="craving-icon-circle">🍗</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Crispy Chicken</span>
                    </div>

                    <div class="craving-card" data-cuisine="Chinese,Asian">
                        <div class="craving-icon-circle">🍜</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Chinese Wok</span>
                    </div>

                    <div class="craving-card" data-cuisine="Desserts,Bakery,Sweets">
                        <div class="craving-icon-circle">🍰</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Sweet Tooth</span>
                    </div>

                    <div class="craving-card" data-cuisine="Burger,Fast Food">
                        <div class="craving-icon-circle">🍔</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Juicy Burgers</span>
                    </div>

                    <div class="craving-card" data-cuisine="Biryani,Indian">
                        <div class="craving-icon-circle">🍲</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Royal Biryani</span>
                    </div>

                    <div class="craving-card" data-cuisine="Beverages,Shakes,Juice">
                        <div class="craving-icon-circle">🧋</div>
                        <span style="font-size: 0.84rem; font-weight: 600; color: #42341E; text-align: center;">Cold Shakes</span>
                    </div>
                </div>

                <button type="button" class="scroll-btn right" id="scrollRightBtn" aria-label="Scroll right">›</button>
            </div>
        </section>

        <!-- Restaurant Bento Grid Section with Swiggy/Zomato Quick Filter Chips -->
        <section class="restaurants-section reveal-on-scroll" id="restaurants">
            <div class="section-heading" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px;">
                <div>
                    <p class="section-tag">CURATED FOR YOU</p>
                    <h2>Popular restaurants near you</h2>
                </div>
                <a href="#restaurants" style="color: #CB4F1B; font-weight: 600; text-decoration: none;">View all restaurants →</a>
            </div>

            <!-- Swiggy & Zomato Quick Filter Chips -->
            <div class="quick-filter-chips">
                <div class="filter-chip active" data-filter="all">🍽️ All</div>
                <div class="filter-chip" data-filter="rating">🌟 Rating 4.0+</div>
                <div class="filter-chip" data-filter="fast">⚡ Fast Delivery (&lt; 30 mins)</div>
                <div class="filter-chip" data-filter="offers">🏷️ Great Offers</div>
                <div class="filter-chip" data-filter="veg">🥗 Pure Veg & Healthy</div>
            </div>

            <div class="restaurant-grid">
                <% 
                    List<Restaurant> allRestaurant = (List<Restaurant>) request.getAttribute("list"); 
                    if (allRestaurant == null || allRestaurant.isEmpty()) {
                        try {
                            com.mealtime.daoimplementation.RestaurantDaoImpl fallbackDao = new com.mealtime.daoimplementation.RestaurantDaoImpl();
                            allRestaurant = fallbackDao.getAllRestaurant();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    if (allRestaurant != null && !allRestaurant.isEmpty()) {
                        for (Restaurant res : allRestaurant) { 
                %>
                <a href="menu?restaurantId=<%= res.getRestaurantid()%>" 
                   class="restaurant-card-link reveal-on-scroll" 
                   data-cuisine="<%= res.getCuisineType() != null ? res.getCuisineType() : "" %>"
                   data-name="<%= res.getName() != null ? res.getName() : "" %>"
                   data-rating="<%= res.getRating() %>"
                   data-eta="<%= res.getEta() != null ? res.getEta() : "" %>">
                    <article class="restaurant-card">
                        <div class="restaurant-image-wrapper">
                            <img src="<%= (res.getImagePath() != null) ? res.getImagePath() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1000&q=85" %>" alt="<%= res.getName() %>">
                            <span class="offer-badge">50% OFF up to ₹100</span>
                            <span class="favorite-icon">♡</span>
                            <span class="delivery-badge">⚡ Fast delivery</span>
                        </div>

                        <div class="restaurant-info">
                            <div class="restaurant-title-row">
                                <h3><%= res.getName() %></h3>
                                <span class="rating">★ <%= res.getRating() %></span>
                            </div>

                            <p class="cuisine"><%= res.getCuisineType() %></p>

                            <div class="restaurant-meta">
                                <span>₹250 for one</span>
                                <span>•</span>
                                <span><%= res.getEta() %></span>
                            </div>
                        </div>
                    </article>
                </a>
                <% 
                        } 
                    } else { 
                %>
                    <p style="color: #A39380;">No restaurants found.</p>
                <% 
                    } 
                %>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features reveal-on-scroll" id="offers">
            <div class="feature">
                <span class="feature-icon">⚡</span>
                <div>
                    <h3>Quick delivery</h3>
                    <p>Fresh food at your doorstep in under 30 mins.</p>
                </div>
            </div>

            <div class="feature">
                <span class="feature-icon">🍲</span>
                <div>
                    <h3>Many choices</h3>
                    <p>Discover hundreds of signature meals & cuisines.</p>
                </div>
            </div>

            <div class="feature">
                <span class="feature-icon">✓</span>
                <div>
                    <h3>Easy ordering</h3>
                    <p>Order your favourite food in a few simple taps.</p>
                </div>
            </div>
        </section>
    </main>

    <!-- Floating Back To Top Button -->
    <div class="back-to-top-btn" id="backToTopBtn" title="Back to Top">↑</div>

    <footer>
        <a href="#" class="logo" style="justify-content: center; margin-bottom: 8px;">
            <span style="margin-right: 6px;">🍽</span>
            Meal<span>time</span>
        </a>
        <p>© 2026 Mealtime. Made for food lovers.</p>
    </footer>

    <!-- Interactive Smooth Scroll & Animation Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 1. Swiggy / Zomato User Dropdown Menu Toggle
            const userContainer = document.getElementById("userDropdownContainer");
            const userBtn = document.getElementById("userMenuBtn");

            if (userContainer && userBtn) {
                userBtn.addEventListener("click", function(e) {
                    e.stopPropagation();
                    userContainer.classList.toggle("active");
                });

                document.addEventListener("click", function(e) {
                    if (!userContainer.contains(e.target)) {
                        userContainer.classList.remove("active");
                    }
                });
            }

            // 2. Scroll Reveal Observer
            const observerOptions = {
                threshold: 0.12,
                rootMargin: "0px 0px -50px 0px"
            };

            const revealObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("is-visible");
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            document.querySelectorAll(".reveal-on-scroll").forEach(el => {
                revealObserver.observe(el);
            });

            // 3. Navbar shrink and Back To Top button visibility on scroll
            const navbar = document.getElementById("mainNavbar");
            const backToTopBtn = document.getElementById("backToTopBtn");

            window.addEventListener("scroll", function() {
                if (window.scrollY > 50) {
                    if (navbar) navbar.classList.add("scrolled");
                } else {
                    if (navbar) navbar.classList.remove("scrolled");
                }

                if (window.scrollY > 450) {
                    if (backToTopBtn) backToTopBtn.classList.add("is-visible");
                } else {
                    if (backToTopBtn) backToTopBtn.classList.remove("is-visible");
                }
            });

            // Back to top scroll handler
            if (backToTopBtn) {
                backToTopBtn.addEventListener("click", function() {
                    window.scrollTo({ top: 0, behavior: "smooth" });
                });
            }

            // 4. Carousel horizontal scrolling
            const carousel = document.getElementById("cravingsCarousel");
            const leftBtn = document.getElementById("scrollLeftBtn");
            const rightBtn = document.getElementById("scrollRightBtn");

            if (carousel && leftBtn && rightBtn) {
                leftBtn.addEventListener("click", function() {
                    carousel.scrollBy({ left: -300, behavior: "smooth" });
                });

                rightBtn.addEventListener("click", function() {
                    carousel.scrollBy({ left: 300, behavior: "smooth" });
                });
            }

            // 5. Swiggy / Zomato Quick Filter Chips Logic
            const filterChips = document.querySelectorAll(".filter-chip");
            const restaurantLinks = document.querySelectorAll(".restaurant-card-link");
            const searchInput = document.getElementById("searchInput");

            filterChips.forEach(chip => {
                chip.addEventListener("click", function() {
                    filterChips.forEach(c => c.classList.remove("active"));
                    this.classList.add("active");

                    const filterType = this.getAttribute("data-filter");

                    restaurantLinks.forEach(resLink => {
                        const rating = parseFloat(resLink.getAttribute("data-rating") || "0");
                        const eta = (resLink.getAttribute("data-eta") || "").toLowerCase();
                        const cuisine = (resLink.getAttribute("data-cuisine") || "").toLowerCase();

                        let match = true;
                        if (filterType === "rating") {
                            match = rating >= 4.0;
                        } else if (filterType === "fast") {
                            match = eta.includes("15") || eta.includes("20") || eta.includes("25") || eta.includes("30");
                        } else if (filterType === "offers") {
                            match = true; // All curated restaurants have active offers
                        } else if (filterType === "veg") {
                            match = cuisine.includes("veg") || cuisine.includes("healthy") || cuisine.includes("italian") || cuisine.includes("desserts");
                        }

                        if (match) {
                            resLink.style.display = "block";
                        } else {
                            resLink.style.display = "none";
                        }
                    });
                });
            });

            // 6. Cravings filtering logic
            const cravingCards = document.querySelectorAll(".craving-card");

            function filterRestaurantsByCuisine(filterCategory, query) {
                const search = (query || "").toLowerCase().trim();

                restaurantLinks.forEach(resLink => {
                    const resCuisine = (resLink.getAttribute("data-cuisine") || "").toLowerCase();
                    const resName = (resLink.getAttribute("data-name") || "").toLowerCase();

                    let categoryMatch = false;
                    if (!filterCategory || filterCategory === "all") {
                        categoryMatch = true;
                    } else {
                        const categories = filterCategory.toLowerCase().split(",");
                        categoryMatch = categories.some(cat => resCuisine.includes(cat.trim()));
                    }

                    let searchMatch = true;
                    if (search) {
                        searchMatch = resCuisine.includes(search) || resName.includes(search);
                    }

                    if (categoryMatch && searchMatch) {
                        resLink.style.display = "block";
                    } else {
                        resLink.style.display = "none";
                    }
                });
            }

            cravingCards.forEach(card => {
                card.addEventListener("click", function() {
                    cravingCards.forEach(c => {
                        c.classList.remove("active-filter");
                        c.style.background = "#ffffff";
                        c.style.border = "1px solid rgba(66, 52, 30, 0.08)";
                        const span = c.querySelector("span");
                        if (span) span.style.color = "#42341E";
                    });

                    this.classList.add("active-filter");
                    this.style.background = "#F5E8D8";
                    this.style.border = "2px solid #CB4F1B";
                    const span = this.querySelector("span");
                    if (span) span.style.color = "#CB4F1B";

                    const filterCategory = this.getAttribute("data-cuisine");
                    filterRestaurantsByCuisine(filterCategory, searchInput ? searchInput.value : "");
                });
            });

            if (searchInput) {
                searchInput.addEventListener("input", function() {
                    const activeCard = document.querySelector(".craving-card.active-filter");
                    const filterCategory = activeCard ? activeCard.getAttribute("data-cuisine") : "all";
                    filterRestaurantsByCuisine(filterCategory, this.value);
                });
            }
        });
    </script>

</body>
</html>
