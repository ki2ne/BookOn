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
      String enable_pub_name = request.getParameter("enable_pub_name");
      String pub_name = request.getParameter("pub_name");
      String name = request.getParameter("name");
      String writer = request.getParameter("writer");
      String isbn = request.getParameter("isbn");
      String below_price = request.getParameter("below_price");
      String above_price = request.getParameter("above_price");
      String large_id = request.getParameter("large_id");
      String middle_id = request.getParameter("middle_id");
      String small_id = request.getParameter("small_id");
      String email = request.getParameter("email");
      String login_pass = request.getParameter("password");
      
      pageContext.setAttribute("today", new Date());
      
      session.setAttribute("large_id", large_id);
      session.setAttribute("middle_id", middle_id);
      session.setAttribute("small_id", small_id);
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
				<a class="navbar-brand" href="#" onClick="clearAll()">Book On</a>
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
		</div><!-- /.container -->
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
						<button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
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
	    <form class="form search_form" name="search_form" role="form" action="Search">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-6">
					<div class="col-sm-4 section" style="background: white;">
						<div class="btn-group-vertical btn-block" data-toggle="buttons">
							<label class="btn btn-primary"> <input type="radio" autocomplete="off">大分類</label>
							<c:forEach var="item" items="${requestScope['list']}">
								<c:choose>
									<c:when test="${param.large_id != null}">
										<c:choose>
											<c:when test="${param.large_id == item.id}">
												<label class="btn btn-default ellipsis active">
												<input type="radio" name="large_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
												</label>
											</c:when>
											<c:otherwise>
												<label class="btn btn-default ellipsis">
												<input type="radio" name="large_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
												</label>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<label class="btn btn-default ellipsis">
										<input type="radio" name="large_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
										</label>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</div>
					<div class="col-sm-4 section" style="background: white;">
						<div class="btn-group-vertical btn-block" data-toggle="buttons">
							<label class="btn btn-success"> <input type="radio" autocomplete="off">中分類</label>
							<c:forEach var="item" items="${requestScope['list2']}">
								<c:choose>
									<c:when test="${param.middle_id != null}">
										<c:choose>
											<c:when test="${param.middle_id == item.id}">
												<label class="btn btn-default ellipsis active">
												<input type="radio" name="middle_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
												</label>
											</c:when>
											<c:otherwise>
												<label class="btn btn-default ellipsis">
												<input type="radio" name="middle_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
												</label>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<label class="btn btn-default ellipsis">
										<input type="radio" name="middle_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
										</label>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</div>
					<div class="col-sm-4 section" style="background: white;">
						<div class="btn-group-vertical btn-block" data-toggle="buttons">
							<label class="btn btn-danger"> <input type="radio" autocomplete="off">小分類</label>
							<c:forEach var="item" items="${requestScope['list3']}">
								<c:choose>
									<c:when test="${param.small_id != null}">
										<c:choose>
											<c:when test="${param.small_id == item.id}">
												<label class="btn btn-default ellipsis active"> <input type="radio" name="small_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
												</label>
											</c:when>
											<c:otherwise>
												<label class="btn btn-default ellipsis"> <input type="radio" name="small_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
												</label>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<label class="btn btn-default ellipsis"> <input type="radio" name="small_id" value="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
										</label>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-12 col-lg-6">
					<div class="col-sm-4 section" style="background: white;">
						<div class="form-group">
							<div class="checkbox">
								<label>
									<c:choose>
										<c:when test="${param.enable_pub_name != null}">
											<input type="checkbox" name="enable_pub_name" value="enable" checked>出版社
										</c:when>
										<c:otherwise>
											<input type="checkbox" name="enable_pub_name" value="enable">出版社
										</c:otherwise>
									</c:choose>
								</label>
							</div>
						</div>
						<select id="pub_name" name="pub_name" size="14" class="form-control">
							<c:forEach var="item" items="${requestScope['list4']}">
								<c:choose>
									<c:when test="${param.pub_name != null}">
										<c:choose>
											<c:when test="${param.pub_name == item.name}">
												<option selected>${fn:escapeXml(item.name)}</option>
											</c:when>
											<c:otherwise>
												<option>${fn:escapeXml(item.name)}</option>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<option>${fn:escapeXml(item.name)}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<div class="col-sm-4 section" style="background: white;">
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="glyphicon glyphicon-book"></span>
								</div>
								<input class="form-control" type="text" name="name" value='<%if (name != null) {%><%=name%><%}%>' placeholder="書籍名">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="glyphicon glyphicon-user"></span>
								</div>
								<input class="form-control" type="text" name="writer" value='<%if (writer != null) {%><%=writer%><%}%>' placeholder="著者">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="glyphicon glyphicon-barcode"></span>
								</div>
								<input class="form-control" type="text" name="isbn" value='<%if (isbn != null) {%><%=isbn%><%}%>' placeholder="ISBN">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="glyphicon glyphicon-usd"></span>
								</div>
								<input class="form-control" type="text" name="below_price" value='<%if (below_price != null) {%><%=below_price%><%}%>' placeholder="価格">
								<span class="input-group-addon">以下</span>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="glyphicon glyphicon-usd"></span>
								</div>
								<input class="form-control" type="text" name="above_price" value='<%if (above_price != null) {%><%=above_price%><%}%>' placeholder="価格">
								<span class="input-group-addon">以上</span>
							</div>
						</div>
						<button type="submit" class="btn btn-primary btn-lg btn-block">検索</button>
						<input type="hidden" id="page" name="page" value="1">
					</div>
					<div class="col-sm-4 section" style="background: white;">
						<div class="btn-group-vertical btn-block">
							<a href="Return" class="btn btn-default btn-block">
								<c:choose>
									<c:when test="${sessionScope.login != null && sessionScope.login == 'true'}">
										${fn:escapeXml(sessionScope.last_name)} 
										${fn:escapeXml(sessionScope.first_name)}
										さん
									</c:when>
									<c:otherwise>
										全体
									</c:otherwise>
								</c:choose>
							</a>
							<c:forEach var="item" items="${requestScope['list6']}">
								<a href="Return" class="btn btn-default btn-block ellipsis">
									貸出中書籍 <span class="badge pull-right">${fn:escapeXml(item.circulation)}</span>
								</a>
								<a href="Return" class="btn btn-default btn-block ellipsis">
									貸出期限超過 <span class="badge pull-right">${fn:escapeXml(item.overdue)}</span>
								</a>
							</c:forEach>
							<a href="overview.jsp" class="btn btn-default btn-block ellipsis">管理画面</a>
						</div>
					</div>
				</div>
			</div>
		</form><!-- /.form -->
	</div><!-- /.container -->

    <div class="container">
		<div class="panel panel-default  section">
			<!-- Default panel contents -->
			<form class="form" name="book_table" role="form" action="LendTransaction">
				<div class="panel-heading clearfix">
					<div class="container">
						<div class="row">
							<nav>
							<div class="col-md-2 col-sm-2">
								<h4 class="text-center">検索結果</h4>
							</div>
							<div class="col-md-8 col-sm-8">
								<c:if test="${requestScope.pagination.totalPage > 1}">
								<div class="text-center">
								    <div class="btn-group">
								        <button type="button" class="btn btn-default"><span aria-hidden="true">&laquo;</span><span class="sr-only">Previous</span></button>
									        <c:choose>
												<c:when test="${requestScope.pagination.totalPage < 10}">
													<c:forEach var="i" begin="1" end="${requestScope.pagination.totalPage}" step="1">
														<c:choose>
															<c:when test="${i == requestScope.pagination.page}">
																<button type="button" class="btn btn-default active" OnClick="submitPage(${i})">${i}</button>
															</c:when>
															<c:otherwise>
																<button type="button" class="btn btn-default" OnClick="submitPage(${i})">${i}</button>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<c:forEach var="i" begin="${requestScope.pagination.begin}" end="${requestScope.pagination.begin + 9}" step="1">
														<c:choose>
															<c:when test="${i == requestScope.pagination.page}">
																<button type="button" class="btn btn-default active" OnClick="submitPage(${i})">${i}</button>
															</c:when>
															<c:otherwise>
																<button type="button" class="btn btn-default" OnClick="submitPage(${i})">${i}</button>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</c:otherwise>
											</c:choose>
								        <button type="button" class="btn btn-default"><span aria-hidden="true">&raquo;</span><span class="sr-only">Previous</span></button>
								    </div>
								</div>
								</c:if>
							</div>
							</nav>
							<div class="col-md-2 col-sm-2">
								<div class="form-group">
									<button type="button" name="pdf" class="btn btn-danger" onClick="createPDF()">PDF</button>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Table -->
				<table class="table">
					<tr>
						<th width="6%">#</th>
						<th width="40%">書籍名</th>
						<th width="17%">著者</th>
						<th width="10%">出版社</th>
						<th width="6%">発行年</th>
						<th width="10%">ISBN</th>
						<th width="5%">価格</th>
						<th width="6%">貸出状況</th>
					</tr>
					<c:forEach var="item" items="${requestScope['list5']}">
						<tr>
							<td>${fn:escapeXml(item.id)}</td>
							<td>${fn:escapeXml(item.name)}</td>
							<td>${fn:escapeXml(item.author)}</td>
							<td>${fn:escapeXml(item.publisher)}</td>
							<td>${fn:escapeXml(item.publicationDate)}</td>
							<td>${fn:escapeXml(item.isbn)}</td>
							<td>${fn:escapeXml(item.price)}</td>
							<td>
								<c:choose>
									<c:when test="${item.state == 'true'}">
										<c:choose>
											<c:when test="${sessionScope.login == null || sessionScope.login != 'true'}">
												<button type="submit" class="btn btn-primary btn-lg btn-block" disabled=disabled>貸出可</button>
											</c:when>
											<c:otherwise>
												<button type="submit" class="btn btn-primary btn-lg btn-block" name="bk_id" value="${item.id}" onClick="return confirm('${item.name}を借りますか？')">貸出可</button>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-danger btn-lg btn-block">貸出中</button>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</table>
			</form><!-- /.form -->
			<div class="panel-footer">
				<c:if test="${requestScope.pagination.totalPage > 1}">
					<div class="text-center">
					    <div class="btn-group">
					        <button type="button" class="btn btn-default"><span aria-hidden="true">&laquo;</span><span class="sr-only">Previous</span></button>
						        <c:choose>
									<c:when test="${requestScope.pagination.totalPage < 10}">
										<c:forEach var="i" begin="1" end="${requestScope.pagination.totalPage}" step="1">
											<button type="button" class="btn btn-default" OnClick="submitPage(${i})">${i}</button>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<c:forEach var="i" begin="${requestScope.pagination.begin}" end="${requestScope.pagination.begin + 9}" step="1">
											<button type="button" class="btn btn-default" OnClick="submitPage(${i})">${i}</button>
										</c:forEach>
									</c:otherwise>
								</c:choose>
					        <button type="button" class="btn btn-default"><span aria-hidden="true">&raquo;</span><span class="sr-only">Previous</span></button>
					    </div>
					</div>
				</c:if>
			</div>
		</div>
	</div><!-- /.container -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="js/jquery.cookie.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bootstrapValidator.min.js"></script>
    <script src="js/bookon.js" charset="UTF-8"></script>
    <c:if test="${sessionScope.resultOfLendTransaction != null && sessionScope.resultOfLendTransaction == -1}">
    <script type="text/javascript">
    alert("ご指定の本は既に借りられています。");
    </script>
    <% session.setAttribute("resultOfLendTransaction", 0); %>
    </c:if>
    <%--<c:if test="${sessionScope.login != null && sessionScope.login != 'true'}">
    <script type="text/javascript">
    $('#loginModal').modal({ show: true });
    </script>
    </c:if>--%>
  </body>
</html>