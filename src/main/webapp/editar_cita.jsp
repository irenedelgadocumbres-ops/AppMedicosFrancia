<%-- 
    Document   : editar_cita
    Created on : 20 dic 2025, 12:50:04
    Author     : Asus
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Modificar Cita</title>
    <style>
        body { font-family: Arial; background-color: #f4f4f4; padding: 40px; }
        .box { background: white; padding: 20px; max-width: 500px; margin: auto; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        input { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; }
        button { background: #1a73e8; color: white; border: none; padding: 10px 20px; cursor: pointer; width: 100%; }
    </style>
</head>
<body>
    <div class="box">
        <h2>✏️ Modificar Cita</h2>
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
            String dbUser = "postgres.amzippkmiwiymeeeuono";
            String dbPass = "Abuelos2025App";

            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM citas WHERE id = ?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
        %>
        <form action="ActualizarCitaServlet" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            <input type="text" name="usuario" value="<%= rs.getString("usuario") %>" required>
            <input type="date" name="fecha" value="<%= rs.getString("fecha") %>" required>
            <input type="time" name="hora" value="<%= rs.getString("hora") %>" required>
            <input type="text" name="lugar" value="<%= rs.getString("lugar") %>" required>
            <input type="text" name="medico" value="<%= rs.getString("medico") %>" required>
            <input type="text" name="observaciones" value="<%= rs.getString("observaciones") %>">
            <button type="submit">ACTUALIZAR DATOS</button>
        </form>
        <% } conn.close(); } catch(Exception e) { out.println("Error: " + e.getMessage()); } %>
    </div>
</body>
</html>