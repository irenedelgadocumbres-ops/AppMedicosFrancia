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
import logica.CitaMadre;

@WebServlet(name = "AgendaMadreServlet", urlPatterns = {"/AgendaMadreServlet"})
public class AgendaMadreServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    // --- GUARDAR O ACTUALIZAR (doPost) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String tipo = request.getParameter("tipo");
        String idStr = request.getParameter("id"); // ¿Viene ID? Entonces es editar
        
        // Lógica del Desplegable "Otro"
        String titulo = request.getParameter("titulo");
        if ("Otro".equals(titulo)) { titulo = request.getParameter("titulo_otro"); }

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            if (idStr != null && !idStr.isEmpty()) {
                // --- ACTUALIZAR (UPDATE) ---
                String sql = "UPDATE agenda_madre SET fecha=?::date, hora=?::time, titulo=?, lugar=?, observaciones=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("fecha"));
                ps.setString(2, request.getParameter("hora"));
                ps.setString(3, titulo);
                ps.setString(4, request.getParameter("lugar"));
                ps.setString(5, request.getParameter("observaciones"));
                ps.setInt(6, Integer.parseInt(idStr));
                ps.executeUpdate();
                
            } else {
                // --- INSERTAR NUEVO (INSERT) ---
                String sql = "INSERT INTO agenda_madre (fecha, hora, titulo, lugar, categoria, observaciones) VALUES (?::date, ?::time, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("fecha"));
                ps.setString(2, request.getParameter("hora"));
                ps.setString(3, titulo);
                ps.setString(4, request.getParameter("lugar"));
                ps.setString(5, tipo); 
                ps.setString(6, request.getParameter("observaciones"));
                ps.executeUpdate();
            }
            conn.close();
            
            response.sendRedirect("AgendaMadreServlet?tipo=" + tipo);
            
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    // --- LEER, BORRAR O PREPARAR EDICIÓN (doGet) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String tipo = request.getParameter("tipo");
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        if(tipo == null) tipo = "Medico"; 

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // 1. CASO BORRAR
            if ("borrar".equals(accion) && idStr != null) {
                String sql = "DELETE FROM agenda_madre WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                conn.close();
                response.sendRedirect("AgendaMadreServlet?tipo=" + tipo);
                return;
            }

            // 2. CASO EDITAR (Cargar datos y mandarlos al formulario)
            if ("editar".equals(accion) && idStr != null) {
                String sql = "SELECT * FROM agenda_madre WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    CitaMadre c = new CitaMadre(
                        rs.getInt("id"), rs.getDate("fecha"), rs.getString("hora"),
                        rs.getString("titulo"), rs.getString("lugar"), rs.getString("categoria"),
                        rs.getString("observaciones")
                    );
                    request.setAttribute("citaEditar", c);
                    // No cerramos conexión ni retornamos, dejamos que siga para cargar la lista de abajo
                }
            }

            // 3. CARGAR LISTAS (PENDIENTES vs HISTORIAL)
            List<CitaMadre> pendientes = new ArrayList<>();
            List<CitaMadre> historial = new ArrayList<>();
            LocalDate hoy = LocalDate.now();

            String sql = "SELECT * FROM agenda_madre WHERE categoria=? ORDER BY fecha ASC, hora ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tipo);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Date fechaSql = rs.getDate("fecha");
                CitaMadre c = new CitaMadre(
                    rs.getInt("id"), fechaSql, rs.getString("hora"),
                    rs.getString("titulo"), rs.getString("lugar"),
                    rs.getString("categoria"), rs.getString("observaciones")
                );

                if(fechaSql.toLocalDate().isBefore(hoy)) {
                    historial.add(c);
                } else {
                    pendientes.add(c);
                }
            }
            conn.close();

            request.setAttribute("listaPendientes", pendientes);
            request.setAttribute("listaHistorial", historial);
            request.setAttribute("tipoActual", tipo); 

            request.getRequestDispatcher("vista_agenda_madre.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
