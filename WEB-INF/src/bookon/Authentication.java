package bookon;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

public class Authentication extends HttpServlet {

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("Windows-31J");
	    response.setCharacterEncoding("Windows-31J");
	    
		HttpSession session = request.getSession(false);
		Connection db = null;
		Statement objSql = null;
		ResultSet rs = null;
		String email = request.getParameter("email");
		email = email == null ? "" : email;
		String pass = request.getParameter("pass");
		pass = pass == null ? "" : pass;
		
		try {

			Context context = new InitialContext();
			DataSource ds = (DataSource) context
					.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			/*
			 * String query =
			 * "SELECT id, email, password FROM user_data WHERE email = ? AND password = ?"
			 * ; PreparedStatement pstmt = db.prepareStatement(query);
			 * pstmt.setString(1, email); pstmt.setString(2, securePass);
			 * ResultSet rs = pstmt.executeQuery();
			 */
			String query = "SELECT id, email, password, last_name, first_name FROM user_data WHERE email = '"
					+ email
					+ "' AND password = HASHBYTES('SHA2_256', '"
					+ pass
					+ "')";
			objSql = db.createStatement();
			rs = objSql.executeQuery(query);

			if (rs.next()) {
				session.setMaxInactiveInterval(60 * 10);
				session.setAttribute("login", "true");
				session.setAttribute("id", rs.getString("id"));
				session.setAttribute("email", email);
				session.setAttribute("last_name", rs.getString("last_name"));
				session.setAttribute("first_name", rs.getString("first_name"));
			} else {
				session.setAttribute("login", "false");
			}
		} catch (Exception e) {
			throw new ServletException(e);
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (objSql != null) {
					objSql.close();
				}
				if (db != null) {
					db.close();
				}
				response.sendRedirect("Search");
			} catch (Exception e) {
			}
		}
	}
}
