<%-- 
    Document   : admin_panel
    Created on : 20 dic 2025, 12:49:19
    Author     : Asus
--%>

<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrador - Gestión de Citas</title>
    <style>
        /* Estilos Irene: Diseño Pastel y Accesibilidad */
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: linear-gradient(135deg, #fdfcfb 0%, #e2d1c3 100%); 
            margin: 0; padding: 20px; color: #444;
            min-height: 100vh;
        }

        h1, h3 { text-align: center; color: #546e7a; margin-top: 10px; }

        /* Botonera Superior */
        .botonera { display: flex; justify-content: center; margin-bottom: 25px; }
        .btn-inicio { 
            padding: 12px 25px; border-radius: 15px; border: none; font-weight: bold; 
            cursor: pointer; font-size: 1.1em; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            background-color: #ffcdd2; color: #b71c1c; text-decoration: none;
            transition: all 0.2s;
        }
        .btn-inicio:active { transform: scale(0.95); }
        
        .btn-volver { 
            padding: 12px 25px; border-radius: 15px; border: none; font-weight: bold; 
            cursor: pointer; font-size: 1.1em; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            background-color: #6c757d; color: white; text-decoration: none;
            transition: all 0.2s;
        }

        .btn-volver:active { 
            transform: scale(0.95); 
        }

        /* Contenedor del Formulario */
        .form-container {
            background: white;
            padding: 25px;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            max-width: 500px;
            margin: 0 auto 40px auto;
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

        .btn-guardar {
            background: linear-gradient(to right, #b2dfdb, #80cbc4); 
            color: #444; border: none; padding: 18px; width: 100%;
            border-radius: 15px; font-weight: bold; cursor: pointer;
            font-size: 1.2em; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        /* Lista de Gestión */
        .lista-gestion { max-width: 600px; margin: 0 auto; }
        .cita-item { 
            background: white; border-radius: 20px; padding: 20px; margin-bottom: 20px; 
            box-shadow: 0 6px 15px rgba(0,0,0,0.04);
            border-left: 10px solid #b2dfdb;
        }

        .cita-info { font-size: 1.2em; margin-bottom: 10px; }
        .cita-info b { color: #546e7a; }

        .acciones { display: flex; gap: 10px; margin-top: 15px; }
        .btn-accion {
            text-decoration: none; padding: 10px 20px; border-radius: 10px; 
            font-weight: bold; font-size: 0.95em; flex: 1; text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .btn-modificar { background-color: #fff9c4; color: #fbc02d; } 
        .btn-borrar { background-color: #ffcdd2; color: #d32f2f; }
    </style>
</head>
<body>

    <div class="botonera">
        <a href="index.html" class="btn-inicio">🔒 Cerrar Sesión</a>
        <a href="vista_mayores.jsp" class="btn-nav btn-volver">⬅️️ Ir a calendario</a>
    </div>

    <h1>Panel de Administración</h1>
    
    <div class="form-container">
        <form action="CitasServlet" method="POST">
            <div class="campo">
                <label>¿Para quién es la cita?</label>
                <select name="usuario">
                    <option value="Abuelo">👴 Abuelo</option>
                    <option value="Abuela">👵 Abuela</option>
                </select> 
            </div>
            
            <div class="campo">
                <label>Fecha de la cita:</label>
                <input type="date" name="fecha" required> 
            </div>
            
            <div class="campo">
                <label>Hora:</label>
                <input type="time" name="hora" required> 
            </div>
            
            
            
            <div class="campo">
                <label>Lugar:</label>
                <select name="lugar" onchange="if(this.value=='Otro'){ document.getElementById('extraLugar').style.display='block'; } else { document.getElementById('extraLugar').style.display='none'; }">
                    <option value="" disabled selected>Selecciona el lugar...</option>
                    <option value="Centro de Salud">🏥 Centro de Salud</option>
                    <option value="Hospital">🏥 Hospital Rey Juan Carlos (Mostoles)</option>
                    <option value="Especialista">🏢 Centro de Especialidades</option>
                    <option value="Clínica Privada">🏥 Clínica Privada</option>
                    <option value="Otro">📍 Otro</option>
                </select>
                <div id="extraLugar" style="display:none; margin-top:10px;">
                    <input type="text" name="lugar_otro" placeholder="¿Dónde es la cita?">
                </div>
            </div>
            
            <div class="campo">
                <label>Médico / Especialidad:</label>
                <select name="medico" onchange="if(this.value=='Otro'){ document.getElementById('extraMedico').style.display='block'; } else { document.getElementById('extraMedico').style.display='none'; }">
                    <option value="" disabled selected>Selecciona el médico...</option>
                    <option value="Médico de Cabecera">👨‍⚕️ Médico de Cabecera</option>
                    <option value="Enfermería">🩺 Enfermería</option>
                    <option value="Cardiología">❤️ Cardiología</option>
                    <option value="Oftalmología">👁️ Oftalmología</option>
                    <option value="Traumatología">🦴 Traumatología</option>
                    <option value="Análisis">💉 Análisis de Sangre</option>
                    <option value="Dentista">🦷 Dentista</option>
                    <option value="Otro">⚕️ Especialista (Otro)</option>
                </select>
                <div id="extraMedico" style="display:none; margin-top:10px;">
                    <input type="text" name="medico_otro" placeholder="¿Qué médico o especialidad?">
                </div>
            </div>
            
            <div class="campo">
                <label>Observaciones:</label>
                <textarea name="observaciones" rows="3" placeholder="Ej: Ir en ayunas..."></textarea> 
            </div>
            
            <button type="submit" class="btn-guardar">💾 GUARDAR CITA</button>
        </form>
    </div>

    <h3>Citas Programadas (Control Total)</h3>
    
    <div class="lista-gestion">
        <%
            // Conexión Supabase Francia
            String dbURL = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
            String dbUser = "postgres.amzippkmiwiymeeeuono";
            String dbPass = "Abuelos2025App"; 

            // Formato para ver la fecha como en la vista de los abuelos
            DateTimeFormatter fmtBonito = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("es", "ES"));

            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM citas ORDER BY fecha DESC, hora DESC");
                
                while(rs.next()) {
                    // Convertimos fecha para mostrarla bonita
                    LocalDate fechaObj = rs.getDate("fecha").toLocalDate();
                    String fechaBonita = fechaObj.format(fmtBonito);
        %>
            <div class="cita-item">
                <div class="cita-info">
                    <b><%= rs.getString("usuario") %></b> - <span style="text-transform: capitalize;"><%= fechaBonita %></span> (<%= rs.getString("hora") %>)
                </div>
                <div class="cita-info">
                    📍 <%= rs.getString("lugar") %> | ⚕️ <%= rs.getString("medico") %>
                </div>
                
                <div class="acciones">
                    <a href="editar_cita.jsp?id=<%= rs.getInt("id") %>" class="btn-accion btn-modificar">
                        ✏️ Modificar
                    </a>
                    
                    <a href="BorrarCitaServlet?id=<%= rs.getInt("id") %>" 
                       class="btn-accion btn-borrar"
                       onclick="return confirm('¿Seguro que quieres borrar esta cita?')">
                        🗑️ Borrar
                    </a>
                </div>
            </div>
        <% 
                } conn.close();
            } catch(Exception e) { out.print("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); }
        %>
    </div>

</body>
</html>