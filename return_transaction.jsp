<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*, javax.naming.*, javax.sql.*"
    pageEncoding="utf-8"%>
<%
	String[] bk_id = request.getParameterValues("bk_id");
    if(bk_id != null) {
        String id = (String)session.getAttribute("id");
    	Context context = new InitialContext();
        DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
        Connection db = ds.getConnection();
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