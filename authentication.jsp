<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*, javax.naming.*, javax.sql.*"
    pageEncoding="utf-8"%>

<%
request.setCharacterEncoding("utf-8");
String email = request.getParameter("email");
email = email == null ? "" : email;
String pass = request.getParameter("pass");
pass = pass == null ? "" : pass;
String securePass = "HASHBYTES('SHA2_256', '" + pass + "')";

Context context = new InitialContext();
DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
Connection db = ds.getConnection();
db.setReadOnly(true);
/*
String query = "SELECT id, email, password FROM user_data WHERE email = ? AND password = ?"; 
PreparedStatement pstmt = db.prepareStatement(query);
pstmt.setString(1, email);
pstmt.setString(2, securePass);
ResultSet rs = pstmt.executeQuery();
*/
String query = "SELECT id, email, password, last_name, first_name FROM user_data WHERE email = '" + email + "' AND password = HASHBYTES('SHA2_256', '" + pass + "')";
Statement objSql=db.createStatement();
ResultSet rs=objSql.executeQuery(query);

if(rs.next()){
	session.setMaxInactiveInterval(60 * 10);
    session.setAttribute("login","true");
    session.setAttribute("id", rs.getString("id"));
    session.setAttribute("email", email);
    session.setAttribute("last_name", rs.getString("last_name"));
    session.setAttribute("first_name", rs.getString("first_name"));
}
else {
    session.setAttribute("login","false");
}
rs.close();
objSql.close();
db.close();
response.sendRedirect("./index.jsp");
%>