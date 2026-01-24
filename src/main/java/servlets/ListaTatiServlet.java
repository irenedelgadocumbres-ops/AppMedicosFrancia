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
import logica.ProductoTati;

@WebServlet(name = "ListaTatiServlet", urlPatterns = {"/ListaTatiServlet"})
public class ListaTatiServlet extends HttpServlet {

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
                PreparedStatement ps = conn.prepareStatement("DELETE FROM lista_tati WHERE id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            }

            // LEER (Ordenado por tienda para agrupar visualmente)
            List<ProductoTati> lista = new ArrayList<>();
            String sql = "SELECT * FROM lista_tati ORDER BY tienda ASC, id DESC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(new ProductoTati(
                    rs.getInt("id"), 
                    rs.getString("producto"), 
                    rs.getString("tienda"), 
                    rs.getBoolean("comprado")
                ));
            }
            conn.close();
            
            request.setAttribute("listaTati", lista);
            request.getRequestDispatcher("vista_lista_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String nombre = request.getParameter("producto");
        String tienda = request.getParameter("tienda"); // Capturamos la tienda elegida
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            String sql = "INSERT INTO lista_tati (producto, tienda) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, tienda);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("ListaTatiServlet");
    }
}
