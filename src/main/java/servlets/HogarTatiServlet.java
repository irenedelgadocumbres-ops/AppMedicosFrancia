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
import logica.GestionTati;

@WebServlet(name = "HogarTatiServlet", urlPatterns = {"/HogarTatiServlet"})
public class HogarTatiServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // BORRAR
            if ("borrar".equals(accion) && idStr != null) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM gestion_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            }

            // LEER (Ordenado por fecha para ver qué vence antes)
            List<GestionTati> lista = new ArrayList<>();
            String sql = "SELECT * FROM gestion_tati ORDER BY fecha_renovacion ASC NULLS LAST";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(new GestionTati(
                    rs.getInt("id"), rs.getString("categoria"),
                    rs.getString("titulo"), rs.getString("compania"),
                    rs.getString("telefono_contacto"), rs.getDate("fecha_renovacion"),
                    rs.getDouble("importe"), rs.getString("observaciones")
                ));
            }
            conn.close();
            
            request.setAttribute("listaHogar", lista);
            request.getRequestDispatcher("vista_hogar_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String fechaStr = request.getParameter("fecha_renovacion");
        Date fecha = (fechaStr != null && !fechaStr.isEmpty()) ? Date.valueOf(fechaStr) : null;
        
        String importeStr = request.getParameter("importe");
        double importe = (importeStr != null && !importeStr.isEmpty()) ? Double.parseDouble(importeStr) : 0.0;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            String sql = "INSERT INTO gestion_tati (categoria, titulo, compania, telefono_contacto, fecha_renovacion, importe, observaciones) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, request.getParameter("categoria"));
            ps.setString(2, request.getParameter("titulo"));
            ps.setString(3, request.getParameter("compania"));
            ps.setString(4, request.getParameter("telefono_contacto"));
            ps.setDate(5, fecha);
            ps.setDouble(6, importe);
            ps.setString(7, request.getParameter("observaciones"));
            
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("HogarTatiServlet");
    }
}
