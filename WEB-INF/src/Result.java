import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Result implements Serializable {

	private String id;
	private String name;
	private String author;
	private String publisher;
	private String publicationDate;
	private String isbn;
	private String price;
	private String state;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getPublicationDate() {
		return publicationDate;
	}

	public void setPublicationDate(String publicationDate) {
		this.publicationDate = publicationDate;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public static ArrayList<Result> getInfos(String large_id, String middle_id,
			String small_id, String enable_pub_name, String pub_name,
			String name, String writer, String isbn, String below_price,
			String above_price) {

		ArrayList<Result> list = new ArrayList<Result>();
		DataSource ds = null;
		Connection db = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			Context context = new InitialContext();
			ds = (DataSource) context.lookup("java:comp/env/jdbc/bookon");
			db = ds.getConnection();
			db.setReadOnly(true);
			stmt = db.createStatement();
			String query = "SELECT DISTINCT books_data.bk_id, bk_name, writer, pub_name, pub_date, isbn_no, price, state = CASE WHEN lend_date IS NOT NULL AND return_date IS NULL THEN 'false' ELSE 'true' END FROM books_data LEFT OUTER JOIN (SELECT * FROM item_state  WHERE return_date IS NOT NULL) AS item_state ON books_data.bk_id = item_state.bk_id, pub_master WHERE pub_master.pub_id = books_data.pub_id ORDER BY books_data.bk_id";
			if ((pub_name != "") && (enable_pub_name != null)) {
				query += (" AND pub_name = '" + pub_name + "'");
			}
			if (name != null && name != "") {
				query += (" AND bk_name LIKE '%" + name + "%'");
			}
			if (writer != null && writer != "") {
				query += (" AND writer LIKE '%" + writer + "%'");
			}
			if (isbn != null && isbn != "") {
				query += (" AND isbn_no = '" + isbn + "'");
			}
			if (below_price != null && below_price != "") {
				query += (" AND price <= " + below_price);
			}
			if (above_price != null && above_price != "") {
				query += (" AND price >= " + above_price);
			}
			if (large_id != null && large_id != "") {
				query += (" AND books_data.bk_id LIKE '" + large_id + "%'");
			}
			if (middle_id != null && middle_id != "") {
				query += (" AND books_data.bk_id LIKE '_" + middle_id + "%'");
			}
			if (small_id != null && small_id != "") {
				query += (" AND books_data.bk_id LIKE '__" + small_id + "%'");
			}
			rs = stmt.executeQuery(query);
			while (rs.next()) {
				Result result = new Result();
				result.setId(rs.getString("bk_id"));
				result.setName(rs.getString("bk_name"));
				result.setAuthor(rs.getString("writer"));
				result.setPublisher(rs.getString("pub_name"));
				result.setPublicationDate(rs.getString("pub_date"));
				result.setIsbn(rs.getString("isbn_no"));
				result.setPrice(rs.getString("price"));
				result.setState(rs.getString("state"));
				list.add(result);
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
