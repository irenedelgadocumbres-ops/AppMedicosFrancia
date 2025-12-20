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

@WebServlet(name = "ActualizarCitaServlet", urlPatterns = {"/ActualizarCitaServlet"})
public class ActualizarCitaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App";

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            String sql = "UPDATE citas SET usuario=?, fecha=?, hora=?, lugar=?, medico=?, observaciones=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("usuario"));
            ps.setString(2, request.getParameter("fecha"));
            ps.setString(3, request.getParameter("hora"));
            ps.setString(4, request.getParameter("lugar"));
            ps.setString(5, request.getParameter("medico"));
            ps.setString(6, request.getParameter("observaciones"));
            ps.setInt(7, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            conn.close();
            response.sendRedirect("admin_panel.jsp");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}