<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date,java.sql.*,java.text.*, javax.naming.*, javax.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
  request.setCharacterEncoding("Windows-31J");
  response.setCharacterEncoding("Windows-31J");
%>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Book On</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="css/bookon.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <%
      String email = request.getParameter("email");
      String login_pass = request.getParameter("password");
      pageContext.setAttribute("today", new Date());
    %>
    <div class="navbar navbar-default" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="Search">Book On</a>
			</div>
			<div id="navbar" class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li><a href="">about</a></li>
					<li><a href="">contact</a></li>
					<li><a href=""><fmt:formatDate value="${today}" type="DATE" dateStyle="FULL" /></a></li>
					<c:if test="${sessionScope.resultOfLendTransaction != null && sessionScope.resultOfLendTransaction == -1}">
						<li><a href="">ご指定の本は既に借りられています。</a></li>
					</c:if>
				</ul>
				<c:choose>
					<c:when test="${sessionScope.login == null || sessionScope.login != 'true'}">
						<form class="navbar-form navbar-right">
							<button type="button" class="btn btn-success" data-toggle="modal" data-target="#loginModal">ログイン</button>
							<!-- Button trigger modal -->
							<button type="button" class="btn btn-success" data-toggle="modal" data-target="#registerModal">登録</button>
						</form>
					</c:when>
					<c:otherwise>
						<ul class="nav navbar-nav navbar-right">
							<li><a href="#">${fn:escapeXml(sessionScope.email)}</a></li>
							<li>
								<form class="navbar-form navbar-right" role="form" method="post" action="SignOut">
									<button type="submit" class="btn btn-success">ログアウト</button>
								</form>
							</li>
						</ul>
					</c:otherwise>
				</c:choose>
			</div>
			<!--/.navbar-collapse -->
		</div>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<form class="form-horizontal" method="POST" role="form" action="Authentication">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">ログイン</h4>
					</div>
					<div class="modal-body">
							<c:choose>
								<c:when test="${sessionScope.login != null}">
									<div class="form-group has-error has-feedback">
										<label for="email" class="col-md-4 control-label">Email</label>
										<div class="col-md-6">
										<input type="text" name='email' placeholder="Email" class="form-control">
										<span class="glyphicon glyphicon-remove form-control-feedback"></span>
										</div>
									</div>
									<div class="form-group has-error has-feedback">
										<label for="pass" class="col-md-4 control-label">Password</label>
										<div class="col-md-6">
										<input type="password" name='pass' placeholder="Password" class="form-control">
											<span class="glyphicon glyphicon-remove form-control-feedback"></span>
										</div>
									</div>
								</c:when>
								<c:otherwise>
									<div class="form-group">
										<label for="email" class="col-md-4 control-label">Email</label>
										<div class="col-md-6">
										<input type="text" name='email' placeholder="Email" class="form-control">
										</div>
									</div>
									<div class="form-group">
										<label for="pass" class="col-md-4 control-label">Password</label>
										<div class="col-md-6">
										<input type="password" name='pass' placeholder="Password" class="form-control">
										</div>
									</div>
								</c:otherwise>
							</c:choose>
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-success" name="register">ログイン</button>
						<button type="button" class="btn btn-default" data-dismiss="modal" OnClick="removeLoginAttribute()">閉じる</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<form class="form-horizontal register_form" method="POST" name="register_form" role="form" action="RegisterTransaction">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">ユーザー登録</h4>
					</div>
					<div class="modal-body">
						<div class="form-group">
							<label for="register_id" class="col-md-4 control-label">ID</label>
							<div class="col-md-6">
								<input type="text" class="form-control" name="register_id" maxlength="4" placeholder="ID">
							</div>
						</div>
						<div class="form-group">
							<label for="register_last_name" class="col-md-4 control-label">名前</label>
							<div class="col-md-3">
								<input type="text" class="form-control" name="register_last_name" placeholder="姓">
							</div>
							<div class="col-md-3">
								<input type="text" class="form-control" name="register_first_name" placeholder="名">
							</div>
						</div>
						<div class="form-group">
							<label for="register_email" class="col-md-4 control-label">メールアドレス</label>
							<div class="col-md-6">
								<input type="text" class="form-control" name="register_email" maxlength="100" placeholder="Email">
							</div>
						</div>
						<div class="form-group">
							<label for="register_password" class="col-md-4 control-label">パスワード</label>
							<div class="col-md-6">
								<input type="password" class="form-control" name="register_password" placeholder="Password">
							</div>
						</div>
						<div class="form-group">
							<label for="confirm_register_password" class="col-md-4 control-label">パスワード再入力</label>
							<div class="col-md-6">
								<input type="password" class="form-control" name="confirm_register_password" placeholder="Password">
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-success" name="register">登録</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
					</div>
				</div>
			</form>
		</div>
	</div>

    <div class="container">
		<div class="col-sm-12 col-md-3 col-lg-2 section menu" style="background: white;">
			<form class="form" name="item_state_form" role="form" action="Return">
				<div class="btn-group-vertical btn-block">
					<button type="submit" class="btn btn-default btn-block">
						<c:choose>
							<c:when test="${sessionScope.login != null || sessionScope.login == 'true'}">
								${fn:escapeXml(sessionScope.last_name)} 
								${fn:escapeXml(sessionScope.first_name)}
								さん
							</c:when>
							<c:otherwise>
								全体
							</c:otherwise>
						</c:choose>
					</button>
					<c:forEach var="item" items="${requestScope['list']}">
						<button type="submit" class="btn btn-default btn-block ellipsis">
							貸出中書籍 <span class="badge pull-right">${fn:escapeXml(item.circulation)}</span>
						</button>
						<button type="submit" class="btn btn-default btn-block ellipsis">
							貸出期限超過 <span class="badge pull-right">${fn:escapeXml(item.overdue)}</span>
						</button>
					</c:forEach>
				</div>
				<c:if test="${sessionScope.login != null || sessionScope.login == 'true'}">
					<button type="button" class="btn btn-danger btn-block" onClick="return document.forms['lend'].submit()">返却</button>
				</c:if>
			</form>
		</div>
		<div class="col-sm-12 col-md-9 col-lg-10 section" style="background: white;">
			<form class="form" name="lend" role="form" action="ReturnTransaction">
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">貸出中書籍</div>

					<!-- Table -->
					<table class="table">
						<tr>
							<c:if test="${sessionScope.login != null || sessionScope.login == 'true'}">
								<th>
										<input type="checkbox" onClick="toggleAll(this, 'bk_id')">
								</th>
							</c:if>
							<th>#</th>
							<th>書籍名</th>
							<th>出版社</th>
							<th>貸出日</th>
							<th>返却予定日</th>
						</tr>
						<c:forEach var="item" items="${requestScope['list2']}">
							<tr>
								<c:if test="${sessionScope.login != null || sessionScope.login == 'true'}">
									<td>
											<input type="checkbox" name="bk_id" value='${item.id}'>
									</td>
								</c:if>
								<td>${fn:escapeXml(item.id)}</td>
								<td>${fn:escapeXml(item.name)}</td>
								<td>${fn:escapeXml(item.publisher)}</td>
								<td>${fn:escapeXml(item.lendingDate)}</td>
								<td>${fn:escapeXml(item.dueDate)}</td>
							</tr>
						</c:forEach>
					</table>

				</div>
			</form>
		</div>
	</div>

    <div class="container">
		<div class="col-sm-12 col-md-9 col-lg-10 col-sm-offset-0 col-md-offset-3 col-lg-offset-2" style="background: white;">
			<div class="panel panel-default">
				<!-- Default panel contents -->
				<form class="form" name="overdue" role="form">
					<div class="panel-heading">貸出期限超過書籍</div>

					<!-- Table -->
					<table class="table">
						<tr>
							<th>#</th>
							<th>書籍名</th>
							<th>出版社</th>
							<th>貸出日</th>
							<th>返却予定日</th>
						</tr>
						<c:forEach var="item" items="${requestScope['list3']}">
							<tr>
								<td>${fn:escapeXml(item.id)}</td>
								<td>${fn:escapeXml(item.name)}</td>
								<td>${fn:escapeXml(item.publisher)}</td>
								<td>${fn:escapeXml(item.lendingDate)}</td>
								<td>${fn:escapeXml(item.dueDate)}</td>
							</tr>
						</c:forEach>
					</table>
				</form>
			</div>
		</div>
	</div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bookon.js" charset="UTF-8"></script>
  </body>
</html>