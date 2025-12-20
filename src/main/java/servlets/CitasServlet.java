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

@WebServlet(name = "CitasServlet", urlPatterns = {"/CitasServlet"})
public class CitasServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recoger datos del formulario
        String usuario = request.getParameter("usuario");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String lugar = request.getParameter("lugar");
        String medico = request.getParameter("medico");
        String observaciones = request.getParameter("observaciones");

        // 2. Conexión a tu proyecto en Francia (Pooler IPv4)
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; // <--- CAMBIA ESTO

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // 3. Orden para guardar
            String sql = "INSERT INTO citas (usuario, fecha, hora, lugar, medico, observaciones) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, fecha);
            ps.setString(3, hora);
            ps.setString(4, lugar);
            ps.setString(5, medico);
            ps.setString(6, observaciones);
            
            ps.executeUpdate();
            conn.close();
            
            // 4. Volver al panel de administración
            response.sendRedirect("admin_panel.jsp");
            
        } catch (Exception e) {
            response.getWriter().println("Error al guardar: " + e.getMessage());
        }
    }
}