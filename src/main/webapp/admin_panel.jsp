<%-- 
    Document   : admin_panel
    Created on : 20 dic 2025, 12:49:19
    Author     : Asus
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - Citas</title>
    <style>
        body { font-family: 'Segoe UI', Arial; background-color: #f0f2f5; padding: 30px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h2 { color: #1a73e8; border-bottom: 2px solid #1a73e8; padding-bottom: 10px; }
        form { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
        input, button { padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        button { grid-column: span 2; background-color: #28a745; color: white; border: none; font-weight: bold; cursor: pointer; }
        button:hover { background-color: #218838; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #1a73e8; color: white; }
        .btn-delete { background-color: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏥 Gestión de Citas Médicas</h2>
        
        <form action="CitasServlet" method="post">
            <input type="text" name="usuario" placeholder="¿Para quién es? (Abuelo / Abuela)" required>
            <input type="date" name="fecha" required>
            <input type="time" name="hora" required>
            <input type="text" name="lugar" placeholder="Centro Médico / Hospital" required>
            <input type="text" name="medico" placeholder="Nombre del Médico" required>
            <input type="text" name="observaciones" placeholder="Notas (ayunas, papeles...)" style="grid-column: span 2;">
            <button type="submit">💾 GUARDAR CITA EN LA NUBE</button>
        </form>

        <h3>Lista de Citas Actuales</h3>
        <table>
            <tr>
                <th>Paciente</th><th>Fecha</th><th>Hora</th><th>Lugar</th><th>Acciones</th>
            </tr>
            <%
                // DATOS DE TU PROYECTO EN FRANCIA
                String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
                String dbUser = "postgres.amzippkmiwiymeeeuono";
                String dbPass = "Abuelos2025App"; // <--- CAMBIA ESTO POR TU CONTRASEÑA

                try {
                    Class.forName("org.postgresql.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                    Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM citas ORDER BY fecha ASC");
                    
                    while(rs.next()){
            %>
            <tr>
                <td><strong><%= rs.getString("usuario") %></strong></td>
                <td><%= rs.getString("fecha") %></td>
                <td><%= rs.getString("hora") %></td>
                <td><%= rs.getString("lugar") %></td>
                <td>
                    <a href="BorrarCitaServlet?id=<%= rs.getInt("id") %>" class="btn-delete" onclick="return confirm('¿Seguro que quieres borrar esta cita?')">Borrar</a>
                </td>
            </tr>
            <% 
                    }
                    conn.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='5' style='color:red;'>Error de conexión: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>
</body>
</html>
