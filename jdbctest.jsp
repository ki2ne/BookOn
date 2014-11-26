<%@ page contentType="text/html; charset=utf-8"
         import="java.sql.*,java.text.*, javax.naming.*, javax.sql.*" %>
<table border="1">
<tr>
  <th>NAME</th><th>AUTHOR</th><th>PUB</th>
  <th>PRICE</th><th>PUBDATE</th>
</tr>
<%
Context context = new InitialContext();
DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
Connection db = ds.getConnection();
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