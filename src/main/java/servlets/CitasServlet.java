/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate; // Para manejar las fechas
import java.util.ArrayList; // Para las listas
import java.util.List;
import logica.Cita; // <--- ASEGÚRATE QUE TU CLASE CITA ESTÁ EN ESTE PAQUETE

@WebServlet(name = "CitasServlet", urlPatterns = {"/CitasServlet"})
public class CitasServlet extends HttpServlet {

    // 1. MÉTODO PARA GUARDAR (LO QUE YA TENÍAS)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Recoger datos del formulario
        String usuario = request.getParameter("usuario");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String lugar = request.getParameter("lugar");
        if ("Otro".equals(lugar)) { lugar = request.getParameter("lugar_otro"); }
        String medico = request.getParameter("medico");
        if ("Otro".equals(medico)) { medico = request.getParameter("medico_otro"); }
        String observaciones = request.getParameter("observaciones");

        // Conexión a tu proyecto en Francia (Pooler IPv4)
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; 

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // Orden para guardar con el CAST de fecha y hora
            String sql = "INSERT INTO citas (usuario, fecha, hora, lugar, medico, observaciones) VALUES (?, ?::date, ?::time, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, fecha);
            ps.setString(3, hora);
            ps.setString(4, lugar);
            ps.setString(5, medico);
            ps.setString(6, observaciones);
            
            ps.executeUpdate();
            conn.close();
            
            // Volver al panel de administración
            response.sendRedirect("admin_panel.jsp");
            
        } catch (Exception e) {
            response.getWriter().println("Error al guardar: " + e.getMessage());
        }
    }

    // 2. MÉTODO PARA LEER Y SEPARAR CITAS (LO NUEVO)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Listas para separar el pasado del futuro
        List<Cita> listaPendientes = new ArrayList<>();
        List<Cita> listaHistorial = new ArrayList<>();
        LocalDate hoy = LocalDate.now();

        // Datos de conexión
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; 

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Seleccionamos TODAS las citas ordenadas por fecha
            String sql = "SELECT * FROM citas ORDER BY fecha ASC, hora ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Recuperamos datos de la base de datos
                int id = rs.getInt("id");
                String usuario = rs.getString("usuario");
                Date sqlDate = rs.getDate("fecha"); // Fecha SQL
                String hora = rs.getString("hora"); // La hora la tratamos como String para visualización o Time según tu clase
                String lugar = rs.getString("lugar");
                String medico = rs.getString("medico");
                String observaciones = rs.getString("observaciones");
                
                // Convertimos la fecha SQL a LocalDate para comparar
                LocalDate fechaCita = sqlDate.toLocalDate();
                
                // Creamos el objeto Cita
                // NOTA: Asegúrate que el constructor de tu clase Cita coincida con esto:
                Cita c = new Cita(id, usuario, sqlDate, hora, lugar, medico, observaciones);

                // --- AQUÍ ESTÁ LA MAGIA DE LA SEPARACIÓN ---
                if (fechaCita.isBefore(hoy)) {
                    // Si es anterior a hoy -> Al Historial
                    listaHistorial.add(c);
                } else {
                    // Si es hoy o futuro -> A Pendientes
                    listaPendientes.add(c);
                }
            }
            conn.close();

            // Enviamos las dos listas al JSP
            request.setAttribute("misCitas", listaPendientes);
            request.setAttribute("historialCitas", listaHistorial);

            // Redirigimos a la vista de mayores para mostrar los datos
            request.getRequestDispatcher("vista_mayores.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error al leer las citas: " + e.getMessage());
            e.printStackTrace();
        }
    }
}