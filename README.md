BookOn
======

BookOn is a library management system.

###Database Name

Library_DB

###SQL

create table books_data (  
    bk_id char(5)  
  , bk_name varchar(300)  
  , pub_date datetime  
  , writer varchar(100)  
  , pub_id char(5)  
  , isbn_no char(13)  
  , price int) ;

create table group_master (  
    large_id int  
  , large varchar(10)  
  , middle_id int  
  , middle varchar(30)  
  , small_id int  
  , small varchar(30)  
) ;

create table item_state (  
  id char(4)  
  , bk_id char(5)  
  , lend_date datetime  
  , estimate_return_date datetime  
  , return_date datetime  
) ;

create table pub_master (  
  pub_id char(5)  
  , pub_name varchar(50)  
  
create table user_data (  
  id char(4) not null  
  , email varchar(100)  
  , password char(64)  
  , last_name varchar(20)  
  , first_name varchar(20)  
  , constraint user_data_PKC primary key (id)  
) ;

###Eclipse

**File Path :** %CATALINA_HOME%\conf\Catalina\localhost\YourProjectName.xml
    
If you use eclipse, you have to insert this xml inside `<Context>` tag

`<Resource name="jdbc/YourProjectName" auth="Container"`  
     `type="javax.sql.DataSource" username="YourUseName" password="YourPassword"`  
     `driverClassName="com.microsoft.sqlserver.jdbc.SQLServerDriver"`  
     `url="jdbc:sqlserver://localhost:1433;databaseName=Library_DB;" maxActive="4" maxWait="5000" maxIdle="2"`  
     `validationQuery="SELECT COUNT(*) FROM user_data" />`
