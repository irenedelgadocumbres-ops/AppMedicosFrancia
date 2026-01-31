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
import logica.EventoTati;

@WebServlet(name = "CalendarioTatiServlet", urlPatterns = {"/CalendarioTatiServlet"})
public class CalendarioTatiServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<EventoTati> listaTotal = new ArrayList<>();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            Statement st = conn.createStatement();

            // 1. MÉDICOS (Con Observaciones)
            ResultSet rs1 = st.executeQuery("SELECT fecha, especialista, lugar, hora, observaciones, persona FROM citas_tati");
            while(rs1.next()) {
                String persona = rs1.getString("persona");
                if(persona == null) persona = "Tati";
                
                String titulo = "🩺 " + rs1.getString("especialista");
                // Juntamos Hora y Lugar en el subtítulo
                String subtitulo = "⏰ " + rs1.getString("hora") + " | 📍 " + rs1.getString("lugar");
                String notas = rs1.getString("observaciones");
                
                String tipoEvento = "MEDICO_" + persona.toUpperCase(); 
                
                listaTotal.add(new EventoTati(rs1.getDate("fecha"), titulo, subtitulo, notas, tipoEvento));
            }

            // 2. MASCOTAS
            ResultSet rs2 = st.executeQuery("SELECT proxima_fecha, nombre_mascota, tipo_evento, producto, observaciones FROM mascotas_tati WHERE proxima_fecha IS NOT NULL");
            while(rs2.next()) {
                String titulo = "🐾 " + rs2.getString("nombre_mascota");
                String subtitulo = "Toca: " + rs2.getString("tipo_evento");
                // En notas ponemos el producto y las observaciones
                String notas = (rs2.getString("producto") != null ? rs2.getString("producto") : "") + 
                               (rs2.getString("observaciones") != null ? " (" + rs2.getString("observaciones") + ")" : "");
                
                listaTotal.add(new EventoTati(rs2.getDate("proxima_fecha"), titulo, subtitulo, notas, "MASCOTA"));
            }

            // 3. HOGAR
            ResultSet rs3 = st.executeQuery("SELECT fecha_renovacion, titulo, importe, observaciones FROM gestion_tati WHERE fecha_renovacion IS NOT NULL");
            while(rs3.next()) {
                String titulo = "🏠 " + rs3.getString("titulo");
                String subtitulo = (rs3.getDouble("importe") > 0) ? "💰 " + rs3.getDouble("importe") + " €" : "Revisar";
                String notas = rs3.getString("observaciones");
                
                listaTotal.add(new EventoTati(rs3.getDate("fecha_renovacion"), titulo, subtitulo, notas, "HOGAR"));
            }
            
            conn.close();

            request.setAttribute("listaTotal", listaTotal);
            request.getRequestDispatcher("vista_calendario_tati.jsp").forward(request, response);

        } catch (Exception e) { response.getWriter().println("Error: " + e.getMessage()); }
    }
}