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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar Cita - Gestión Familiar</title>
    <style>
        /* Estilo Unificado: Diseño Pastel Irene */
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: linear-gradient(135deg, #fdfcfb 0%, #e2d1c3 100%); 
            margin: 0; padding: 20px; color: #444;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 { text-align: center; color: #546e7a; margin-top: 10px; }

        /* Botonera Superior */
        .botonera { width: 100%; max-width: 500px; display: flex; justify-content: flex-start; margin-bottom: 25px; }
        .btn-volver { 
            padding: 12px 25px; border-radius: 15px; border: none; font-weight: bold; 
            cursor: pointer; font-size: 1.1em; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            background-color: #ffcdd2; color: #b71c1c; text-decoration: none;
            transition: all 0.2s;
        }
        .btn-volver:active { transform: scale(0.95); }

        /* Contenedor del Formulario */
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            max-width: 500px;
            width: 100%;
            box-sizing: border-box;
        }

        .campo { margin-bottom: 20px; }
        label { display: block; color: #88a0a8; font-weight: bold; margin-bottom: 8px; font-size: 1.1em; }
        
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            font-size: 16px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.3s;
        }
        input:focus { border-color: #b2dfdb; }

        .btn-actualizar {
            background: linear-gradient(to right, #b2dfdb, #80cbc4); 
            color: #444; border: none; padding: 18px; width: 100%;
            border-radius: 15px; font-weight: bold; cursor: pointer;
            font-size: 1.2em; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-top: 10px;
        }
        .btn-actualizar:hover { opacity: 0.9; }
    </style>
</head>
<body>

    <div class="botonera">
        <a href="admin_panel.jsp" class="btn-volver">◀ Cancelar</a>
    </div>

    <h1>✏️ Modificar Cita</h1>
    
    <div class="form-container">
        <%
            // Capturamos el ID que viene de la URL
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Credenciales Supabase Francia
            String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
            String dbUser = "postgres.amzippkmiwiymeeeuono";
            String dbPass = "Abuelos2025App"; // Tu contraseña mantenida

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
            
            <div class="campo">
                <label>Paciente:</label>
                <select name="usuario">
                    <option value="Abuelo" <%= rs.getString("usuario").equals("Abuelo") ? "selected" : "" %>>👴 Abuelo</option>
                    <option value="Abuela" <%= rs.getString("usuario").equals("Abuela") ? "selected" : "" %>>👵 Abuela</option>
                </select>
            </div>

            <div class="campo">
                <label>Fecha:</label>
                <input type="date" name="fecha" value="<%= rs.getString("fecha") %>" required>
            </div>

            <div class="campo">
                <label>Hora:</label>
                <input type="time" name="hora" value="<%= rs.getString("hora") %>" required>
            </div>

            <div class="campo">
                <label>Lugar:</label>
                <input type="text" name="lugar" value="<%= rs.getString("lugar") %>" required>
            </div>

            <div class="campo">
                <label>Médico:</label>
                <input type="text" name="medico" value="<%= rs.getString("medico") %>" required>
            </div>

            <div class="campo">
                <label>Observaciones:</label>
                <textarea name="observaciones" rows="3"><%= rs.getString("observaciones") != null ? rs.getString("observaciones") : "" %></textarea>
            </div>

            <button type="submit" class="btn-actualizar">✨ ACTUALIZAR DATOS</button>
        </form>
        <% 
                }
                conn.close(); 
            } catch(Exception e) { 
                out.println("<p style='color:red;'>Error al cargar: " + e.getMessage() + "</p>"); 
            } 
        %>
    </div>

</body>
</html>