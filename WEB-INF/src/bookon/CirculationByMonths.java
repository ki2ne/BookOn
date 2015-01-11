package bookon;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class CirculationByMonths implements Serializable {

	private int month;
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
	
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
	public static ArrayList<CirculationByMonths> getInfos() {
		
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
		
		ArrayList<CirculationByMonths> list = new ArrayList<CirculationByMonths>();
		ArrayList<Group> groupList = new ArrayList<Group>();
		String query;
		DataSource ds = null;
		Connection db = null;
		Statement stmt = null;
		ResultSet rs = null;
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		if(month > 3) {
			year = year + 1;
		}
		
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

		for(int i=1; i<=12; i++) {
			if(i == 4) {
				if(month > 3) {
					year++;
				}else {
					year--;
				}
			}
			String iMonth;
			String iNextMonth;
			if(i < 10) {
				iMonth = '0' + String.valueOf(i);
			} else {
				iMonth = String.valueOf(i);
			}
			if((i + 1) < 10) {
				iNextMonth = '0' + String.valueOf(i + 1);
			} else {
				iNextMonth = String.valueOf(i + 1);
			}
			query  = "select * from ";
			for(Group item : groupList) {
				query += "(SELECT COUNT(*) AS " + item.classification + " FROM item_state WHERE bk_id LIKE '" + item.id + "%' ";
				query += "AND lend_date >= '" + year + "-" + iMonth + "-01' ";
				if(i == 12) {
					query += "AND lend_date < '" + (year + 1) + "-01-01' ";
				} else {
					query += "AND lend_date < '" + year + "-" + iNextMonth + "-01' ";
				}
				query += ") AS " + item.classification + ", ";
			}
			
			query = query.substring(0, query.length() - 2);

			try {
				stmt = db.createStatement();
				rs = stmt.executeQuery(query);
	
				if (rs.next()) {
					for(Group item : groupList) {
						CirculationByMonths chartData = new CirculationByMonths();
						chartData.setMonth(i);
						chartData.setClassification(item.classification);
						chartData.setNumber(Integer.parseInt(rs.getString(item.classification)));
						list.add(chartData);
					}
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
		}
		if (db != null) {
			try {
				db.close();
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}
		}
		return list;
	}
}
