/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String clave = request.getParameter("clave");
        
        // LÓGICA DE REDIRECCIÓN SEGÚN LA CONTRASEÑA
        
        if ("medico".equals(clave)) { // Contraseña para los abuelos
            response.sendRedirect("CitasServlet"); // Les lleva a SU servlet
            
        } else if ("mama".equals(clave)) { // Contraseña para mamá
            // AQUÍ CREAREMOS EL NUEVO SERVLET DE MAMÁ MÁS ADELANTE
            // De momento la mandamos a una página en construcción
            response.sendRedirect("vista_madre.jsp"); 
            
        } else {
            // Contraseña incorrecta
            response.sendRedirect("index.html");
        }
    }
}