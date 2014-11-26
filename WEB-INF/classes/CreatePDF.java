import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfWriter;

public class CreatePDF extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		Connection db = null;
		PreparedStatement ps =null;
		ResultSet rs = null;
		String query = (String)session.getAttribute("search_query");
		try {
			Document doc = new Document(PageSize.A4.rotate(), 50,20,50,20);
			PdfWriter writer = PdfWriter.getInstance(doc, response.getOutputStream());
			doc.open();
			Font fTitle = new Font(BaseFont.createFont("HeiseiKakuGo-W5","UniJIS-UCS2-H",
				BaseFont.NOT_EMBEDDED),11,Font.BOLD);
			Font fData = new Font(BaseFont.createFont("HeiseiKakuGo-W5","UniJIS-UCS2-H",
				BaseFont.NOT_EMBEDDED),10,Font.NORMAL);
			PdfPTable tbl = new PdfPTable(8);
			int[] ws = {10, 20, 20, 10, 10, 10, 10, 10};
			tbl.setWidths(ws);
			String[] headers = {"#", "書籍名", "著者", "出版社", "発行年", "ISBN", "価格", "貸出状況"};
			for(int i = 0; i < headers.length; i++) {
				PdfPCell c = new PdfPCell(new Phrase(headers[i],fTitle));	
				c.setHorizontalAlignment(PdfPTable.ALIGN_CENTER);
				tbl.addCell(c);
			}
			tbl.setHeaderRows(1);
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			ps = db.prepareStatement(query);
			rs = ps.executeQuery();
			ResultSetMetaData meta = rs.getMetaData();
			while(rs.next()){
				for(int i = 1; i <= meta.getColumnCount(); i++) {
					PdfPCell c = new PdfPCell(new Phrase(rs.getString(i),fData));
					tbl.addCell(c);
				}
			}
			doc.add(tbl);
			doc.close();
		} catch (Exception e) {
			throw new ServletException(e);
		} finally {
			try {
				if(rs != null) {rs.close();}
				if(ps != null) {ps.close();}
				if(db != null) {db.close();}
			} catch(Exception e) {}
		}
	}
}
