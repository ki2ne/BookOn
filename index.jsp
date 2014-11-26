<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date,java.sql.*,java.text.*" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
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
  </head>
  <body>
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Book On</a>
          <ul class="nav navbar-nav">
		    		<li><a href="">about</a></li>
		    		<li><a href="">contact</a></li>
            <li><a href=""><%= new Date() %></a></li>
		      </ul>
        </div>
        <div class="navbar-collapse collapse">
          <form class="navbar-form navbar-right" role="form">
            <div class="form-group">
              <input type="text" placeholder="Email" class="form-control">
            </div>
            <div class="form-group">
              <input type="password" placeholder="Password" class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Sign in</button>
          </form>
        </div><!--/.navbar-collapse -->
      </div>
    </div>

    <div class="container">
      <div class="row">
        <div class="col-sm-2" style="background:white;">
          <div class="list-group">
            <a href="#" class="list-group-item list-group-item-info">大分類</a>
            <%
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection db=DriverManager.getConnection("jdbc:sqlserver://192.168.10.122:1433;databaseName=Library_DB;integratedSecurity=false;user=sa;password=P@ssw0rd;");
            db.setReadOnly(true);
            Statement objSql=db.createStatement();
            ResultSet rs=objSql.executeQuery("SELECT DISTINCT large, large_id FROM group_master ORDER BY large_id");
            while(rs.next()){
            %>
              <a href="#" class="list-group-item"><%=rs.getString("large")%></a>
            <%
            }
            rs.close();
            objSql.close();
            db.close();
            %>
          </div>
        </div>
        <div class="col-sm-2" style="background:white;">
          <div class="list-group">
            <a href="#" class="list-group-item list-group-item-success">中分類</a>
            <%
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection db2=DriverManager.getConnection("jdbc:sqlserver://192.168.10.122:1433;databaseName=Library_DB;integratedSecurity=false;user=sa;password=P@ssw0rd;");
            db2.setReadOnly(true);
            Statement objSql2=db2.createStatement();
            ResultSet rs2=objSql2.executeQuery("SELECT DISTINCT middle FROM group_master WHERE middle_id = 1");
            while(rs2.next()){
            %>
              <a href="#" class="list-group-item"><%=rs2.getString("middle")%></a>
            <%
            }
            rs2.close();
            objSql2.close();
            db2.close();
            %>
          </div>
        </div>
        <div class="col-sm-2" style="background:white;">
          <div class="list-group">
            <a href="#" class="list-group-item list-group-item-danger">小分類</a>
            <a href="#" class="list-group-item">ネットワーク</a>
            <a href="#" class="list-group-item">TCP/IP</a>
            <a href="#" class="list-group-item">セキュリティ</a>
          </div>
        </div>
        <div class="col-sm-2" style="background:white;">
          <form class="form-horizontal" role="form">
            <div class="form-group">
              <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-book"></span></div>
                  <input class="form-control" type="email" placeholder="書籍名">
              </div>
            </div>
            <div class="form-group">
              <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-user"></span></div>
                  <input class="form-control" type="email" placeholder="著者">
              </div>
            </div>
            <div class="form-group">
              <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-barcode"></span></div>
                  <input class="form-control" type="email" placeholder="ISBN">
              </div>
            </div>
            <div class="form-group">
              <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-usd"></span></div>
                  <input class="form-control" type="email" placeholder="価格">
              </div>
            </div>
          </form>
        </div>
        <div class="col-sm-2" style="background:white;">
          <select multiple id="pub_name" size ="19" class="form-control">
            <option class="bg-info text-info" disabled="disabled">出版社</option>
            <option>IDGｼﾞｬﾊﾟﾝ</option>
            <option>朝倉書店</option>
            <option>ｱｽｷｰ</option>
            <option>医道の日本社</option>
            <option>岩波書店</option>
          </select>
        </div>
        <div class="col-sm-2" style="background:white;">
          <button type="button" class="btn btn-primary btn-lg btn-block">検索</button>
        </div>
      </div>
    </div>

    <div classname="container">
      <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading">検索結果</div>

        <!-- Table -->
        <table class="table">
          <tr>
            <th>#</th>
            <th>書籍名</th>
            <th>著者</th>
            <th>出版社</th>
            <th>発行年</th>
            <th>価格</th>
            <th>ISBN</th>
          </tr>
          <%
          Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection db3=DriverManager.getConnection("jdbc:sqlserver://192.168.10.122:1433;databaseName=Library_DB;integratedSecurity=false;user=sa;password=P@ssw0rd;");
            db3.setReadOnly(true);
            Statement objSql3=db3.createStatement();
            ResultSet rs3=objSql3.executeQuery("SELECT bk_id, bk_name, writer, pub_name, pub_date, isbn_no, price FROM books_data, pub_master WHERE books_data.pub_id = pub_master.pub_id");
            while(rs3.next()){
          %>
            <tr>
              <td><%=rs3.getString("bk_id")%></td>
              <td><%=rs3.getString("bk_name")%></td>
              <td><%=rs3.getString("writer")%></td>
              <td><%=rs3.getString("pub_name")%></td>
              <td><%=rs3.getDate("pub_date")%></td>
              <td><%=rs3.getString("isbn_no")%></td>
              <td><%=rs3.getInt("price")%></td>
            </tr>
          <%
          }
          rs3.close();
          objSql3.close();
          db3.close();
          %>
        </table>
      </div>
    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>