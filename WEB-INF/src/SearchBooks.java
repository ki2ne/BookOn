import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchBooks extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("Windows-31J");
		response.setCharacterEncoding("Windows-31J");

		ArrayList<LargeClassification> list = LargeClassification.getInfos();
		request.setAttribute("list", list);
		
		ArrayList<MiddleClassification> list2 = MiddleClassification.getInfos(request.getParameter("large_id"));
		request.setAttribute("list2", list2);
		
		ArrayList<SmallClassification> list3 = SmallClassification.getInfos(request.getParameter("large_id"), request.getParameter("middle_id"));
		request.setAttribute("list3", list3);
		
		ArrayList<Publisher> list4 = Publisher.getInfos();
		request.setAttribute("list4", list4);
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(request, response);
	}

}
