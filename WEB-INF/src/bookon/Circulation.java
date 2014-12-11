package bookon;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;


public class Circulation implements Serializable {
	
	private String circulation;
	private String overdue;

	public String getCirculation() {
		return circulation;
	}

	public void setCirculation(String circulation) {
		this.circulation = circulation;
	}

	public String getOverdue() {
		return overdue;
	}

	public void setOverdue(String overdue) {
		this.overdue = overdue;
	}

	public static ArrayList<Circulation> getInfos(Object login, Object id) {

		ArrayList<Circulation> list = new ArrayList<Circulation>();
		DataSource ds = null;
		Connection db = null;
		Statement stmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;

		try {
			Context context = new InitialContext();
			ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			stmt = db.createStatement();
			String query = "SELECT COUNT(*) AS number FROM item_state WHERE return_date IS NULL";
			if((login != null) && login.equals("true"))
            {
              query += " AND id = '" + id + "'";
            }
			rs = stmt.executeQuery(query);
			Circulation circulation = new Circulation();
			while(rs.next()) {
				circulation.setCirculation(rs.getString("number"));
			}
			query = "SELECT COUNT(*) AS number FROM item_state WHERE return_date IS NULL AND estimate_return_date < DATEDIFF(day, 1, GETDATE())";
			if((login != null) && login.equals("true"))
            {
              query += " AND id = '" + id + "'";
            }
			rs2 = stmt.executeQuery(query);
			while(rs2.next()) {
				circulation.setOverdue(rs2.getString("number"));
			}
			list.add(circulation);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (rs2 != null) {
					rs2.close();
				}
				if (db != null) {
					db.close();
				}
			} catch (Exception e) {
			}
		}
		return list;
	}
}
