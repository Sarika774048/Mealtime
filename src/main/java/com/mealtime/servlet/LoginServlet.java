package com.mealtime.servlet;

import java.io.IOException;

import com.mealtime.daoimplementation.UserDaoImple;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/callLoginServlet")
public class LoginServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String email = req.getParameter("email");
		String password = req.getParameter("password");

		if (email == null || password == null) {
			resp.sendRedirect("login.html?error=Email+and+password+are+required.");
			return;
		}

		HttpSession session = req.getSession();
		try {
			UserDaoImple userDao = new UserDaoImple();
			int res = userDao.getUserByEmailAndPassword(email.trim(), password);
			if (res == 1) {
				session.setAttribute("email", email.trim());
				com.mealtime.model.User user = userDao.getUserByEmail(email.trim());
				if (user != null) {
					session.setAttribute("user", user);
				}

				String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
				if (redirectUrl != null && !redirectUrl.isEmpty()) {
					session.removeAttribute("redirectAfterLogin");
					resp.sendRedirect(redirectUrl);
				} else {
					resp.sendRedirect("cart.jsp");
				}
			} else {
				resp.sendRedirect("login.html?error=Invalid+email+or+password.");
			}
		} catch (RuntimeException e) {
			getServletContext().log("Login failed", e);
			resp.sendRedirect("login.html?error=Unable+to+log+in+right+now.+Please+try+again.");
		}
	}
}
