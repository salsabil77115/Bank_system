<%@ page language="java" contentType="text/html; charset=windows-1256"
    pageEncoding="windows-1256"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Customer Home</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<style>
div.msg {
  padding: 12px;
border: 3px solid #f1f1f1;}
p{
font-style: inherit;
font-size: 25px;
}
p.balance{
color:black;
}
p.msg{
color:green;

}
a.transfer{
color:black;

}
body {font-family: Arial, Helvetica, sans-serif;
  background-image: url("back.jpg");
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
    height: 100%; 
  margin: 0;


}
.navbar {
  width: 100%;
  background-color: #555;
  overflow: auto;
}

.navbar a {
  float: left;
  padding: 12px;
  color: white;
  text-decoration: none;
  font-size: 17px;
}

.navbar a:hover {
  background-color: #000;
}

.active {
  background-color: #4CAF50;
}

@media screen and (max-width: 500px) {
  .navbar a {
    float: none;
    display: block;
  }
}
button {
  background-color: #4CAF50;
  color: white;
  margin: 8px 0;
  border: none;
  cursor: pointer;
  margin-left: 10px;
  border-radius: 10px;
    padding: 10px;
  
}

button:hover {
  opacity: 0.8;
}
</style>
<body>
  <div class="navbar">
  <a class="active" href="customerhome.jsp"><i class="fa fa-fw fa-home"></i> Home</a> 
  <a href="transaction.jsp"><i class="fa fa-fw fa-search"></i> View Transactions</a> 
  <a href="AddT.jsp"><i class="fa fa-fw fa-envelope"></i> Make Transaction</a> 
      <a href="cancelTransfer.jsp"><i class="fa fa-fw fa-user"></i> Cancel transaction</a>
  
  <a href="Login.html"><i class="fa fa-fw fa-user"></i> Logout</a>
</div>
<%


String ID = request.getSession().getAttribute("ID").toString();
String url = "jdbc:mysql://localhost:3306/bankinfo";
String user = "salsabil";
String password = "123";
Connection Con = null;
Statement Stmt = null;
ResultSet RS = null;
Con = DriverManager.getConnection(url, user, password);
PreparedStatement ps=Con.prepareStatement("select BACurrentBalance,BankAccountID  from bankaccount where customer_id=? ");
ps.setString(1,ID);                   
RS=ps.executeQuery(); 
ResultSetMetaData rsmd=RS.getMetaData();%>


<% 
 
if(RS.next()) { %>

	<p class="balance">Your Balance until Now</p>

	<% int acountID=RS.getInt("BankAccountID");
	 session.setAttribute("Account_ID",acountID);
do{	%>
<table border="1">
<tr>
<td>Account Balance</td>
</tr>
<tr>
<td><%=RS.getString("BACurrentBalance") %></td>

</tr>   
</table>
<br><br>

<%

}while(RS.next());

}else {
	out.print("<div class='msg'>");
	out.print("<p>you aren't have Bank Account</p>");
	out.print("</div");

%>

<form action="addAccount" method="get">

<button>Add account</button>
</form>
<% 
}
String add=request.getParameter("add");
if(add!=null){
out.print("<p>"+add+"</p>");

}
String msg=request.getParameter("msg");
if(msg!=null){

	out.print("<p class='msg'>"+msg+"</p>");
}
Con.close();
%>
</body>
</html>