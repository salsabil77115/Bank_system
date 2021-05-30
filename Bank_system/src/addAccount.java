

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addAccount")

public class addAccount extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addAccount() {
        super();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
      PrintWriter out = response.getWriter();
       HttpSession session=request.getSession();  

            try {
            	
              String ID = request.getSession().getAttribute("ID").toString();
            	 String url = "jdbc:mysql://localhost:3306/bankinfo";
            	 String user = "salsabil";
            	 String password = "123";
            	     Connection Con = null;  
            	     int x=0;
            	     String msg="";
            	     Con = DriverManager.getConnection(url, user, password);
            	      Random rand = new Random();
            	     int n = rand.nextInt(90000) + 10000;    
            	 
            	    session.setAttribute("Account_ID",n); 
            	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            	    String formattedDate = df.format(new Date());
            	    
            	    String query = "INSERT INTO `bankaccount` (`BankAccountID`, `BACreationDate`, `BACurrentBalance`, `customer_id`)"
            	    	        + " values (?, ?, ?, ?)";
            	    
            	     PreparedStatement preparedStmt = Con.prepareStatement(query);

            	    preparedStmt.setInt(1, n);
            	     preparedStmt.setString(2, formattedDate);
            	     preparedStmt.setInt  (3, 1000);
            	    preparedStmt.setString(4, ID);


            	     x=preparedStmt.executeUpdate();
            	     if(x!=0){
            	    response.sendRedirect("customerhome.jsp?add=add successfully");
            	    }
            	     else {

            	    	   response.sendRedirect("customerhome.jsp?add=Field make new account");
            	     }
            	     Con.close();

                 } catch (Exception e) {
                	 e.printStackTrace();
                	 }
            finally{out.close();}


                	 }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
	}

}
