<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mealtime.model.Restaurant" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mealtime | Food Delivered Fast</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">

    <!-- Google font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Navigation bar -->
    <header class="navbar">
        <a href="#" class="logo">
            <span class="logo-icon">🍽</span>
            Meal<span>time</span>
        </a>

        <nav class="nav-links">
            <a href="#home" class="active">Home</a>
            <a href="#restaurants">Restaurants</a>
            <a href="#offers">Offers</a>
            <a href="#about">About Us</a>
        </nav>

        <div class="nav-actions">
            <a href="#" class="login-link">Log in</a>
            <a href="#" class="signup-btn">Sign up</a>
        </div>
    </header>

    <main>
        <!-- Hero section with playing video -->
        <section class="hero" id="home">
            <video class="hero-video" autoplay muted loop playsinline preload="auto"
                   poster="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1920&q=85"
                   aria-label="Food delivery video background">
                <source src="https://assets.mixkit.co/videos/preview/mixkit-chef-preparing-a-fresh-vegetable-salad-31906-large.mp4" type="video/mp4">
                Your browser does not support video.
            </video>

            <div class="video-overlay"></div>

            <div class="hero-content">
                <p class="hero-tag">FAST • FRESH • DELICIOUS</p>
                <h1>Good food, <span>delivered happy.</span></h1>
                <p class="hero-description">Discover restaurants you love and get your favourite meals delivered right to your doorstep.</p>

                <div class="search-box">
                    <span class="location-icon">⌖</span>
                    <input type="text" placeholder="Enter your delivery location">
                    <button type="button">Find food</button>
                </div>
            </div>

            <div class="scroll-down">
                <span>Scroll to explore</span>
                <div class="scroll-line"></div>
            </div>
        </section>

        <!-- What are you craving section -->
        <section class="cravings-section">
            <div class="section-heading">
                <div>
                    <p class="section-tag">WHAT'S ON YOUR MIND?</p>
                    <h2>In the spotlight: Food cravings</h2>
                </div>
            </div>
            <div class="cravings-carousel">
                <div class="craving-card active-filter" data-cuisine="all">
                    <div class="craving-video-wrapper">
                        <div class="craving-emoji-fallback">🍽️</div>
                        <video class="craving-video" autoplay muted loop playsinline>
                            <source src="https://assets.mixkit.co/videos/preview/mixkit-chef-preparing-a-fresh-vegetable-salad-31906-large.mp4" type="video/mp4">
                        </video>
                        <div class="craving-overlay"></div>
                    </div>
                    <span>🍽️ All Cravings</span>
                </div>
                <div class="craving-card" data-cuisine="Italian,Pizza">
                    <div class="craving-video-wrapper">
                        <div class="craving-emoji-fallback">🍕</div>
                        <video class="craving-video" autoplay muted loop playsinline>
                            <source src="https://assets.mixkit.co/videos/preview/mixkit-holding-a-slice-of-hot-pizza-with-melted-cheese-31901-large.mp4" type="video/mp4">
                        </video>
                        <div class="craving-overlay"></div>
                    </div>
                    <span>🍕 Hot Pizza</span>
                </div>
                <div class="craving-card" data-cuisine="Fast Food,Chicken,Biryani,Punjabi">
                    <div class="craving-video-wrapper">
                        <div class="craving-emoji-fallback">🍗</div>
                        <video class="craving-video" autoplay muted loop playsinline>
                            <source src="https://assets.mixkit.co/videos/preview/mixkit-fried-chicken-wings-on-a-plate-31903-large.mp4" type="video/mp4">
                        </video>
                        <div class="craving-overlay"></div>
                    </div>
                    <span>🍗 Crispy Chicken</span>
                </div>
                <div class="craving-card" data-cuisine="Chinese">
                    <div class="craving-video-wrapper">
                        <div class="craving-emoji-fallback">🍜</div>
                        <video class="craving-video" autoplay muted loop playsinline>
                            <source src="https://assets.mixkit.co/videos/preview/mixkit-stir-frying-vegetables-in-a-wok-31912-large.mp4" type="video/mp4">
                        </video>
                        <div class="craving-overlay"></div>
                    </div>
                    <span>🍜 Chinese Wok</span>
                </div>
                <div class="craving-card" data-cuisine="Desserts,Bakery">
                    <div class="craving-video-wrapper">
                        <div class="craving-emoji-fallback">🍰</div>
                        <video class="craving-video" autoplay muted loop playsinline>
                            <source src="https://assets.mixkit.co/videos/preview/mixkit-pouring-chocolate-sauce-on-a-cake-31907-large.mp4" type="video/mp4">
                        </video>
                        <div class="craving-overlay"></div>
                    </div>
                    <span>🍰 Sweet Tooth</span>
                </div>
            </div>
        </section>

        <!-- Restaurant section -->
        <section class="restaurants-section" id="restaurants">
            <div class="section-heading">
                <div>
                    <p class="section-tag">CURATED FOR YOU</p>
                    <h2>Popular restaurants near you</h2>
                </div>
                <a href="#" class="view-all">View all restaurants →</a>
            </div>

           
           
           <
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
                <a href="menu?restaurantId=<%= res.getRestaurantid()%>">
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
                                        <span class="dot">•</span>
                                        <span><%= res.getEta() %></span>
                                    </div>
                                </div>
                            </article>
                               </a>
                <% 
                        } 
                    } else { 
                %>
                    <p class="no-data">No restaurants found. Please check your data pipeline.</p>
                <% 
                    } 
                %>
            </div>
           
        
           
           
        </section>

        <!-- Small feature area -->
        <section class="features" id="offers">
            <div class="feature">
                <span class="feature-icon">⚡</span>
                <div>
                    <h3>Quick delivery</h3>
                    <p>Fresh food at your doorstep.</p>
                </div>
            </div>

            <div class="feature">
                <span class="feature-icon">🍲</span>
                <div>
                    <h3>Many choices</h3>
                    <p>Discover food for every mood.</p>
                </div>
            </div>

            <div class="feature">
                <span class="feature-icon">✓</span>
                <div>
                    <h3>Easy ordering</h3>
                    <p>Order your favourites in seconds.</p>
                </div>
            </div>
        </section>
    </main>

    <footer id="about">
        <a href="#" class="logo footer-logo">
            <span class="logo-icon">🍽</span>
            Meal<span>time</span>
        </a>
        <p>© 2026 Mealtime. Made for food lovers.</p>
    </footer>

    <script>
        const heroVideo = document.querySelector(".hero-video");
        if (heroVideo) {
            heroVideo.muted = true;
            heroVideo.play().then(() => {
                // Smoothly fade in the video once it starts playing
                heroVideo.style.opacity = "1";
            }).catch((err) => {
                console.log("Video autoplay blocked or failed:", err);
                // Keep video hidden so the background image fallback is displayed
                heroVideo.style.display = "none";
            });
        }

        // Dynamic Cuisine Filtering
        const cravingCards = document.querySelectorAll('.craving-card');
        const restaurantCards = document.querySelectorAll('.restaurant-card');

        cravingCards.forEach(card => {
            card.addEventListener('click', () => {
                // Toggle active filter class
                cravingCards.forEach(c => c.classList.remove('active-filter'));
                card.classList.add('active-filter');

                const cuisineFilter = card.getAttribute('data-cuisine').toLowerCase();

                if (cuisineFilter === 'all') {
                    // Show all cards
                    restaurantCards.forEach(r => {
                        r.style.opacity = '0';
                        r.style.display = 'block';
                        setTimeout(() => {
                            r.style.transition = 'opacity 0.3s ease';
                            r.style.opacity = '1';
                        }, 50);
                    });
                } else {
                    const cuisines = cuisineFilter.split(',');
                    restaurantCards.forEach(r => {
                        const rCuisine = r.querySelector('.cuisine').textContent.toLowerCase();
                        const matches = cuisines.some(c => rCuisine.includes(c));
                        
                        if (matches) {
                            r.style.opacity = '0';
                            r.style.display = 'block';
                            setTimeout(() => {
                                r.style.transition = 'opacity 0.3s ease';
                                r.style.opacity = '1';
                            }, 50);
                        } else {
                            r.style.display = 'none';
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
