<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*, javax.naming.*, javax.sql.*"
    pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("Windows-31J");
    response.setCharacterEncoding("Windows-31J");
	String register_id = request.getParameter("register_id");
    String register_last_name = request.getParameter("register_last_name");
    String register_first_name = request.getParameter("register_first_name");
    String register_email = request.getParameter("register_email");
    String register_password = request.getParameter("register_password");
	String query = "INSERT INTO user_data (id, email, password, last_name, first_name) VALUES ('"
        + register_id + "', '"
        + register_email + "', HASHBYTES('SHA2_256', '"
        + register_password + "'), '"
        + register_last_name + "', '"
        + register_first_name + "')";
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