import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class SmallClassification implements Serializable {

	private String id;
	private String classification;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getClassification() {
		return classification;
	}

	public void setClassification(String classification) {
		this.classification = classification;
	}

	public static ArrayList<SmallClassification> getInfos(String large_id, String middle_id) {

		ArrayList<SmallClassification> list = new ArrayList<SmallClassification>();
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
			String smallQuery = "SELECT DISTINCT small_id, small FROM group_master WHERE large_id = ";
			if(large_id != null)
            {
              smallQuery += large_id;
            }
            else
            {
              smallQuery += "1";
            }
            if(middle_id != null)
            {
              smallQuery += (" AND middle_id = " + middle_id);
            }
            else
            {
              smallQuery += " AND middle_id = 1";
            }
			rs = stmt
					.executeQuery(smallQuery);
			while (rs.next()) {
				SmallClassification classification = new SmallClassification();
				classification.setId(rs.getString("small_id"));
				classification.setClassification(rs.getString("small"));
				list.add(classification);
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
