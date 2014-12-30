package bookon;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

public class UserTransaction extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");

		HttpSession session = request.getSession(false);
		Connection db = null;
		Statement objSql = null;
		String[] user_id = request.getParameterValues("user_id");
		
		try {
			if (user_id != null) {
				String id = (String) session.getAttribute("id");
				Context context = new InitialContext();
				DataSource ds = (DataSource) context
						.lookup("java:comp/env/jdbc/bookon");
				db = ds.getConnection();
				db.setReadOnly(true);
				for (String uid : user_id) {
					objSql = db.createStatement();
					String query = "DELETE FROM user_data";
					query += " WHERE id = '" + uid + "'";
					int num = objSql.executeUpdate(query);
					objSql.close();
				}
			}
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
				response.sendRedirect("User");
			} catch (Exception e) {
			}
		}

	}
}
