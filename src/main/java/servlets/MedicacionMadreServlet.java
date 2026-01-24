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
import logica.MedicamentoMadre;

@WebServlet(name = "MedicacionMadreServlet", urlPatterns = {"/MedicacionMadreServlet"})
public class MedicacionMadreServlet extends HttpServlet {

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

            // 1. Borrar
            if ("borrar".equals(accion) && idStr != null) {
                String sql = "DELETE FROM medicacion_madre WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                response.sendRedirect("MedicacionMadreServlet");
                conn.close();
                return;
            }

            // 2. Preparar Edición (Cargar los datos de una medicina en el formulario)
            if ("editar".equals(accion) && idStr != null) {
                String sql = "SELECT * FROM medicacion_madre WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    MedicamentoMadre med = new MedicamentoMadre(
                        rs.getInt("id"), rs.getString("nombre"), 
                        rs.getString("dosis"), rs.getString("horario"), 
                        rs.getString("observaciones")
                    );
                    request.setAttribute("medEditar", med);
                }
            }

            // 3. Listar todas
            List<MedicamentoMadre> lista = new ArrayList<>();
            String sql = "SELECT * FROM medicacion_madre ORDER BY nombre ASC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(new MedicamentoMadre(
                    rs.getInt("id"), rs.getString("nombre"), 
                    rs.getString("dosis"), rs.getString("horario"), 
                    rs.getString("observaciones")
                ));
            }
            conn.close();
            request.setAttribute("misMedicinas", lista);
            request.getRequestDispatcher("vista_medicacion_madre.jsp").forward(request, response);
            
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String dosis = request.getParameter("dosis");
        String observaciones = request.getParameter("observaciones");
        
        String[] horariosMarcados = request.getParameterValues("horarios");
        String horarioFinal = (horariosMarcados != null) ? String.join(", ", horariosMarcados) : "No definido";

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            if (idStr != null && !idStr.isEmpty()) {
                // ACTUALIZAR
                String sql = "UPDATE medicacion_madre SET nombre=?, dosis=?, horario=?, observaciones=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, nombre);
                ps.setString(2, dosis);
                ps.setString(3, horarioFinal);
                ps.setString(4, observaciones);
                ps.setInt(5, Integer.parseInt(idStr));
                ps.executeUpdate();
            } else {
                // INSERTAR NUEVO
                String sql = "INSERT INTO medicacion_madre (nombre, dosis, horario, observaciones) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, nombre);
                ps.setString(2, dosis);
                ps.setString(3, horarioFinal);
                ps.setString(4, observaciones);
                ps.executeUpdate();
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("MedicacionMadreServlet");
    }
}
