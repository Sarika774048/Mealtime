package com.mealtime.servlet;

import java.io.IOException;

import com.mealtime.daoimplementation.UserDaoImple;
import com.mealtime.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/callRegisterServlet")
public class RegisterServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		String name = req.getParameter("name");
		String username= req.getParameter("username");
		String password =req.getParameter("password");
		String email = req.getParameter("email");
		String phone = req.getParameter("phone");
		String address = req.getParameter("address");
		String role = req.getParameter("role");
		
		
		if (name == null || username == null || password == null || email == null || phone == null
				|| address == null || role == null) {
			resp.sendRedirect("register.html?error=Please+complete+all+fields.");
			return;
		}

		try {
			User user = new User(name.trim(), username.trim(), password, email.trim(), phone.trim(),
					address.trim(), role, null, null);
			int res = new UserDaoImple().addUser(user);

			if (res == 1) {
				resp.sendRedirect("login.html?success=Registration+successful.+Please+log+in.");
			} else {
				resp.sendRedirect("register.html?error=Registration+failed.+The+email+or+username+may+already+exist.");
			}
		} catch (RuntimeException e) {
			getServletContext().log("Registration failed", e);
			resp.sendRedirect("register.html?error=Unable+to+register+right+now.+Please+try+again.");
		}
	}
}
