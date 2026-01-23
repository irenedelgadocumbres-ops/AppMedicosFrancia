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
import logica.Medicina;

@WebServlet(name = "MedicinasServlet", urlPatterns = {"/MedicinasServlet"})
public class MedicinasServlet extends HttpServlet {

    // DATOS DE CONEXIÓN
    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    // --- GUARDAR O ACTUALIZAR (doPost) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Recogemos datos
        String idStr = request.getParameter("id"); // ¿Viene un ID? (Si viene, es editar)
        String usuario = request.getParameter("usuario");
        String nombre = request.getParameter("nombre");
        String dosis = request.getParameter("dosis");
        String paraQue = request.getParameter("para_que");
        
        String[] momentosSeleccionados = request.getParameterValues("momento");
        String momentoFinal = (momentosSeleccionados != null) ? String.join(" + ", momentosSeleccionados) : "Sin especificar";

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            if (idStr != null && !idStr.isEmpty()) {
                // --- ES UNA ACTUALIZACIÓN (UPDATE) ---
                String sql = "UPDATE medicinas SET usuario=?, nombre=?, dosis=?, momento=?, para_que=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, usuario);
                ps.setString(2, nombre);
                ps.setString(3, dosis);
                ps.setString(4, momentoFinal);
                ps.setString(5, paraQue);
                ps.setInt(6, Integer.parseInt(idStr)); // Usamos el ID para saber cuál cambiar
                ps.executeUpdate();
                
            } else {
                // --- ES UNA MEDICINA NUEVA (INSERT) ---
                String sql = "INSERT INTO medicinas (usuario, nombre, dosis, momento, para_que) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, usuario);
                ps.setString(2, nombre);
                ps.setString(3, dosis);
                ps.setString(4, momentoFinal);
                ps.setString(5, paraQue);
                ps.executeUpdate();
            }
            
            conn.close();
            response.sendRedirect("MedicinasServlet"); // Volver a la lista
            
        } catch (Exception e) {
            response.getWriter().println("Error al guardar: " + e.getMessage());
        }
    }

    // --- LEER, BORRAR O PREPARAR EDICIÓN (doGet) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // 1. CASO BORRAR
            if ("borrar".equals(accion) && idStr != null) {
                String sql = "DELETE FROM medicinas WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                conn.close();
                response.sendRedirect("MedicinasServlet"); // Recargar página
                return;
            }

            // 2. CASO EDITAR (Cargar datos y mandar a formulario de edición)
            if ("editar".equals(accion) && idStr != null) {
                String sql = "SELECT * FROM medicinas WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Medicina m = new Medicina(
                        rs.getInt("id"), rs.getString("usuario"), rs.getString("nombre"),
                        rs.getString("dosis"), rs.getString("momento"), rs.getString("para_que")
                    );
                    conn.close();
                    request.setAttribute("medicinaEditar", m);
                    request.getRequestDispatcher("editar_medicina.jsp").forward(request, response);
                    return;
                }
            }

            // 3. CASO NORMAL: LISTAR TODO
            List<Medicina> listaAbuelo = new ArrayList<>();
            List<Medicina> listaAbuela = new ArrayList<>();
            
            String sql = "SELECT * FROM medicinas ORDER BY id ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Medicina m = new Medicina(
                    rs.getInt("id"), rs.getString("usuario"), rs.getString("nombre"),
                    rs.getString("dosis"), rs.getString("momento"), rs.getString("para_que")
                );
                if ("Abuelo".equalsIgnoreCase(m.getUsuario())) listaAbuelo.add(m);
                else listaAbuela.add(m);
            }
            conn.close();

            request.setAttribute("medsAbuelo", listaAbuelo);
            request.setAttribute("medsAbuela", listaAbuela);
            request.getRequestDispatcher("vista_medicinas.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}