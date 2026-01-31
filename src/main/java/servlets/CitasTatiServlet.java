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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import logica.CitaTati;

@WebServlet(name = "CitasTatiServlet", urlPatterns = {"/CitasTatiServlet"})
public class CitasTatiServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");
        
        String personaActual = request.getParameter("persona");
        if (personaActual == null || personaActual.isEmpty()) {
            personaActual = "Tati";
        }

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // 1. BORRAR
            if ("borrar".equals(accion) && idStr != null) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM citas_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                conn.close();
                response.sendRedirect("CitasTatiServlet?persona=" + personaActual);
                return;
            }
            
            // 2. EDITAR (CARGAR DATOS) - NUEVO BLOQUE
            if ("editar".equals(accion) && idStr != null) {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM citas_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    CitaTati citaEditar = new CitaTati(
                        rs.getInt("id"), rs.getDate("fecha"), rs.getString("hora"),
                        rs.getString("especialista"), rs.getString("lugar"),
                        rs.getString("observaciones"), rs.getString("persona")
                    );
                    request.setAttribute("citaEditar", citaEditar);
                }
            }

            // 3. LEER LISTAS
            List<CitaTati> pendientes = new ArrayList<>();
            List<CitaTati> historial = new ArrayList<>();
            LocalDate hoy = LocalDate.now();

            String sql = "SELECT * FROM citas_tati WHERE persona = ? ORDER BY fecha ASC, hora ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, personaActual);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CitaTati c = new CitaTati(
                    rs.getInt("id"), rs.getDate("fecha"), rs.getString("hora"),
                    rs.getString("especialista"), rs.getString("lugar"),
                    rs.getString("observaciones"), rs.getString("persona")
                );
                
                if(c.getFecha().toLocalDate().isBefore(hoy)) {
                    historial.add(c);
                } else {
                    pendientes.add(c);
                }
            }
            conn.close();

            request.setAttribute("listaPendientes", pendientes);
            request.setAttribute("listaHistorial", historial);
            request.setAttribute("personaActual", personaActual);
            
            request.getRequestDispatcher("vista_medicos_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String persona = request.getParameter("persona");
        String idStr = request.getParameter("id"); // Verificar si estamos editando
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            if (idStr != null && !idStr.isEmpty()) {
                // ACTUALIZAR (UPDATE)
                String sql = "UPDATE citas_tati SET fecha=?::date, hora=?::time, especialista=?, lugar=?, observaciones=?, persona=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("fecha"));
                ps.setString(2, request.getParameter("hora"));
                ps.setString(3, request.getParameter("especialista"));
                ps.setString(4, request.getParameter("lugar"));
                ps.setString(5, request.getParameter("observaciones"));
                ps.setString(6, persona);
                ps.setInt(7, Integer.parseInt(idStr));
                ps.executeUpdate();
            } else {
                // CREAR NUEVO (INSERT)
                String sql = "INSERT INTO citas_tati (fecha, hora, especialista, lugar, observaciones, persona) VALUES (?::date, ?::time, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("fecha"));
                ps.setString(2, request.getParameter("hora"));
                ps.setString(3, request.getParameter("especialista"));
                ps.setString(4, request.getParameter("lugar"));
                ps.setString(5, request.getParameter("observaciones"));
                ps.setString(6, persona);
                ps.executeUpdate();
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("CitasTatiServlet?persona=" + persona);
    }
}