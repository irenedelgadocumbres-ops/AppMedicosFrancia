<%-- 
    Document   : vista_agenda_madre
    Created on : 23 ene 2026, 17:05:54
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.CitaMadre" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String tipo = (String) request.getAttribute("tipoActual");
    if(tipo == null) { response.sendRedirect("index.html"); return; }

    List<CitaMadre> pendientes = (List<CitaMadre>) request.getAttribute("listaPendientes");
    List<CitaMadre> historial = (List<CitaMadre>) request.getAttribute("listaHistorial");
    
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("es", "ES"));

    // CONFIGURACIÓN DE COLORES DINÁMICOS
    String titulo = "";
    String colorFondo = "";
    String colorPrincipal = ""; // Para botones y bordes
    String colorClaro = "";     // Para fondos suaves
    String icono = "";

    if(tipo.equals("Medico")) {
        titulo = "Mis Médicos"; icono = "🩺";
        colorFondo = "linear-gradient(135deg, #fce4ec 0%, #f8bbd0 100%)";
        colorPrincipal = "#e91e63"; // Rosa fuerte
        colorClaro = "#fce4ec";
    } else if(tipo.equals("Cuidados")) {
        titulo = "Peluquería y Cuidados"; icono = "💅";
        colorFondo = "linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%)";
        colorPrincipal = "#9c27b0"; // Violeta
        colorClaro = "#f3e5f5";
    } else if(tipo.equals("Nali")) {
        titulo = "Cosas de Nali"; icono = "🐶";
        colorFondo = "linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%)";
        colorPrincipal = "#4caf50"; // Verde
        colorClaro = "#e8f5e9";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= titulo %></title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: <%= colorFondo %>; padding: 20px; color: #444; min-height: 100vh;}
        .container { max-width: 800px; margin: 0 auto; }
        
        h1 { text-align: center; color: <%= colorPrincipal %>; text-transform: uppercase; letter-spacing: 1px; }
        
        .btn-volver { 
            background-color: white; color: <%= colorPrincipal %>; text-decoration: none; 
            padding: 10px 20px; border-radius: 20px; font-weight: bold; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: inline-block; margin-bottom: 20px;
        }

        /* FORMULARIO DE AÑADIR */
        .form-box { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; }
        input { padding: 12px; border: 1px solid #ddd; border-radius: 10px; flex: 1; outline: none; }
        input:focus { border-color: <%= colorPrincipal %>; }
        button { 
            background-color: <%= colorPrincipal %>; color: white; border: none; 
            padding: 12px 25px; border-radius: 10px; font-weight: bold; cursor: pointer; 
            font-size: 1em; transition: transform 0.2s;
        }
        button:hover { transform: scale(1.05); }

        /* TARJETAS DE CITAS (Igual que vista_mayores) */
        .cita-card { 
            background: white; border-radius: 18px; padding: 20px; margin-bottom: 15px; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.05); border-left: 8px solid <%= colorPrincipal %>;
            position: relative;
        }
        .cita-fecha { font-weight: bold; color: <%= colorPrincipal %>; font-size: 1.3em; margin-bottom: 5px; text-transform: capitalize; }
        .cita-dato { font-size: 1.1em; margin-bottom: 3px; }
        .cita-obs { font-style: italic; color: #777; margin-top: 10px; font-size: 0.9em; border-top: 1px solid #eee; padding-top: 5px;}

        /* HISTORIAL */
        .historial-container { margin-top: 40px; text-align: center; padding-bottom: 40px; }
        details summary {
            background-color: #78909c; color: white; padding: 12px 25px; border-radius: 20px;
            cursor: pointer; font-size: 1.1em; font-weight: bold; display: inline-block; box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tabla-historial { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 10px; overflow: hidden; font-size: 0.95em; }
        .tabla-historial th { background-color: #cfd8dc; padding: 12px; text-align: left; }
        .tabla-historial td { border-bottom: 1px solid #eee; padding: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        
        <h1><%= icono %> <%= titulo %></h1>

        <div class="form-box">
            <h3 style="margin-top:0; color: <%= colorPrincipal %>;">➕ Añadir Nuevo Evento</h3>
            <form action="AgendaMadreServlet" method="POST">
                <input type="hidden" name="tipo" value="<%= tipo %>">
                <div class="form-row">
                    <input type="date" name="fecha" required>
                    <input type="time" name="hora" required>
                </div>
                <div class="form-row">
                    <input type="text" name="titulo" placeholder="Título (Ej: Dentista, Vacuna...)" required>
                    <input type="text" name="lugar" placeholder="Lugar (Ej: Clínica X)">
                </div>
                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Notas extra...">
                    <button type="submit">Guardar</button>
                </div>
            </form>
        </div>

        <h3 style="color: #555; border-bottom: 2px solid <%= colorPrincipal %>; display: inline-block; padding-bottom: 5px;">📅 Próximos Eventos</h3>
        
        <% if(pendientes != null && !pendientes.isEmpty()) { 
            for(CitaMadre c : pendientes) { %>
                <div class="cita-card">
                    <div class="cita-fecha">
                        <%= c.getFecha().toLocalDate().format(fmt) %> <span style="font-size:0.8em; color: #666;">(<%= c.getHora() %>)</span>
                    </div>
                    <div class="cita-dato"><strong>📌 <%= c.getTitulo() %></strong></div>
                    <div class="cita-dato">📍 <%= c.getLugar() %></div>
                    <% if(c.getObservaciones() != null && !c.getObservaciones().isEmpty()) { %>
                        <div class="cita-obs">📝 <%= c.getObservaciones() %></div>
                    <% } %>
                </div>
        <% }} else { %>
            <p style="text-align: center; color: #888; background: rgba(255,255,255,0.5); padding: 20px; border-radius: 10px;">
                🎉 No hay nada pendiente. ¡Todo despejado!
            </p>
        <% } %>

        <div class="historial-container">
            <details>
                <summary>📂 Ver Historial Anterior</summary>
                
                <table class="tabla-historial">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Evento</th>
                            <th>Lugar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(historial != null && !historial.isEmpty()) { 
                            for(CitaMadre h : historial) { %>
                            <tr>
                                <td><%= h.getFecha().toLocalDate().format(fmt) %></td>
                                <td><strong><%= h.getTitulo() %></strong></td>
                                <td><%= h.getLugar() %></td>
                            </tr>
                        <% }} else { %>
                            <tr><td colspan="3" style="text-align:center;">No hay historial antiguo.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </details>
        </div>

    </div>
</body>
</html>
