package bookon;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Return extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");
		
		HttpSession session = request.getSession(true);
		
		Object login = session.getAttribute("login");
		Object id = session.getAttribute("id");
		
		System.out.println("Book On Start");
		Runtime runtime = Runtime.getRuntime();
		System.out.println("TotalMemory : " + (runtime.totalMemory() / 1024 / 1024) + "MB");
		System.out.println("MemoryUsage : " + ((runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024) + "MB");

		long startTime = System.currentTimeMillis();
		
		ArrayList<Circulation> list = Circulation.getInfos(login, id);
		request.setAttribute("list", list);
		
		long endTime = System.currentTimeMillis();
		
		System.out.println("RunTime : " + (endTime - startTime) + "ms");
		
		System.out.println("Session ID : " + session.getId());
		if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")) {
			System.out.println("UserName :" + session.getAttribute("last_name") + " " + session.getAttribute("first_name"));
		}
		
		this.getServletContext().getRequestDispatcher("/return.jsp")
				.forward(request, response);
	}

}
