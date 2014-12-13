package bookon;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class CreatePDF extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
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
		
		ArrayList<Result> list = Result.getInfos(large_id, middle_id,
				small_id, enable_pub_name, pub_name, name, writer, isbn,
				below_price, above_price);
		
		try {
			Document doc = new Document(PageSize.A4.rotate(), 50,20,50,20);
			PdfWriter pdfWriter = PdfWriter.getInstance(doc, response.getOutputStream());
			doc.open();
			Font fTitle = new Font(BaseFont.createFont("HeiseiKakuGo-W5","UniJIS-UCS2-H",
				BaseFont.NOT_EMBEDDED),11,Font.BOLD);
			Font fData = new Font(BaseFont.createFont("HeiseiKakuGo-W5","UniJIS-UCS2-H",
				BaseFont.NOT_EMBEDDED),10,Font.NORMAL);
			PdfPTable tbl = new PdfPTable(7);
			int[] ws = {6, 29, 20, 15, 10, 13, 7};
			tbl.setWidths(ws);
			String[] headers = {"#", "書籍名", "著者", "出版社", "発行年", "ISBN", "価格"};
			for(int i = 0; i < headers.length; i++) {
				PdfPCell c = new PdfPCell(new Phrase(headers[i],fTitle));	
				c.setHorizontalAlignment(PdfPTable.ALIGN_CENTER);
				tbl.addCell(c);
			}
			tbl.setHeaderRows(1);
			for(Result result : list)
			{
				PdfPCell c = new PdfPCell(new Phrase(result.getId(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getName(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getAuthor(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getPublisher(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getPublicationDate(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getIsbn(), fData));
				tbl.addCell(c);
				c = new PdfPCell(new Phrase(result.getPrice(), fData));
				tbl.addCell(c);
				System.out.println(result.getId());
			}
			doc.add(tbl);
			doc.close();
		} catch (Exception e) {
			throw new ServletException(e);
		} finally {
		}
	}
}
