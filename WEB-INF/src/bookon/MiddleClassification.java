package bookon;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class MiddleClassification implements Serializable {

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

	public static ArrayList<MiddleClassification> getInfos(String large_id) {

		ArrayList<MiddleClassification> list = new ArrayList<MiddleClassification>();
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
			String middleQuery = "SELECT DISTINCT middle_id, middle FROM group_master WHERE large_id = ";
			if(large_id != null)
            {
              middleQuery += large_id;
            }
            else
            {
              middleQuery += "1";
            }
			rs = stmt.executeQuery(middleQuery);
			while (rs.next()) {
				MiddleClassification classification = new MiddleClassification();
				classification.setId(rs.getString("middle_id"));
				classification.setClassification(rs.getString("middle"));
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
