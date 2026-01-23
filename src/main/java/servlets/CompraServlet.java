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
import logica.Producto;

@WebServlet(name = "CompraServlet", urlPatterns = {"/CompraServlet"})
public class CompraServlet extends HttpServlet {

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

            // 1. Lógica de Borrado
            if ("borrar".equals(accion) && idStr != null) {
                String sql = "DELETE FROM lista_compra WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            }

            // 2. Leer lista completa (Ordenada por tienda)
            List<Producto> lista = new ArrayList<>();
            String sql = "SELECT * FROM lista_compra ORDER BY tienda ASC, id DESC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(new Producto(
                    rs.getInt("id"), 
                    rs.getString("producto"), 
                    rs.getString("tienda"), 
                    rs.getBoolean("comprado")
                ));
            }
            conn.close();

            request.setAttribute("miLista", lista);
            request.getRequestDispatcher("vista_compra_madre.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String nombre = request.getParameter("producto");
        String tienda = request.getParameter("tienda");
        if (tienda == null) tienda = "General";

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            String sql = "INSERT INTO lista_compra (producto, tienda) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, tienda);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("CompraServlet");
    }
}