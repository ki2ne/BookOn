<%@ page language="java" contentType="text/html; charset=utf-8"
	import="java.sql.*,java.text.*"
    pageEncoding="utf-8"%>

<%
// 内容：セッションを終了する
 
// セッションの終了(セッション変数の解放)
session.invalidate();
response.sendRedirect("./index.jsp");
%>