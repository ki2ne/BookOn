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

public class User extends HttpServlet {
	
	private String id;
	private String email;
	private String lastName;
	private String firstName;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	
	public ArrayList<User> getInfos() {
		ArrayList<User> list = new ArrayList<User>();
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
			rs = stmt.executeQuery("SELECT * FROM user_data");
			while(rs.next()) {
				User user = new User();
				user.setId(rs.getString("id"));
				user.setEmail(rs.getString("email"));
				user.setLastName(rs.getString("last_name"));
				user.setFirstName(rs.getString("first_name"));
				list.add(user);
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
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);
		
		System.out.println("Book On -> User page -> Start");
		Runtime runtime = Runtime.getRuntime();
		System.out.println("TotalMemory : " + (runtime.totalMemory() / 1024 / 1024) + "MB");
		System.out.println("MemoryUsage : " + ((runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024) + "MB");

		long startTime = System.currentTimeMillis();
		
		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");
		
		ArrayList<User> list = this.getInfos();
		request.setAttribute("list", list);
		
		long endTime = System.currentTimeMillis();
		
		System.out.println("RunTime : " + (endTime - startTime) + "ms");
		
		System.out.println("Session ID : " + session.getId());
		if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")) {
			System.out.println("UserName :" + session.getAttribute("last_name") + " " + session.getAttribute("first_name"));
		}
		
		this.getServletContext().getRequestDispatcher("/user.jsp")
		.forward(request, response);
	}
}
