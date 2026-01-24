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
import logica.MascotaTati;

@WebServlet(name = "MascotasTatiServlet", urlPatterns = {"/MascotasTatiServlet"})
public class MascotasTatiServlet extends HttpServlet {

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

            // BORRAR EVENTO
            if ("borrar".equals(accion) && idStr != null) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM mascotas_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            }

            // LEER HISTORIAL (Lo más reciente arriba)
            List<MascotaTati> lista = new ArrayList<>();
            String sql = "SELECT * FROM mascotas_tati ORDER BY fecha DESC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(new MascotaTati(
                    rs.getInt("id"), rs.getString("nombre_mascota"),
                    rs.getDate("fecha"), rs.getString("tipo_evento"),
                    rs.getString("producto"), rs.getString("observaciones"),
                    rs.getDate("proxima_fecha")
                ));
            }
            conn.close();
            
            request.setAttribute("historialMascotas", lista);
            request.getRequestDispatcher("vista_mascotas_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String proxima = request.getParameter("proxima_fecha");
        Date fechaProx = (proxima != null && !proxima.isEmpty()) ? Date.valueOf(proxima) : null;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            String sql = "INSERT INTO mascotas_tati (nombre_mascota, fecha, tipo_evento, producto, observaciones, proxima_fecha) VALUES (?, ?::date, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, request.getParameter("nombre_mascota"));
            ps.setString(2, request.getParameter("fecha"));
            ps.setString(3, request.getParameter("tipo_evento"));
            ps.setString(4, request.getParameter("producto"));
            ps.setString(5, request.getParameter("observaciones"));
            ps.setDate(6, fechaProx); // Puede ser null si no hay aviso
            
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("MascotasTatiServlet");
    }
}
