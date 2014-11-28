import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

public class RegisterTransaction extends HttpServlet {
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");

		Connection db = null;
		Statement objSql = null;
		String register_id = request.getParameter("register_id");
		String register_last_name = request.getParameter("register_last_name");
		String register_first_name = request
				.getParameter("register_first_name");
		String register_email = request.getParameter("register_email");
		String register_password = request.getParameter("register_password");
		String query = "INSERT INTO user_data (id, email, password, last_name, first_name) VALUES ('"
				+ register_id
				+ "', '"
				+ register_email
				+ "', HASHBYTES('SHA2_256', '"
				+ register_password
				+ "'), '"
				+ register_last_name + "', '" + register_first_name + "')";
		
		try {
			Context context = new InitialContext();
			DataSource ds = (DataSource) context
					.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			objSql = db.createStatement();
			int num = objSql.executeUpdate(query);
		} catch (Exception e) {
			throw new ServletException(e);
		} finally {
			try {
				if (objSql != null) {
					objSql.close();
				}
				if (db != null) {
					db.close();
				}
				response.sendRedirect("./index.jsp");
			} catch (Exception e) {
			}
		}

	}

}
