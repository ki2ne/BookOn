<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date,java.sql.*,java.text.*, javax.naming.*, javax.sql.*" %>
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
    var wrapperSubmit = function(callObj) {

      var middle_id = document.getElementsByName('middle_id');
      var small_id = document.getElementsByName('small_id');

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
      }

      document.forms['search_form'].submit();
    }
    </script>
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

      if((email != null || email != "") && (login_pass != null || login_pass != "")){
        Context context = new InitialContext();
        DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
        Connection db6 = ds.getConnection();
        db6.setReadOnly(true);
        Statement objSql6=db6.createStatement();
        String login_query = ("SELECT * FROM user_data WHERE email = '" + email + "' AND password = HASHBYTES('SHA2_256', '" + login_pass + "')");
        ResultSet rs6=objSql6.executeQuery(login_query);

        if(rs6.next()){
                //セッションを一度破棄
                session.invalidate();
                //セッション再生成
                session = request.getSession();
                //セッションへ保存
                session.setAttribute("email", email);
                //画面遷移
                response.sendRedirect("./index.jsp");
            }
        rs6.close();
        objSql6.close();
        db6.close();
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
          <a class="navbar-brand" href="">Book On</a>
          <ul class="nav navbar-nav">
		    		<li><a href="">about</a></li>
		    		<li><a href="">contact</a></li>
            <li><a href=""><%= new Date() %></a></li>
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
              <!-- Button trigger modal -->
              <button type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal">登録
              </button>
              </form>
              <%}else{%>
              <ul class="nav navbar-nav navbar-right">
                  <li><a href="#">session ID = <%=session.getId()%></a></li>
                  <li><a href="#"><%=session.getAttribute("email")%></a></li>
                  <li>
                      <form class="navbar-form navbar-right" role="form" method="post" action="sign_out.jsp">
                      <button type="submit" class="btn btn-success">ログアウト</button>
                      </form>
                  </li>
              </ul>
              <%}%>
          </div><!--/.navbar-collapse -->
      </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="myModalLabel">ユーザー登録</h4>
          </div>
          <div class="modal-body">
            <form class="form-horizontal" role="form">
              <div class="form-group">
                <label for="register_id" class="col-md-4 control-label">ID</label>
                <div class="col-md-6">
                  <input type="text" class="form-control" id="register_id" placeholder="ID">
                </div>
              </div>
              <div class="form-group">
                <label for="register_last_name" class="col-md-4 control-label">名前</label>
                <div class="col-md-3">
                  <input type="text" class="form-control" id="register_last_name" placeholder="姓">
                </div>
                <div class="col-md-3">
                  <input type="text" class="form-control" id="register_first_name" placeholder="名">
                </div>
              </div>
              <div class="form-group">
                <label for="register_email" class="col-md-4 control-label">メールアドレス</label>
                <div class="col-md-6">
                  <input type="email" class="form-control" id="register_email" placeholder="Email">
                </div>
              </div>
              <div class="form-group">
                <label for="register_password" class="col-md-4 control-label">パスワード</label>
                <div class="col-md-6">
                  <input type="password" class="form-control" id="register_password" placeholder="Password">
                </div>
              </div>
              <div class="form-group">
                <label for="register_password2" class="col-md-4 control-label">パスワード再入力</label>
                <div class="col-md-6">
                  <input type="password" class="form-control" id="register_password2" placeholder="Password">
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-success">登録</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="row">
        <form class="form" name="search_form" role="form" action="#">
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-primary">
                <input type="radio" autocomplete="off">大分類
              </label>
              <%
              Context context = new InitialContext();
              DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/bookon");
              Connection db = ds.getConnection();
              db.setReadOnly(true);
              Statement objSql=db.createStatement();
              ResultSet rs=objSql.executeQuery("SELECT DISTINCT large_id, large FROM group_master ORDER BY large_id");
              while(rs.next()){
              %>
                <label <%if(large_id != null){if(large_id.equals(rs.getString("large_id"))){%>class="btn btn-default active"<%}else{%>class="btn btn-default"<%}}else{%>class="btn btn-default"<%}%>>
                  <input type="radio" name="large_id" value ='<%=rs.getString("large_id")%>' autocomplete="off" <%if(large_id != null){if(large_id.equals(rs.getString("large_id"))){%>checked<%}}%> onChange="wrapperSubmit(this)"><%=rs.getString("large")%>
                </label>
              <%
              }
              rs.close();
              objSql.close();
              %>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-success">
                <input type="radio" autocomplete="off">中分類
              </label>
              <%
              Statement objSql2=db.createStatement();
              String middle_query = "SELECT DISTINCT middle_id, middle FROM group_master WHERE large_id = ";
              if(large_id != null)
              {
                middle_query += large_id;
              }
              else
              {
                middle_query += "1";
              }
              ResultSet rs2=objSql2.executeQuery(middle_query);
              while(rs2.next()){
              %>
                <label <%if(middle_id != null){if(middle_id.equals(rs2.getString("middle_id"))){%>class="btn btn-default active"<%}else{%>class="btn btn-default"<%}}else{%>class="btn btn-default"<%}%>>
                  <input type="radio" name="middle_id" value ='<%=rs2.getString("middle_id")%>' autocomplete="off" <%if(middle_id != null){if(middle_id.equals(rs2.getString("middle_id"))){%>checked<%}}%> onChange="wrapperSubmit(this)"><%=rs2.getString("middle")%>
                </label>
              <%
              }
              rs2.close();
              objSql2.close();
              %>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
            <div class="btn-group-vertical btn-block" data-toggle="buttons">
              <label class="btn btn-danger">
                <input type="radio" autocomplete="off">小分類
              </label>
              <%
                Statement objSql3=db.createStatement();
                String small_query = "SELECT DISTINCT small_id, small FROM group_master WHERE large_id = ";
                if(large_id != null)
                {
                  small_query += large_id;
                }
                else
                {
                  small_query += "1";
                }
                if(middle_id != null)
                {
                  small_query += (" AND middle_id = " + middle_id);
                }
                else
                {
                  small_query += " AND middle_id = 1";
                }
                ResultSet rs3=objSql3.executeQuery(small_query);
                while(rs3.next()){
              %>
                <label <%if(small_id != null){if(small_id.equals(rs3.getString("small_id"))){%>class="btn btn-default active"<%}else{%>class="btn btn-default"<%}}else{%>class="btn btn-default"<%}%>>
                  <input type="radio" name="small_id" value ='<%=rs3.getString("small_id")%>' autocomplete="off" <%if(small_id != null){if(small_id.equals(rs3.getString("small_id"))){%>checked<%}}%> onChange="submit()"><%=rs3.getString("small")%>
                </label>
              <%
              }
              rs3.close();
              objSql3.close();
              %>
            </div>
          </div>
          <div class="col-sm-2" style="background:white;">
            <div class="form-group">
              <div class="checkbox">
                <label>
                  <input type="checkbox" name="enable_pub_name" value="enable" <%if (enable_pub_name != null){%>checked<%}%>>
                  出版社
                </label>
              </div>
            </div>
            <select id="pub_name" name="pub_name" size ="14" class="form-control">
              <%
                Statement objSql4=db.createStatement();
                ResultSet rs4=objSql4.executeQuery("SELECT DISTINCT pub_name FROM books_data, pub_master WHERE books_data.pub_id = pub_master.pub_id");
                while(rs4.next()){
              %>
              <option <%if(pub_name != null){if(pub_name.equals(rs4.getString("pub_name"))){%>selected<%}}%>><%=rs4.getString("pub_name")%></option>
              <%
              }
              rs4.close();
              objSql4.close();
              %>
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
              <%
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
          </form>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="panel panel-default">
        <!-- Default panel contents -->
        <form class="form" name="book_table" role="form" action="./lend.jsp">
          <div class="panel-heading">検索結果</div>

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
            <%
            String query = "SELECT books_data.bk_id, bk_name, writer, pub_name, pub_date, isbn_no, price, state = CASE WHEN lend_date IS NOT NULL AND return_date IS NULL THEN 'false' ELSE 'true' END FROM books_data LEFT OUTER JOIN item_state ON books_data.bk_id = item_state.bk_id, pub_master WHERE pub_master.pub_id = books_data.pub_id";
            if((pub_name != "") && (enable_pub_name != null))
            {
              query += (" AND pub_name = '" + pub_name + "'");
            }
            if(name != null && name !="")
            {
              query += (" AND bk_name LIKE '%" + name + "%'");
            }
            if(writer != null && writer !="")
            {
              query += (" AND writer LIKE '%" + writer + "%'");
            }
            if(isbn != null && isbn !="")
            {
              query += (" AND isbn_no = '" + isbn + "'");
            }
            if(below_price != null && below_price !="")
            {
              query += (" AND price <= " + below_price);
            }
            if(above_price != null && above_price !="")
            {
              query += (" AND price >= " + above_price);
            }
            if(large_id != null && large_id !="")
            {
              query += (" AND books_data.bk_id LIKE '" + large_id + "%'");
            }
            if(middle_id != null && middle_id !="")
            {
              query += (" AND books_data.bk_id LIKE '_" + middle_id + "%'");
            }
            if(small_id != null && small_id !="")
            {
              query += (" AND books_data.bk_id LIKE '__" + small_id + "%'");
            }

              Statement objSql5=db.createStatement();
              ResultSet rs5=objSql5.executeQuery(query);
              while(rs5.next()){
            %>
              <tr>
                <td><%=rs5.getString("bk_id")%></td>
                <td><%=rs5.getString("bk_name")%></td>
                <td><%=rs5.getString("writer")%></td>
                <td><%=rs5.getString("pub_name")%></td>
                <td><%=rs5.getDate("pub_date")%></td>
                <td><%=rs5.getString("isbn_no")%></td>
                <td><%=rs5.getInt("price")%></td>
                <td><%if(rs5.getString("state").equals("true")){%><button type="submit" class="btn btn-primary btn-lg btn-block" <%if((session.getAttribute("login") == null) || !session.getAttribute("login").equals("true")){%>disabled=disabled<%}%> name="bk_id" value="<%=rs5.getString("bk_id")%>" onClick="return confirm('<%=rs5.getString("bk_name")%>を借りますか？')">貸出可</button><%}else{%><button type="button" class="btn btn-danger btn-lg btn-block">貸出中</button><%}%></td>
              </tr>
            <%
            }
            rs5.close();
            objSql5.close();
            db.close();
            %>
          </table>
        </form>
      </div>
    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>