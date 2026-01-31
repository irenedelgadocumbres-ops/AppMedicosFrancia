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
import logica.FarmaciaMadre;

@WebServlet(name = "FarmaciaMadreServlet", urlPatterns = {"/FarmaciaMadreServlet"})
public class FarmaciaMadreServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            if ("borrar".equals(accion)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM farmacia_madre WHERE id=?");
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                ps.executeUpdate();
            }

            List<FarmaciaMadre> lista = new ArrayList<>();
            // Ordenar por fecha de recogida descendente (lo más nuevo arriba)
            ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM farmacia_madre ORDER BY fecha_recogida DESC");
            while(rs.next()) {
                lista.add(new FarmaciaMadre(rs.getInt("id"), rs.getDate("fecha_recogida"), rs.getDate("proxima_recogida"), rs.getString("observaciones")));
            }
            conn.close();
            request.setAttribute("historialFarmacia", lista);
            request.getRequestDispatcher("vista_farmacia_madre.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println(e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String prox = request.getParameter("proxima_recogida");
        Date fechaProx = (prox != null && !prox.isEmpty()) ? Date.valueOf(prox) : null;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            PreparedStatement ps = conn.prepareStatement("INSERT INTO farmacia_madre (fecha_recogida, proxima_recogida, observaciones) VALUES (?::date, ?, ?)");
            ps.setString(1, request.getParameter("fecha_recogida"));
            ps.setDate(2, fechaProx);
            ps.setString(3, request.getParameter("observaciones"));
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("FarmaciaMadreServlet");
    }
}
