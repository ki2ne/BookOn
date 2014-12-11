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
    <meta charset="Windows-31J">
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
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
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
				<form class="navbar-form navbar-right" role="form" method="post" action="Authentication">
				<c:choose>
					<c:when test="${sessionScope.login != null}">
						<div class="form-group has-error has-feedback">
							<input type="text" name='email' placeholder="Email" class="form-control">
							<span class="glyphicon glyphicon-remove form-control-feedback"></span>
						</div>
						<div class="form-group has-error has-feedback">
							<input type="password" name='pass' placeholder="Password" class="form-control">
							<span class="glyphicon glyphicon-remove form-control-feedback"></span>
						</div>
					</c:when>
					<c:otherwise>
						<div class="form-group">
							<input type="text" name='email' placeholder="Email" class="form-control">
						</div>
						<div class="form-group">
							<input type="password" name='pass' placeholder="Password" class="form-control">
						</div>
					</c:otherwise>
				</c:choose>
							<button type="submit" class="btn btn-success">ログイン</button>
          					<!-- Button trigger modal -->
          					<button type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal">登録
          					</button>
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
        </div><!--/.navbar-collapse -->
      </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form class="form-horizontal register_form" method="POST" name="register_form" role="form" action="RegisterTransaction">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
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
      <div class="row">
        <form class="form search_form" name="search_form" role="form" action="SearchBooks">
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-primary">
                <input type="radio" autocomplete="off">大分類
              </label>
                <c:forEach var="item" items="${requestScope['list']}">
              	<c:choose>
					<c:when test="${param.large_id != null}">
						<c:choose>
							<c:when test="${param.large_id == item.id}">
								<label class="btn btn-default ellipsis active">
									<input type="radio" name="large_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
								</label>
							</c:when>
							<c:otherwise>
								<label class="btn btn-default ellipsis">
									<input type="radio" name="large_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
								</label>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<label class="btn btn-default ellipsis">
							<input type="radio" name="large_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
						</label>
					</c:otherwise>
				</c:choose>
              </c:forEach>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-success">
                <input type="radio" autocomplete="off">中分類
              </label>
                <c:forEach var="item" items="${requestScope['list2']}">
              	<c:choose>
					<c:when test="${param.middle_id != null}">
						<c:choose>
							<c:when test="${param.middle_id == item.id}">
								<label class="btn btn-default ellipsis active">
									<input type="radio" name="middle_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
								</label>
							</c:when>
							<c:otherwise>
								<label class="btn btn-default ellipsis">
									<input type="radio" name="middle_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
								</label>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<label class="btn btn-default ellipsis">
							<input type="radio" name="middle_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
						</label>
					</c:otherwise>
				</c:choose>
              </c:forEach>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-danger">
                <input type="radio" autocomplete="off">小分類
              </label>
                <c:forEach var="item" items="${requestScope['list3']}">
              	<c:choose>
					<c:when test="${param.small_id != null}">
						<c:choose>
							<c:when test="${param.small_id == item.id}">
								<label class="btn btn-default ellipsis active">
									<input type="radio" name="small_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)" checked>${fn:escapeXml(item.classification)}
								</label>
							</c:when>
							<c:otherwise>
								<label class="btn btn-default ellipsis">
									<input type="radio" name="small_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
								</label>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<label class="btn btn-default ellipsis">
							<input type="radio" name="small_id" value ="${item.id}" autocomplete="off" onChange="wrapperSubmit(this)">${fn:escapeXml(item.classification)}
						</label>
					</c:otherwise>
				</c:choose>
              </c:forEach>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
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
            <select id="pub_name" name="pub_name" size ="14" class="form-control">
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
          <div class="col-sm-2" style="background:white;">
              <div class="form-group">
                <div class="input-group">
                  <div class="input-group-addon"><span class="glyphicon glyphicon-book"></span></div>
                    <input class="form-control" type="text" name="name" value='<%if (name != null){%><%=name%><%}%>' placeholder="書籍名">
                </div>
              </div>
              <div class="form-group">
                <div class="input-group">
                  <div class="input-group-addon"><span class="glyphicon glyphicon-user"></span></div>
                    <input class="form-control" type="text" name="writer" value='<%if (writer != null){%><%=writer%><%}%>' placeholder="著者">
                </div>
              </div>
              <div class="form-group">
                <div class="input-group">
                  <div class="input-group-addon"><span class="glyphicon glyphicon-barcode"></span></div>
                    <input class="form-control" type="text" name="isbn" value='<%if (isbn != null){%><%=isbn%><%}%>' placeholder="ISBN">
                </div>
              </div>
              <div class="form-group">
                <div class="input-group">
                  <div class="input-group-addon"><span class="glyphicon glyphicon-usd"></span></div>
                    <input class="form-control" type="text" name="below_price" value='<%if (below_price != null){%><%=below_price%><%}%>' placeholder="価格">
                  <div class="input-group-addon">以下</span></div>
                </div>
              </div>
              <div class="form-group">
                <div class="input-group">
                  <div class="input-group-addon"><span class="glyphicon glyphicon-usd"></span></div>
                    <input class="form-control" type="text" name="above_price" value='<%if (above_price != null){%><%=above_price%><%}%>' placeholder="価格">
                  <div class="input-group-addon">以上</span></div>
                </div>
              </div>
              <button type="submit" class="btn btn-primary btn-lg btn-block">検索</button>
          </div>
        </form>
        <div class="col-sm-2" style="background:white;">
          <form class="form" name="item_state_form" role="form" action="./return.jsp">
            <div class="btn-group-vertical btn-block">
              <button type="submit" class="btn btn-default btn-block"><%if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")){%><%=session.getAttribute("last_name")%> <%=session.getAttribute("first_name")%> さん<%}else{%>全体<%}%></button>
              <c:forEach var="item" items="${requestScope['list6']}">
                <button type="submit" class="btn btn-default btn-block ellipsis">貸出中書籍 <span class="badge pull-right">${fn:escapeXml(item.circulation)}</span></button>
              	<button type="submit" class="btn btn-default btn-block ellipsis">貸出期限超過 <span class="badge pull-right">${fn:escapeXml(item.overdue)}</span></button>
              </c:forEach>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="panel panel-default">
        <!-- Default panel contents -->
        <form class="form" name="book_table" role="form" action="LendTransaction">
          <div class="panel-heading">検索結果
            <div class="form-group pull-right">
              <button type="button" name="pdf" class="btn btn-danger" onClick ="createPDF()">PDF</button>
            </div>
          </div>

          <!-- Table -->
          <table class="table">
            <tr>
              <th>#</th>
              <th>書籍名</th>
              <th>著者</th>
              <th>出版社</th>
              <th>発行年</th>
              <th>ISBN</th>
              <th>価格</th>
              <th>貸出状況</th>
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
        </form>
      </div>
    </div>
    
    <c:if test="${sessionScope.resultOfLendTransaction != null && sessionScope.resultOfLendTransaction == -1}">
    <script type="text/javascript">
    alert("ご指定の本は既に借りられています。");
    </script>
    <% session.setAttribute("resultOfLendTransaction", 0); %>
    </c:if>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bootstrapValidator.min.js"></script>
    <script type="text/javascript">
    var wrapperSubmit = function(callObj) {

      var large_id = document.getElementsByName('large_id');
      var middle_id = document.getElementsByName('middle_id');
      var small_id = document.getElementsByName('small_id');
      var large_id_is_not_checked = true;
      var middle_id_is_not_checked = true;

      if (callObj.name == 'large_id') {
        for(var i=0; i < middle_id.length; i++)
        {
        middle_id[i].checked = false;
        }
        for(var i=0; i < small_id.length; i++)
        {
        small_id[i].checked = false;
        }
      }
      if (callObj.name == 'middle_id') {
        for(var i=0; i < small_id.length; i++)
        {
        small_id[i].checked = false;
        }
        for(var i=0; i < large_id.length; i++)
        {
          if(large_id[i].checked == true)
          {
            large_id_is_not_checked = false;
          }
        }
        if(large_id_is_not_checked == true) {
          large_id[0].checked = true;
        }
      }

      if (callObj.name == 'small_id') {
        for(var i=0; i < large_id.length; i++)
        {
          if(large_id[i].checked == true)
          {
            large_id_is_not_checked = false;
          }
        }
        if(large_id_is_not_checked == true) {
          large_id[0].checked = true;
        }
        for(var i=0; i < middle_id.length; i++)
        {
          if(middle_id[i].checked == true)
          {
            middle_id_is_not_checked = false;
          }
        }
        if(middle_id_is_not_checked == true) {
          middle_id[0].checked = true;
        }
      }

      document.forms['search_form'].submit();
    }

    function clearAll() {
      var large_id = document.getElementsByName('large_id');
      var middle_id = document.getElementsByName('middle_id');
      var small_id = document.getElementsByName('small_id');

      for(var i=0; i < large_id.length; i++)
        {
          large_id[i].checked = false;
        }
        for(var i=0; i < middle_id.length; i++)
        {
          middle_id[i].checked = false;
        }
        for(var i=0; i < small_id.length; i++)
        {
          small_id[i].checked = false;
        }
        document.forms['search_form'].submit();
    }

    $(document).ready(function() {
        $('.register_form').bootstrapValidator({
            live: 'disabled',
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                register_id: {
                    message: 'ID is not valid',
                    validators: {
                        notEmpty: {
                            message: 'IDを入力してください'
                        },
                        stringLength: {
                            min: 4,
                            max: 4,
                            message: '有効なIDを入力してください'
                        },
                        integer: {
                            message: '半角数字で入力してください'
                        }
                    }
                },
                register_last_name: {
                    validators: {
                        notEmpty: {
                            message: 'お名前(姓)を入力してください'
                        },
                        stringLength: {
                            max: 20,
                            message: '全角10文字まで'
                        }
                    }
                },
                register_first_name: {
                    validators: {
                        notEmpty: {
                            message: 'お名前(名)を入力してください'
                        },
                        stringLength: {
                            max: 20,
                            message: '全角10文字まで'
                        }
                    }
                },
                register_email: {
                    validators: {
                        notEmpty: {
                            message: 'メールアドレスを入力してください'
                        },
                        emailAddress: {
                            message: '有効なメールアドレスを入力してください'
                        }
                    }
                },
                register_password: {
                    validators: {
                        notEmpty: {
                            message: 'パスワードを入力してください'
                        },
                        stringLength: {
                            min: 5,
                            max: 20,
                            message: '5 ～ 20文字で作成してください'
                        },
                        regexp: {
                            regexp: /(?=(.*[0-9])+|(.*[ !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~])+)(?=(.*[a-z])+)(?=(.*[A-Z])+)[0-9a-zA-Z !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~]{8,}/g,
                            message: '大文字、小文字、数字、ASCIIシンボルを含む半角の文字列で登録してください'
                        },
                        identical: {
                        field: 'confirm_register_password',
                        message: 'パスワードが一致しません'
                        }
                    }
                },
                confirm_register_password: {
                    validators: {
                        notEmpty: {
                            message: 'パスワードを再度入力してください'
                        },
                        stringLength: {
                            min: 5,
                            max: 20,
                            message: '5 ～ 20文字で作成してください'
                        },
                        regexp: {
                            regexp: /(?=(.*[0-9])+|(.*[ !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~])+)(?=(.*[a-z])+)(?=(.*[A-Z])+)[0-9a-zA-Z !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~]{8,}/g,
                            message: '大文字、小文字、数字、ASCIIシンボルを含む半角の文字列で登録してください'
                        },
                        identical: {
                        field: 'register_password',
                        message: 'パスワードが一致しません'
                        }
                    }
                }
            }
        });

        $('#myModal').on('shown.bs.modal', function() {
            $('.register_form').bootstrapValidator('resetForm', true);
        });
    });

    function createPDF() {
      window.open("./CreatePDF");
    }
    </script>
  </body>
</html>