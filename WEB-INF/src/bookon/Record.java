package bookon;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

public class Record extends HttpServlet {
	
	private String id;
	private String lastName;
	private String firstName;
	private String bookName;
	private String lendDate;
	private String dueDate;
	private String returnDate;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public String getLendDate() {
		return lendDate;
	}
	public void setLendDate(String lendDate) {
		this.lendDate = lendDate;
	}
	public String getDueDate() {
		return dueDate;
	}
	public void setDueDate(String dueDate) {
		this.dueDate = dueDate;
	}
	
	public String getReturnDate() {
		return returnDate;
	}
	public void setReturnDate(String returnDate) {
		this.returnDate = returnDate;
	}
	public ArrayList<Record> getInfos() {
		ArrayList<Record> list = new ArrayList<Record>();
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
			String query = "select "
					+ "  a.id "
					+ "  , last_name "
					+ "  , first_name "
					+ "  , bk_name "
					+ "  , CONVERT(VARCHAR, lend_date, 111) as lend_date "
					+ "  , CONVERT(VARCHAR, estimate_return_date, 111) as estimate_return_date "
					+ "  , CONVERT(VARCHAR, return_date, 111) as return_date "
					+ "from "
					+ "  user_data "
					+ "  inner join ( "
					+ "    select "
					+ "      item_state.id "
					+ "      , bk_name "
					+ "      , lend_date "
					+ "      , estimate_return_date "
					+ "      , return_date "
					+ "    from "
					+ "      item_state "
					+ "      inner join books_data "
					+ "        on item_state.bk_id = books_data.bk_id "
					+ "  ) as a "
					+ "    on user_data.id = a.id "
					+ "order by "
					+ "  lend_date desc ";

			rs = stmt.executeQuery(query);
			while(rs.next()) {
				Record record = new Record();
				record.setId(rs.getString("id"));
				record.setLastName(rs.getString("last_name"));
				record.setFirstName(rs.getString("first_name"));
				record.setBookName(rs.getString("bk_name"));
				record.setLendDate(rs.getString("lend_date"));
				record.setDueDate(rs.getString("estimate_return_date"));
				record.setReturnDate(rs.getString("return_date"));
				list.add(record);
			}
		} catch(Exception e) {
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

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);
		
		System.out.println("Book On -> Record page -> Start");
		Runtime runtime = Runtime.getRuntime();
		System.out.println("TotalMemory : " + (runtime.totalMemory() / 1024 / 1024) + "MB");
		System.out.println("MemoryUsage : " + ((runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024) + "MB");

		long startTime = System.currentTimeMillis();
		
		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");
		
		ArrayList<Record> list = this.getInfos();
		request.setAttribute("list", list);
		
		long endTime = System.currentTimeMillis();
		
		System.out.println("RunTime : " + (endTime - startTime) + "ms");
		
		System.out.println("Session ID : " + session.getId());
		if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")) {
			System.out.println("UserName :" + session.getAttribute("last_name") + " " + session.getAttribute("first_name"));
		}
		
		this.getServletContext().getRequestDispatcher("/record.jsp")
		.forward(request, response);
	}
}
