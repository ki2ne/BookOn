import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class Publisher implements Serializable {
	

	private String name;
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static ArrayList<Publisher> getInfos() {

		ArrayList<Publisher> list = new ArrayList<Publisher>();
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
			rs = stmt
					.executeQuery("SELECT DISTINCT pub_name FROM books_data, pub_master WHERE books_data.pub_id = pub_master.pub_id");
			while (rs.next()) {
				Publisher publisher = new Publisher();
				publisher.setName(rs.getString("pub_name"));
				list.add(publisher);
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
