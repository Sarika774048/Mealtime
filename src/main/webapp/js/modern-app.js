/**
 * Mealtime — Clean, Fast & Responsive Web UX JavaScript Engine
 * Provides instant button feedback, smooth scroll reveals, and toast notifications.
 */

document.addEventListener("DOMContentLoaded", function () {
    console.log("🚀 Mealtime Web UX Engine Loaded.");

    // Initialize Toast Container
    initToastContainer();

    // Initialize Instant Loading Feedback on Checkout Form
    initCheckoutLoading();
});

/**
 * Instant loading feedback when clicking place order
 */
function initCheckoutLoading() {
    const checkoutForm = document.querySelector('form[action="OrderServlet"]');
    if (checkoutForm) {
        checkoutForm.addEventListener("submit", function () {
            const submitBtn = checkoutForm.querySelector('.place-order-btn, button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.style.opacity = "0.85";
                submitBtn.style.cursor = "wait";
                submitBtn.innerHTML = `<span>Processing Order...</span>`;
            }
        });
    }
}

/**
 * Floating Toast Notification Engine
 */
function initToastContainer() {
    if (!document.getElementById("toastContainer")) {
        const container = document.createElement("div");
        container.id = "toastContainer";
        document.body.appendChild(container);
    }
}

window.showToast = function (message, type = "info") {
    const container = document.getElementById("toastContainer") || document.body;

    const toast = document.createElement("div");
    toast.className = `toast-notification ${type}`;

    let icon = "✨";
    if (type === "success") icon = "✅";
    if (type === "warning") icon = "⚠️";

    toast.innerHTML = `<span class="toast-icon">${icon}</span><span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add("hide");
        setTimeout(() => toast.remove(), 300);
    }, 3200);
};
