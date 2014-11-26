<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*"
    pageEncoding="utf-8"%>
<%
    String ip_address = "localhost";
    String db_name = "Library_DB";
    String user = "sa";
    String password = "P@ssw0rd";
	String[] bk_id = request.getParameterValues("bk_id");
    if(bk_id != null) {
        String id = (String)session.getAttribute("id");
    	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection db=DriverManager.getConnection("jdbc:sqlserver://" + ip_address + ":1433;databaseName=" + db_name + ";integratedSecurity=false;user=" + user + ";password=" + password + ";");
        db.setReadOnly(true);
            for(String bid: bk_id){
            Statement objSql=db.createStatement();
            String query = "UPDATE item_state SET return_date = GETDATE()";
            query += " WHERE bk_id = '" + bid + "'";
            int num=objSql.executeUpdate(query);
            objSql.close();
        }
        db.close();
    }
    response.sendRedirect("./return.jsp");
%>