/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "DatosServlet", urlPatterns = {"/DatosServlet"})
public class DatosServlet extends HttpServlet {
    
    // GUARDAR LOS DATOS (UPDATE)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String usuario = request.getParameter("usuario");
        String sip = request.getParameter("sip");
        String dni = request.getParameter("dni");
        String sangre = request.getParameter("sangre");
        String alergias = request.getParameter("alergias");
        String contacto = request.getParameter("contacto");

        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; 

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // Usamos UPDATE porque las filas ya las creamos en el Paso 1
            String sql = "UPDATE datos_vitales SET sip=?, dni=?, sangre=?, alergias=?, contacto=? WHERE usuario=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sip);
            ps.setString(2, dni);
            ps.setString(3, sangre);
            ps.setString(4, alergias);
            ps.setString(5, contacto);
            ps.setString(6, usuario);
            
            ps.executeUpdate();
            conn.close();
            
            // Volvemos al panel de citas
            response.sendRedirect("CitasServlet"); 
            
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
