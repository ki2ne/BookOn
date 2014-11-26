<%@ page contentType="text/html; charset=utf-8"
         import="java.sql.*,java.text.*" %>
<table border="1">
<tr>
  <th>NAME</th><th>AUTHOR</th><th>PUB</th>
  <th>PRICE</th><th>PUBDATE</th>
</tr>
<%
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection db=DriverManager.getConnection("jdbc:sqlserver://192.168.10.122:1433;databaseName=Library_DB;integratedSecurity=false;user=sa;password=P@ssw0rd;");
db.setReadOnly(true);
Statement objSql=db.createStatement();
ResultSet rs=objSql.executeQuery("SELECT bk_name, writer, pub_id, price, pub_date FROM books_data");
while(rs.next()){
%>
  <tr>
    <td><%=rs.getString("bk_name")%></td>
    <td><%=rs.getString("writer")%></td>
    <td><%=rs.getString("pub_id")%></td>
    <td><%=rs.getInt("price")%></td>
    <td><%=rs.getDate("pub_date")%></td>
  </tr>
<%
}
rs.close();
objSql.close();
db.close();
%>
</table>