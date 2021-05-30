<%@ page language="java" contentType="text/html; charset=windows-1256" pageEncoding="windows-1256"%>
<%@ page import = "javax.servlet.*,java.text.*" %>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ page import ="java.util.*"%>
<%@ page import ="java.sql.*"%>
<%@ page import ="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Cancel Transaction</title>
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
div.msg {
  padding: 12px;
border: 3px solid #f1f1f1;}
</style>
<body>
  <div class="navbar">
  <a class="active" href="customerhome.jsp"><i class="fa fa-fw fa-home"></i> Home</a> 
  <a href="transaction.jsp"><i class="fa fa-fw fa-search"></i> View Transactions</a> 
  <a href="AddT.jsp"><i class="fa fa-fw fa-envelope"></i> Make Transaction</a> 
  
  <a href="Login.html"><i class="fa fa-fw fa-user"></i> Logout</a>
</div>
<br><br>

<%
String Trans_ID = request.getParameter("ID");
DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
String formattedDate = df.format(new Date());
String url = "jdbc:mysql://localhost:3306/bankinfo";
String user = "salsabil";
String password = "123";
Connection Con = null;
ResultSet RS = null;
ResultSet RS1 = null;
ResultSet RS2 = null;
ResultSet RS3= null;
ResultSet RS4= null;
int x=0;
String msg="";
String ID = request.getSession().getAttribute("ID").toString();
String Acc_ID=request.getSession().getAttribute("Account_ID").toString();
Con = DriverManager.getConnection(url, user, password);


PreparedStatement ps6=Con.prepareStatement("select * from banktransaction where BA_Id=? ");
ps6.setString(1,Acc_ID);                   
RS4=ps6.executeQuery(); 
if(!RS4.next()){

	out.print("<div class='msg'>");
	out.print("<p>You Didn't make any Transaction yet</p>");
out.print("</div>");
}else{%>
	
	<form action="cancelTransfer.jsp" method="get">
	<div class="container">
	<label>Enter Transaction ID :</label>
	<input type="number" name="ID"><br>
	<button>Cancel</button>
	   
	  </div>
	  </form>
	  <% 
if(Trans_ID!=null){
PreparedStatement ps=Con.prepareStatement("select BTCreationDate,BTAmount,BTToAccount from banktransaction where BankTransactionID=? ");
ps.setString(1,Trans_ID);                   
RS=ps.executeQuery(); 

if(RS.next()){	
	
	String date=RS.getString("BTCreationDate");


	String format = "yyyy-MM-dd";
	 
	SimpleDateFormat sdf = new SimpleDateFormat(format);

	Date dateObj1 = sdf.parse(formattedDate);
	Date dateObj2 = sdf.parse(date);


	DecimalFormat crunchifyFormatter = new DecimalFormat("###,###");
	long diff = dateObj1.getTime() - dateObj2.getTime();

	int diffDays = (int) (diff / (24 * 60 * 60 * 1000));

if(diffDays>1){
	out.print("<div class='msg'>");

	out.print("<p>transaction is rejected: system does not allow to confirm cancel</p>");
	out.print("</div>");

}	
else{

	String amountS=RS.getString("BTAmount");
		String ID_TO=RS.getString("BTToAccount");
		
		PreparedStatement ps1=Con.prepareStatement("select * from bankaccount where customer_id=?");

		ps1.setString(1, ID);
		RS1=ps1.executeQuery(); 

	if(RS1.next()){	
		
	String balanceF=RS1.getString("BACurrentBalance");
	PreparedStatement ps2=Con.prepareStatement("select * from bankaccount where customer_id=?");
	ps2.setString(1, ID_TO);
	RS2=ps2.executeQuery();
	if(RS2.next()){
		
	String balanceT=RS2.getString("BACurrentBalance");
	int balanceTo=Integer.parseInt(balanceT);
	int balanceFrom=Integer.parseInt(balanceF);
	int amount=Integer.parseInt(amountS);

	balanceFrom=balanceFrom+amount;
	balanceTo=balanceTo-amount;
	
	PreparedStatement ps4=Con.prepareStatement(	"UPDATE `bankaccount` SET `BACurrentBalance`=? where `customer_id`=?");

	ps4.setInt(1,balanceTo);
	ps4.setString(2,ID_TO);
	ps4.executeUpdate();
	PreparedStatement ps5=Con.prepareStatement(	"UPDATE `bankaccount` SET `BACurrentBalance`=? where `customer_id`=?");

	ps5.setInt(1,balanceFrom);
	ps5.setString(2,ID);
	int x5=ps5.executeUpdate();

	
	}}
	PreparedStatement ps3=Con.prepareStatement("DELETE FROM banktransaction WHERE BankTransactionID = ?");
	
	ps3.setString(1, Trans_ID);
	x=ps3.executeUpdate();
	if(x!=0){
	 response.sendRedirect("transaction.jsp?cancle=transaction Cancel Successfully");
	}else{
		 response.sendRedirect("transaction.jsp?cancle=transaction Can't Deleted");

	}
		
	
	
	
}}
else{
	out.print("<div class='msg'>");
	out.print("<p>No such ID</p>");
	out.print("</div>");

}
}
}

%>




</body>
</html>