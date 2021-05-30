/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.*;

/**
 *
 * @author ahmed
 */
@WebServlet(urlPatterns = {"/Validate"})
public class Validate extends HttpServlet {


	private static final long serialVersionUID = 1L;


	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
      PrintWriter out = response.getWriter();
            try {
         	   HttpSession session=request.getSession();  
            	String CustomerID = request.getParameter("ID");
            	String passwords = request.getParameter("pass");
            	String check=request.getParameter("remember");
            	 String url = "jdbc:mysql://localhost:3306/bankinfo";
                 String user = "salsabil";
                 String password = "123";
                     Connection Con = null;
                     ResultSet RS = null;
                     Con = DriverManager.getConnection(url, user, password);
                     PreparedStatement ps=Con.prepareStatement("select * from customer where CustomerID=? and password=?");

                     ps.setString(1,CustomerID);                   

                     ps.setString(2,passwords);                   

                     RS=ps.executeQuery();  
                     
                     if(RS.next()) { // Checks for any results and moves cursor to first row,
                    
                    	 
                             session.setAttribute("ID",CustomerID); 
                             if(check.equals("on")) {
                            	 Cookie username = new Cookie("Customer",CustomerID);
                            	 username.setMaxAge(2*365*24*60*60);
                            	 response.addCookie(username);}                 
                      response.sendRedirect("customerhome.jsp?msg=Login successfully!!");                   
                     }else {
                    	 response.sendRedirect("Login.html?msg=Login fialed");
                     }
                     Con.close();       
                 } catch (Exception e) {
                	 e.printStackTrace();
                	 }
            finally{out.close();}


                	 }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }

}


        
          