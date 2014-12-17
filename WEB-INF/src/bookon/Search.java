package bookon;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Search extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");
		
		HttpSession session = request.getSession(true);
		
		System.out.println("Book On -> Search page -> Start");
		Runtime runtime = Runtime.getRuntime();
		System.out.println("TotalMemory : " + (runtime.totalMemory() / 1024 / 1024) + "MB");
		System.out.println("MemoryUsage : " + ((runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024) + "MB");

		long startTime = System.currentTimeMillis();
		
		Object login = session.getAttribute("login");
		Object id = session.getAttribute("id");
		
		String large_id = request.getParameter("large_id");
		String middle_id = request.getParameter("middle_id");
		String small_id = request.getParameter("small_id");
		String enable_pub_name = request.getParameter("enable_pub_name");
		String pub_name = request.getParameter("pub_name");
		String name = request.getParameter("name");
		String writer = request.getParameter("writer");
		String isbn = request.getParameter("isbn");
		String below_price = request.getParameter("below_price");
		String above_price = request.getParameter("above_price");
		String page = request.getParameter("page");

		ArrayList<LargeClassification> list = LargeClassification.getInfos();
		request.setAttribute("list", list);

		ArrayList<MiddleClassification> list2 = MiddleClassification
				.getInfos(large_id);
		request.setAttribute("list2", list2);

		ArrayList<SmallClassification> list3 = SmallClassification.getInfos(
				large_id, middle_id);
		request.setAttribute("list3", list3);

		ArrayList<Publisher> list4 = Publisher.getInfos();
		request.setAttribute("list4", list4);

		ArrayList<Result> list5 = Result.getInfos(large_id, middle_id,
				small_id, enable_pub_name, pub_name, name, writer, isbn,
				below_price, above_price, page);
		request.setAttribute("list5", list5);
		
		String numberOfRows = "0";
		if(list5.size() != 0) {numberOfRows = list5.get(0).getNumberOfRows();}
		Pagination pagination = Pagination.getInfos(numberOfRows, page);
		request.setAttribute("pagination", pagination);
		
		ArrayList<Circulation> list6 = Circulation.getInfos(login, id);
		request.setAttribute("list6", list6);
		
		long endTime = System.currentTimeMillis();
		
		System.out.println("RunTime : " + (endTime - startTime) + "ms");
		
		System.out.println("Session ID : " + session.getId());
		if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")) {
			System.out.println("UserName :" + session.getAttribute("last_name") + " " + session.getAttribute("first_name"));
		}
		
		this.getServletContext().getRequestDispatcher("/index.jsp")
				.forward(request, response);
	}

}
