package bookon;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class NumberOfBooksByClassification implements Serializable {

	private String classification;
	private int number;
	
	public String getClassification() {
		return classification;
	}
	public void setClassification(String classification) {
		this.classification = classification;
	}
	public int getNumber() {
		return number;
	}
	public void setNumber(int number) {
		this.number = number;
	}
	
	public static ArrayList<NumberOfBooksByClassification> getInfos() {
		
		final class Group {
			String id;
			String classification;
			
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
		}
		
		ArrayList<NumberOfBooksByClassification> list = new ArrayList<NumberOfBooksByClassification>();
		ArrayList<Group> groupList = new ArrayList<Group>();
		String query;
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
			rs = stmt.executeQuery("SELECT DISTINCT large_id, large FROM group_master");
			while (rs.next()) {
				Group group = new Group();
				group.setId(rs.getString("large_id"));
				group.setClassification(rs.getString("large"));
				groupList.add(group);
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
			} catch (Exception e) {
			}
		}
		
		query  = "SELECT COUNT(*) AS count FROM books_data INNER JOIN "
				+ "(SELECT DISTINCT large_id FROM group_master) AS a "
				+ "ON SUBSTRING(books_data.bk_id, 1, 1) = a.large_id "
				+ "GROUP BY a.large_id ";
		
		try {
			stmt = db.createStatement();
			rs = stmt.executeQuery(query);
			int i = 0;

			while (rs.next()) {
				NumberOfBooksByClassification chartData = new NumberOfBooksByClassification();
				chartData.setClassification(groupList.get(i).classification);
				chartData.setNumber(Integer.parseInt(rs.getString("count")));
				list.add(chartData);
				i++;
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
