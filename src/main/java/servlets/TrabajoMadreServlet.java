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
import logica.DiaTrabajo;

@WebServlet(name = "TrabajoMadreServlet", urlPatterns = {"/TrabajoMadreServlet"})
public class TrabajoMadreServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        if ("borrar".equals(accion)) {
            borrarDia(request.getParameter("id"));
        }

        List<DiaTrabajo> lista = new ArrayList<>();
        
        // Contadores
        int cVacaciones = 0;
        int cMoscosos = 0;
        int cLibreDisp = 0;
        int cVerano = 0;
        boolean sanNicasio = false;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            // Ordenamos por fecha descendente (lo último arriba)
            ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM trabajo_madre ORDER BY fecha DESC");

            while (rs.next()) {
                String tipo = rs.getString("tipo");
                
                // Sumar a los contadores
                if(tipo.equals("VACACIONES")) cVacaciones++;
                if(tipo.equals("ASUNTOS PROPIOS")) cMoscosos++;
                if(tipo.equals("LIBRE DISPOSICION")) cLibreDisp++;
                if(tipo.equals("DIAS VERANO")) cVerano++;
                if(tipo.equals("SAN NICASIO")) sanNicasio = true;

                lista.add(new DiaTrabajo(
                    rs.getInt("id"), rs.getDate("fecha"), tipo,
                    rs.getString("subtipo"), rs.getString("observaciones")
                ));
            }
            conn.close();

        } catch (Exception e) { e.printStackTrace(); }

        // Pasamos datos y contadores a la vista
        request.setAttribute("listaTrabajo", lista);
        request.setAttribute("countVacaciones", cVacaciones);
        request.setAttribute("countMoscosos", cMoscosos);
        request.setAttribute("countLibre", cLibreDisp);
        request.setAttribute("countVerano", cVerano);
        request.setAttribute("checkSanNicasio", sanNicasio);

        request.getRequestDispatcher("vista_trabajo_madre.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            String sql = "INSERT INTO trabajo_madre (fecha, tipo, subtipo, observaciones) VALUES (?::date, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("fecha"));
            ps.setString(2, request.getParameter("tipo"));
            ps.setString(3, request.getParameter("subtipo"));
            ps.setString(4, request.getParameter("observaciones"));
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("TrabajoMadreServlet");
    }

    private void borrarDia(String idStr) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            PreparedStatement ps = conn.prepareStatement("DELETE FROM trabajo_madre WHERE id=?");
            ps.setInt(1, Integer.parseInt(idStr));
            ps.executeUpdate();
            conn.close();
        } catch(Exception e) {}
    }
}
