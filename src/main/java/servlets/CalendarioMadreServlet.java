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
import logica.EventoMadre;

@WebServlet(name = "CalendarioMadreServlet", urlPatterns = {"/CalendarioMadreServlet"})
public class CalendarioMadreServlet extends HttpServlet {

    String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    String dbUser = "postgres.amzippkmiwiymeeeuono";
    String dbPass = "Abuelos2025App"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<EventoMadre> listaEventos = new ArrayList<>();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            Statement st = conn.createStatement();

            // 1. OBTENER CITAS MÉDICAS (Tabla citas_madre)
            // Asumimos que la tabla se llama 'citas_madre' y tiene columnas 'fecha' y 'titulo'
            // Si tu tabla se llama distinto (ej: agenda_madre), cámbialo aquí.
            ResultSet rsCitas = st.executeQuery("SELECT fecha, titulo, hora FROM citas_madre");
            while(rsCitas.next()) {
                String texto = "🩺 " + rsCitas.getString("titulo") + " (" + rsCitas.getString("hora") + ")";
                listaEventos.add(new EventoMadre(
                    rsCitas.getDate("fecha"), 
                    texto, 
                    "CITA"
                ));
            }

            // 2. OBTENER AVISOS FARMACIA (Tabla farmacia_madre)
            ResultSet rsFarma = st.executeQuery("SELECT proxima_recogida FROM farmacia_madre WHERE proxima_recogida IS NOT NULL");
            while(rsFarma.next()) {
                listaEventos.add(new EventoMadre(
                    rsFarma.getDate("proxima_recogida"), 
                    "🏥 Toca ir a la Farmacia", 
                    "FARMACIA"
                ));
            }
            
            conn.close();

            // Enviamos la lista mezclada al JSP
            request.setAttribute("listaEventos", listaEventos);
            request.getRequestDispatcher("vista_calendario_madre.jsp").forward(request, response);

        } catch (Exception e) { 
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage()); 
        }
    }
}