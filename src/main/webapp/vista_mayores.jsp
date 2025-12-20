<%-- 
    Document   : vista_mayores
    Created on : 20 dic 2025, 12:49:45
    Author     : Asus
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas Médicas</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #eef2f7; text-align: center; padding: 20px; }
        .header { background-color: #1a73e8; color: white; padding: 20px; border-radius: 15px; margin-bottom: 25px; }
        .cita-card { background: white; margin: 15px auto; padding: 20px; width: 90%; max-width: 500px; 
                     border-radius: 20px; box-shadow: 0 6px 12px rgba(0,0,0,0.1); border-left: 10px solid #34a853; text-align: left; }
        h1 { font-size: 28px; margin: 0; }
        .dato { font-size: 20px; margin: 10px 0; color: #333; }
        .etiqueta { font-weight: bold; color: #1a73e8; display: block; font-size: 16px; text-transform: uppercase; }
        .notas { background: #fffde7; padding: 10px; border-radius: 8px; margin-top: 10px; font-style: italic; }
    </style>
</head>
<body>
    <div class="header">
        <h1>👵 Mis Citas Médicas 👴</h1>
    </div>

    <%
        // DATOS DE FRANCIA
        String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
        String dbUser = "postgres.amzippkmiwiymeeeuono";
        String dbPass = "Abuelos2025App"; // <--- CAMBIA ESTO

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            // Solo mostramos citas de "Abuelo" y "Abuela"
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM citas WHERE usuario IN ('Abuelo', 'Abuela') ORDER BY fecha ASC");
            ResultSet rs = ps.executeQuery();
            
            boolean hayCitas = false;
            while(rs.next()){
                hayCitas = true;
    %>
    <div class="cita-card">
        <div class="dato"><span class="etiqueta">📅 Cuándo:</span> <%= rs.getString("fecha") %> a las <%= rs.getString("hora") %></div>
        <div class="dato"><span class="etiqueta">🏥 Dónde:</span> <%= rs.getString("lugar") %></div>
        <div class="dato"><span class="etiqueta">👨‍⚕️ Médico:</span> <%= rs.getString("medico") %></div>
        <% if(rs.getString("observaciones") != null && !rs.getString("observaciones").isEmpty()) { %>
            <div class="notas"><strong>Nota:</strong> <%= rs.getString("observaciones") %></div>
        <% } %>
    </div>
    <% 
            }
            if(!hayCitas) {
                out.println("<h2>No tienes citas próximas. ¡A descansar! 😊</h2>");
            }
            conn.close();
        } catch(Exception e) {
            out.println("<p>Error al cargar las citas.</p>");
        }
    %>
</body>
</html>
