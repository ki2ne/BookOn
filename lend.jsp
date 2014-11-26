<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*"
    pageEncoding="utf-8"%>
<%
    String ip_address = "localhost";
    String db_name = "Library_DB";
    String user = "sa";
    String password = "P@ssw0rd";
	String bk_id = request.getParameter("bk_id");
    String id = (String)session.getAttribute("id");
	String query = "INSERT INTO item_state (id, bk_id, lend_date, estimate_return_date) VALUES ('" + id + "', '" + bk_id + "', GETDATE(), DATEADD(day, 13, GETDATE()))";
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    Connection db7=DriverManager.getConnection("jdbc:sqlserver://" + ip_address + ":1433;databaseName=" + db_name + ";integratedSecurity=false;user=" + user + ";password=" + password + ";");
    db7.setReadOnly(true);
    Statement objSql7=db7.createStatement();
    int num=objSql7.executeUpdate(query);
    objSql7.close();
    db7.close();
    response.sendRedirect("./index.jsp");
%>