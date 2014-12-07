<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date,java.sql.*,java.text.*, javax.naming.*, javax.sql.*" %>
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
    <link href="css/jumbotron.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript">
    function toggleAll(source) {
      checkboxes = document.getElementsByName('bk_id');
      for(var i=0; i < checkboxes.length; i++) {
        checkboxes[i].checked = source.checked;
      }
    }
    </script>
  </head>
  <body>
    <%
      String email = request.getParameter("email");
      String login_pass = request.getParameter("password");
      pageContext.setAttribute("today", new Date());

      if((email != null || email != "") && (login_pass != null || login_pass != "")){
        Context context = new InitialContext();
        DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
        Connection db = ds.getConnection();
        db.setReadOnly(true);
        Statement objSql=db.createStatement();
        String login_query = ("SELECT * FROM user_data WHERE email = '" + email + "' AND password = HASHBYTES('SHA2_256', '" + login_pass + "')");
        ResultSet rs=objSql.executeQuery(login_query);

        if(rs.next()){
                //セッションを一度破棄
                session.invalidate();
                //セッション再生成
                session = request.getSession();
                //セッションへ保存
                session.setAttribute("email", email);
                //画面遷移
                response.sendRedirect("./index.jsp");
            }
        rs.close();
        objSql.close();
        db.close();
        }
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
          <a class="navbar-brand" href="SearchBooks">Book On</a>
          <ul class="nav navbar-nav">
		    		<li><a href="">about</a></li>
		    		<li><a href="">contact</a></li>
            <li><a href=""><fmt:formatDate value="${today}" type="DATE" dateStyle="FULL" /></a></li>
		      </ul>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
              <%if((session.getAttribute("login") == null) || !session.getAttribute("login").equals("true")){%>
              <form class="navbar-form navbar-right" role="form" method="post" action="authentication.jsp">
              <div class="form-group <%if (session.getAttribute("login") != null &&
          !session.getAttribute("login").equals("true")){%>has-error has-feedback<%}%>">
              <input type="text" name='email' placeholder="Email" class="form-control">
              <%if (session.getAttribute("login") != null &&
                  !session.getAttribute("login").equals("true")){%>
                  <span class="glyphicon glyphicon-remove form-control-feedback"></span>
                  <%}%>
              </div>
              <div class="form-group <%if (session.getAttribute("login") != null &&
          !session.getAttribute("login").equals("true")){%>has-error has-feedback<%}%>">
                <input type="password" name='pass' placeholder="Password" class="form-control">
                <%if (session.getAttribute("login") != null &&
                  !session.getAttribute("login").equals("true")){%>
                  <span class="glyphicon glyphicon-remove form-control-feedback"></span>
                  <%}%>
              </div>
              <button type="submit" class="btn btn-success">ログイン</button>
              </form>
              <%}else{%>
              <ul class="nav navbar-nav navbar-right">
                  <li><a href="#"><%=session.getAttribute("email")%></a></li>
                  <li>
                      <form class="navbar-form navbar-right" role="form" method="post" action="SignOut">
                      <button type="submit" class="btn btn-success">ログアウト</button>
                      </form>
                  </li>
              </ul>
              <%}%>
          </div><!--/.navbar-collapse -->
      </div>
    </div>

    <div class="container">
      <div class="col-sm-2" style="background:white;">
        <form class="form" name="item_state_form" role="form" action="./return.jsp">
          <div class="btn-group-vertical btn-block">
            <button type="submit" class="btn btn-default btn-block"><%if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")){%><%=session.getAttribute("last_name")%> <%=session.getAttribute("first_name")%> さん<%}else{%>全体<%}%></button>
            <%
            Context context = new InitialContext();
            DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
            Connection db = ds.getConnection();
            db.setReadOnly(true);
            Statement objSql7=db.createStatement();
            String countQuery = "SELECT COUNT(*) AS number FROM item_state WHERE return_date IS NULL";
            if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true"))
              {
                countQuery += " AND id = '" + session.getAttribute("id") + "'";
              }
            ResultSet rs7=objSql7.executeQuery(countQuery);
            while(rs7.next()){
            %>
              <button type="submit" class="btn btn-default btn-block">貸出中書籍 <span class="badge pull-right"><%=rs7.getInt("number")%></span></button>
            <%
            }
            rs7.close();
            objSql7.close();

            Statement objSql8=db.createStatement();
            String overdueQuery = "SELECT COUNT(*) AS number FROM item_state WHERE return_date IS NULL AND estimate_return_date < DATEDIFF(day, 1, GETDATE())";
            if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true"))
              {
                overdueQuery += " AND id = '" + session.getAttribute("id") + "'";
              }
            ResultSet rs8=objSql8.executeQuery(overdueQuery);
            while(rs8.next()){
            %>
            <button type="submit" class="btn btn-default btn-block">貸出期限超過 <span class="badge pull-right"><%=rs8.getInt("number")%></span></button>
            <%
            }
            %>
          </div>
          <%if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")){%>
          <button type="button" class="btn btn-danger btn-block" onClick="return document.forms['lend'].submit()">返却</button>
          <%}%>
        </form>
      </div>
      <div class="col-sm-10" style="background:white;">
        <div class="panel panel-default">
          <!-- Default panel contents -->
          <form class="form" name="lend" role="form" action="ReturnTransaction">
            <div class="panel-heading">貸出中書籍</div>

            <!-- Table -->
            <table class="table">
              <tr>
                <th>#</th>
                <%if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")){%>
                <th>
                  <div class="checkbox">
                      <input type="checkbox" onClick="toggleAll(this)">
                  </div>
                </th>
                <%}%>
                <th>書籍名</th>
                <th>出版社</th>
                <th>貸出日</th>
                <th>返却予定日</th>
              </tr>
              <%
              String query = "SELECT item_state.bk_id, bk_name, pub_name, lend_date, estimate_return_date FROM item_state INNER JOIN (SELECT bk_id, bk_name, pub_name FROM books_data bd INNER JOIN pub_master pm ON bd.pub_id = pm.pub_id) AS books_and_pub_data ON item_state.bk_id = books_and_pub_data.bk_id WHERE return_date IS NULL";
              if(session.getAttribute("id") != null)
                {
                  query += " AND id = '" + session.getAttribute("id") + "'";
                }

                Statement objSql2=db.createStatement();
                ResultSet rs2=objSql2.executeQuery(query);
                while(rs2.next()){
              %>
                <tr>
                  <td><%=rs2.getString("bk_id")%></td>
                  <%if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")){%>
                  <td>
                    <div class="checkbox">
                        <input type="checkbox" name="bk_id" value='<%=rs2.getString("bk_id")%>'>
                    </div>
                  </td>
                  <%}%>
                  <td><%=rs2.getString("bk_name")%></td>
                  <td><%=rs2.getString("pub_name")%></td>
                  <td><%=rs2.getDate("lend_date")%></td>
                  <td><%=rs2.getDate("estimate_return_date")%></td>
                </tr>
              <%
              }
              rs2.close();
              objSql2.close();
              %>
            </table>
          </form>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="col-sm-2" style="background:white;"></div>
      <div class="col-sm-10" style="background:white;">
        <div class="panel panel-default">
          <!-- Default panel contents -->
          <form class="form" name="overdue" role="form" action="./lend.jsp">
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
              <%
              String overdue_query = "SELECT item_state.bk_id, bk_name, pub_name, lend_date, estimate_return_date FROM item_state INNER JOIN (SELECT bk_id, bk_name, pub_name FROM books_data bd INNER JOIN pub_master pm ON bd.pub_id = pm.pub_id) AS books_and_pub_data ON item_state.bk_id = books_and_pub_data.bk_id WHERE return_date IS NULL　AND estimate_return_date < DATEDIFF(day, 1, GETDATE())";
              if(session.getAttribute("id") != null)
                {
                  overdue_query += " AND id = '" + session.getAttribute("id") + "'";
                }

                Statement objSql3=db.createStatement();
                ResultSet rs3=objSql3.executeQuery(overdue_query);
                while(rs3.next()){
              %>
                <tr>
                  <td><%=rs3.getString("bk_id")%></td>
                  <td><%=rs3.getString("bk_name")%></td>
                  <td><%=rs3.getString("pub_name")%></td>
                  <td><%=rs3.getDate("lend_date")%></td>
                  <td><%=rs3.getDate("estimate_return_date")%></td>
                </tr>
              <%
              }
              rs3.close();
              objSql3.close();
              db.close();
              %>
            </table>
          </form>
        </div>
      </div>
    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>