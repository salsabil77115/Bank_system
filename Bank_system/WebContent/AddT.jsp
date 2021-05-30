<%@ page language="java" contentType="text/html; charset=windows-1256"
    pageEncoding="windows-1256"%>
        <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

</head>
<style>
*{
margin: 0;
}

body {font-family: Arial, Helvetica, sans-serif;
  background-image: url("back.jpg");
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
    height: 100%; 
 
}
.container {
  padding: 12px;
  
}
form {border: 3px solid #f1f1f1;}

input[type=text], input[type=number] {
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  box-sizing: border-box;
  padding:10px;
    border-radius: 10px;
  
}

button {
  background-color: #4CAF50;
  color: white;
  margin: 8px 0;
  border: none;
  cursor: pointer;
  margin-left: 70px;
  border-radius: 10px;
    padding: 10px;
  
}

button:hover {
  opacity: 0.8;
}
#x{
margin-left: 66px;
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
div.msg {
  padding: 12px;
border: 3px solid #f1f1f1;}
@media screen and (max-width: 500px) {
  .navbar a {
    float: none;
    display: block;}
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
<br><br>
<form action="AddT.jsp" method="post">
<div class="container">
    <label for="accN"><b>Account Number</b></label>
    <input type="text" placeholder="Enter Account Number" name="accN" >
<br>
    <label for="amount"><b>Amount</b></label>
    <input type="number" placeholder="Enter Amount" name="amount" id="x">
        <br>
    <button type="submit">Transfer</button>
   
  </div>
  </form>
<%
String url = "jdbc:mysql://localhost:3306/bankinfo";
String user = "salsabil";
String password = "123";
Connection Con = null;
ResultSet RS = null;
ResultSet RS1 = null;
ResultSet RS4= null;
String msg="";
Con = DriverManager.getConnection(url, user, password);
String BA_ID = request.getSession().getAttribute("Account_ID").toString();
String ID = request.getSession().getAttribute("ID").toString();

String Account_ID ="";
String Amount=""; 
if(request.getParameter("accN")!=null&&request.getParameter("amount")!=null)
    		{
    		  
    			Account_ID = request.getParameter("accN");
    		    Amount = request.getParameter("amount");
    		

 if(Account_ID.equals(ID)){
	out.print("<div class='msg'>");

	 out.println("<p>Can't Transfer money to Yourself !</p> ");
	 out.print("</div>");
 }else{
PreparedStatement ps1=Con.prepareStatement("select * from bankaccount where customer_id=?");

ps1.setString(1, Account_ID);
RS=ps1.executeQuery(); 
if(RS.next()){
PreparedStatement ps4=Con.prepareStatement("select * from bankaccount where customer_id=?");

ps4.setString(1, ID);
RS4=ps4.executeQuery();

String balanceT=RS.getString("BACurrentBalance");
if(RS4.next()){
String balanceF=RS4.getString("BACurrentBalance");
int balanceTo=Integer.parseInt(balanceT);
int balanceFrom=Integer.parseInt(balanceF);
int amount=Integer.parseInt(Amount);
balanceTo=balanceTo+amount;
balanceFrom=balanceFrom-amount;
if(balanceFrom<0){
	out.print("<div class='msg'>");

	out.print("<p>your balance not enough !</p>");
	out.print("</div>");

}else{
Random rand = new Random();
int n = rand.nextInt(90000) + 10000;    	
PreparedStatement ps2=Con.prepareStatement("INSERT INTO banktransaction (BankTransactionID ,BTAmount, BTFromAccount,BTToAccount,BA_Id) values (?, ?, ?, ?,?)");
ps2.setInt(1,n);
ps2.setString(2, Amount);
ps2.setString(3, ID);
ps2.setString (4, Account_ID);
ps2.setString(5, BA_ID);
int x2=ps2.executeUpdate();
if(x2!=0){
	PreparedStatement ps3=Con.prepareStatement(	"UPDATE `bankaccount` SET `BACurrentBalance`=? where `customer_id`=?");

	ps3.setInt(1,balanceTo);
	ps3.setString(2,Account_ID);
	ps3.executeUpdate();
	PreparedStatement ps5=Con.prepareStatement(	"UPDATE `bankaccount` SET `BACurrentBalance`=? where `customer_id`=?");

	ps5.setInt(1,balanceFrom);
	ps5.setString(2,ID);
	int x5=ps5.executeUpdate();
	
if(x5!=0){
response.sendRedirect("transaction.jsp?msg=Succesfully trasaction!");}
else{
	response.sendRedirect("transaction.jsp?msg=Filed!");}
}else{
out.print("Can't Execute query");}
}
}
}else{
	out.print("<div class='msg'>");
	out.print("<P>No such Account Number!</p>");
out.print("</div>");}
}
    		}
%>
</body>
</html>