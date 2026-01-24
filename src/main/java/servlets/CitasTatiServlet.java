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
        List<CitaTati> pendientes = new ArrayList<>();
        List<CitaTati> historial = new ArrayList<>();
        LocalDate hoy = LocalDate.now();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // BORRAR
            if ("borrar".equals(accion) && idStr != null) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM citas_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                conn.close();
                response.sendRedirect("CitasTatiServlet");
                return;
            }

            // LEER
            String sql = "SELECT * FROM citas_tati ORDER BY fecha ASC, hora ASC";
            ResultSet rs = conn.createStatement().executeQuery(sql);

            while (rs.next()) {
                Date fechaSql = rs.getDate("fecha");
                CitaTati c = new CitaTati(
                    rs.getInt("id"), fechaSql, rs.getString("hora"),
                    rs.getString("especialista"), rs.getString("lugar"),
                    rs.getString("observaciones")
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
            request.getRequestDispatcher("vista_medicos_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            String sql = "INSERT INTO citas_tati (fecha, hora, especialista, lugar, observaciones) VALUES (?::date, ?::time, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("fecha"));
            ps.setString(2, request.getParameter("hora"));
            ps.setString(3, request.getParameter("especialista"));
            ps.setString(4, request.getParameter("lugar"));
            ps.setString(5, request.getParameter("observaciones"));
            
            ps.executeUpdate();
            conn.close();
            response.sendRedirect("CitasTatiServlet");
        } catch (Exception e) { e.printStackTrace(); }
    }
}
