<%@ page language="java" contentType="text/html; charset=windows-1256"
    pageEncoding="windows-1256"%>
 <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Transactions</title>
</head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
body {font-family: Arial, Helvetica, sans-serif;
  background-image: url("back.jpg");
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
    height: 100%; 
  


}
*{
font-family: Arial, Helvetica, sans-serif;
margin: 0;

}
p.make{
color:black;
font-size: 25px;
}
button {
  background-color: green;
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
font-weight: bold;}
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {background-color: #f2f2f2;}
p{
font-style: inherit;
font-size: 25px;
}
p.msg{
color:green;

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
    display: block;}
    }
 div.msg {
  padding: 12px;
border: 3px solid #f1f1f1;}
</style>
<body>
  <div class="navbar">
  <a class="active" href="customerhome.jsp"><i class="fa fa-fw fa-home"></i> Home</a> 
  <a href="transaction.jsp"><i class="fa fa-fw fa-search"></i> View Transactions</a> 
  <a href="AddT.jsp"><i class="fa fa-fw fa-envelope"></i> Make Transaction</a> 
    <a href="cancelTransfer.jsp"><i class="fa fa-fw fa-user"></i> Cancel transaction</a>
  
  <a href="Logout"><i class="fa fa-fw fa-user"></i> Logout</a>
</div>
<br><br><br>
<%
String msg=request.getParameter("msg");
if(msg!=null){
	out.print("<p class='msg'>"+msg+"</p>");
}
String url = "jdbc:mysql://localhost:3306/bankinfo";
String user = "salsabil";
String password = "123";
Connection Con = null;
Statement Stmt = null;
ResultSet RS = null;
Con = DriverManager.getConnection(url, user, password);
String BA_ID = request.getSession().getAttribute("Account_ID").toString();
int c=Integer.parseInt(BA_ID);
PreparedStatement ps=Con.prepareStatement("select BankTransactionID,BTAmount,BTToAccount,BTCreationDate  from banktransaction where BA_Id=? ");
ps.setString(1,BA_ID);                   
RS=ps.executeQuery(); 


if(RS.next()){%>
	<table border="1">
	<tr>
	<td>TransactionID</td>
	<td>Amount</td>
	<td>ToAccount</td>
	<td>CreationDate</td>
	</tr>
<% 	do{%>
	
<tr>
<td><%=RS.getInt("BankTransactionID") %></td>
<td><%=RS.getInt("BTAmount") %></td>
<td><%=RS.getInt("BTToAccount") %></td>
<td><%=RS.getDate("BTCreationDate") %></td>
</tr>
<%}while(RS.next());
%>
</table>
<br><br>

<%
}
else{ 
	out.print("<div class='msg'>");
out.print("<p> You didn't make any transactions</p>");
out.print("</div>");

}	
	String cancle=request.getParameter("cancle");
if(cancle!=null){
	out.print("<p>"+cancle+"</p>");
}%>

</body>
</html>