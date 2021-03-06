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

public class LendTransaction extends HttpServlet {

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("Windows-31J");
	    response.setCharacterEncoding("Windows-31J");

		HttpSession session = request.getSession(false);
		Connection db = null;
		Statement objSql = null;

		try {
			String bk_id = request.getParameter("bk_id");
			String id = (String) session.getAttribute("id");
			String query = "IF"
					+ " (SELECT COUNT(*) FROM item_state"
					+ "	WHERE bk_id = '" + bk_id + "'"
					+ "	AND estimate_return_date IS NOT NULL"
					+ "	AND return_date IS NULL) = 0"
					+ "		BEGIN"
					+ "			INSERT INTO item_state (id, bk_id, lend_date, estimate_return_date)"
					+ "			VALUES ('" + id + "', '" + bk_id + "', GETDATE(), DATEADD(day, 13, GETDATE()))"
					+ "		END";
			Context context = new InitialContext();
			DataSource ds = (DataSource) context
					.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			objSql = db.createStatement();
			int numberOfRows = objSql.executeUpdate(query);
			session.setAttribute("resultOfLendTransaction", numberOfRows);
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
				response.sendRedirect("Search");
			} catch (Exception e) {
			}
		}
	}

}
