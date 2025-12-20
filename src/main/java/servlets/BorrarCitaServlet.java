/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "BorrarCitaServlet", urlPatterns = {"/BorrarCitaServlet"})
public class BorrarCitaServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));

        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; // <--- CAMBIA ESTO

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            PreparedStatement ps = conn.prepareStatement("DELETE FROM citas WHERE id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            
            conn.close();
            response.sendRedirect("admin_panel.jsp");
            
        } catch (Exception e) {
            response.getWriter().println("Error al borrar: " + e.getMessage());
        }
    }
}