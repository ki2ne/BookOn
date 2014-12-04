import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Large extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		ArrayList<LargeClassification> list = LargeClassification.getInfos();
		request.setAttribute("list", list);
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(request, response);
	}

}
