package bookon;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class OverDue implements Serializable {
	
	private String id;
	private String name;
	private String publisher;
	private String lendingDate;
	private String dueDate;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getLendingDate() {
		return lendingDate;
	}

	public void setLendingDate(String lendingDate) {
		this.lendingDate = lendingDate;
	}

	public String getDueDate() {
		return dueDate;
	}

	public void setDueDate(String dueDate) {
		this.dueDate = dueDate;
	}

	public static ArrayList<OverDue> getInfos(Object id) {

		ArrayList<OverDue> list = new ArrayList<OverDue>();
		DataSource ds = null;
		Connection db = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			Context context = new InitialContext();
			ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			stmt = db.createStatement();
			String query = 		"SELECT "
					+ "  item_state.bk_id "
					+ "  , bk_name "
					+ "  , pub_name "
					+ "  , CONVERT(VARCHAR, lend_date, 111) AS lend_date "
					+ "  , CONVERT(VARCHAR, estimate_return_date, 111) AS estimate_return_date "
					+ "FROM "
					+ "  item_state "
					+ "  INNER JOIN ( "
					+ "    SELECT "
					+ "      bk_id "
					+ "      , bk_name "
					+ "      , pub_name "
					+ "    FROM "
					+ "      books_data bd "
					+ "      INNER JOIN pub_master pm "
					+ "        ON bd.pub_id = pm.pub_id "
					+ "  ) AS books_and_pub_data "
					+ "    ON item_state.bk_id = books_and_pub_data.bk_id "
					+ "WHERE "
					+ "  return_date IS NULL AND estimate_return_date < DATEDIFF(day, 1, GETDATE()) ";
			if(id != null)
            {
              query += " AND id = '" + id + "'";
            }
			rs = stmt.executeQuery(query);
			while (rs.next()) {
				OverDue overDue = new OverDue();
				overDue.setId(rs.getString("bk_id"));
				overDue.setName(rs.getString("bk_name"));
				overDue.setPublisher(rs.getString("pub_name"));
				overDue.setLendingDate(rs.getString("lend_date"));
				overDue.setDueDate(rs.getString("estimate_return_date"));
				list.add(overDue);
			}
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
				if (db != null) {
					db.close();
				}
			} catch (Exception e) {
			}
		}
		return list;
	}
}
