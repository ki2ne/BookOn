<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*, javax.naming.*, javax.sql.*"
    pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("Windows-31J");
    response.setCharacterEncoding("Windows-31J");
	String bk_id = request.getParameter("bk_id");
    String id = (String)session.getAttribute("id");
	String query = "INSERT INTO item_state (id, bk_id, lend_date, estimate_return_date) VALUES ('" + id + "', '" + bk_id + "', GETDATE(), DATEADD(day, 13, GETDATE()))";
	Context context = new InitialContext();
    DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
    Connection db = ds.getConnection();
    db.setReadOnly(true);
    Statement objSql=db.createStatement();
    int num=objSql.executeUpdate(query);
    objSql.close();
    db.close();
    response.sendRedirect("./index.jsp");
%>