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
import java.util.ArrayList;
import java.util.List;
import logica.CitaMadre;

@WebServlet(name = "CalendarioMadreServlet", urlPatterns = {"/CalendarioMadreServlet"})
public class CalendarioMadreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<CitaMadre> listaTotal = new ArrayList<>();
        
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; 

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Traemos TODO (Médicos, Nali, Cuidados...) ordenado por hora
            String sql = "SELECT * FROM agenda_madre ORDER BY fecha ASC, hora ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                listaTotal.add(new CitaMadre(
                    rs.getInt("id"),
                    rs.getDate("fecha"),
                    rs.getString("hora"),
                    rs.getString("titulo"),
                    rs.getString("lugar"),
                    rs.getString("categoria"), // Esto es vital para el color
                    rs.getString("observaciones")
                ));
            }
            conn.close();

            request.setAttribute("listaTotal", listaTotal);
            request.getRequestDispatcher("vista_calendario_madre.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
