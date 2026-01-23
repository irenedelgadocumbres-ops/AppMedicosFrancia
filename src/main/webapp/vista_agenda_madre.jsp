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
    
    // Objeto para editar
    CitaMadre edit = (CitaMadre) request.getAttribute("citaEditar");

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("es", "ES"));

    // CONFIGURACIÓN VISUAL
    String titulo = ""; String colorFondo = ""; String colorPrincipal = ""; String icono = "";
    String[] opciones = {}; 

    if(tipo.equals("Medico")) {
        titulo = "Mis Médicos"; icono = "🩺";
        colorFondo = "linear-gradient(135deg, #fce4ec 0%, #f8bbd0 100%)";
        colorPrincipal = "#e91e63"; 
        opciones = new String[]{"Médico Cabecera", "Dentista", "Oculista", "Ginecólogo", "Dermatólogo", "Traumatólogo", "Análisis Sangre", "Otro"};
    } else if(tipo.equals("Cuidados")) {
        titulo = "Peluquería y Cuidados"; icono = "💅";
        colorFondo = "linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%)";
        colorPrincipal = "#9c27b0";
        opciones = new String[]{"Peluquería", "Manicura/Uñas", "Pedicura", "Masaje", "Esteticista", "Depilación", "Otro"};
    } else if(tipo.equals("Nali")) {
        titulo = "Cosas de Nali"; icono = "🐶";
        colorFondo = "linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%)";
        colorPrincipal = "#4caf50";
        opciones = new String[]{"Veterinario (Revisión)", "Vacunas", "Desparasitación", "Peluquería Canina", "Comprar Pienso", "Urgencia", "Otro"};
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
        
        h1 { text-align: center; color: <%= colorPrincipal %>; text-transform: uppercase; }
        .btn-volver { background-color: white; color: <%= colorPrincipal %>; text-decoration: none; padding: 10px 20px; border-radius: 20px; font-weight: bold; display: inline-block; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }

        /* FORMULARIO */
        .form-box { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 30px; border-top: 5px solid <%= colorPrincipal %>; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; }
        input, select { padding: 12px; border: 1px solid #ddd; border-radius: 10px; flex: 1; font-size: 1em; }
        button { background-color: <%= colorPrincipal %>; color: white; border: none; padding: 12px 25px; border-radius: 10px; font-weight: bold; cursor: pointer; transition: transform 0.2s; width: 100%; }
        button:hover { transform: scale(1.02); }

        /* TARJETAS PENDIENTES */
        .cita-card { background: white; border-radius: 18px; padding: 20px; margin-bottom: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); border-left: 8px solid <%= colorPrincipal %>; display: flex; justify-content: space-between; align-items: flex-start; }
        .cita-info { flex: 1; }
        .cita-fecha { font-weight: bold; color: <%= colorPrincipal %>; font-size: 1.2em; text-transform: capitalize; }
        .acciones { display: flex; gap: 10px; margin-left: 10px; }
        .btn-icon { text-decoration: none; font-size: 1.3em; transition: transform 0.2s; cursor: pointer; border: none; background: none; }
        .btn-icon:hover { transform: scale(1.2); }

        /* HISTORIAL (ESTILO RESTAURADO) */
        .historial-container { margin-top: 40px; text-align: center; padding-bottom: 50px; }
        details summary { background-color: #78909c; color: white; padding: 12px 25px; border-radius: 20px; cursor: pointer; font-weight: bold; margin-bottom: 10px; display: inline-block; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        
        .tabla-historial { width: 100%; background: white; border-radius: 10px; overflow: hidden; border-collapse: collapse; font-size: 0.95em; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .tabla-historial th { background-color: #cfd8dc; padding: 12px; text-align: left; color: #455a64; text-transform: uppercase; font-size: 0.85em; letter-spacing: 0.5px; }
        .tabla-historial td { border-bottom: 1px solid #eee; padding: 12px; vertical-align: middle; }
        .tabla-historial tr:last-child td { border-bottom: none; }
    </style>
    <script>
        function mostrarOtro(select) {
            var inputOtro = document.getElementById("div_otro");
            if (select.value === "Otro") {
                inputOtro.style.display = "block";
                document.getElementById("input_otro").required = true;
            } else {
                inputOtro.style.display = "none";
                document.getElementById("input_otro").required = false;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        
        <h1><%= icono %> <%= titulo %></h1>

        <div class="form-box" id="formulario">
            <h3 style="margin-top:0; color: <%= colorPrincipal %>;">
                <%= (edit != null) ? "✏️ Editando Cita" : "➕ Añadir Nuevo Evento" %>
            </h3>
            
            <form action="AgendaMadreServlet" method="POST">
                <input type="hidden" name="tipo" value="<%= tipo %>">
                <% if(edit != null) { %> <input type="hidden" name="id" value="<%= edit.getId() %>"> <% } %>

                <div class="form-row">
                    <input type="date" name="fecha" value="<%= (edit != null) ? edit.getFecha() : "" %>" required>
                    <input type="time" name="hora" value="<%= (edit != null) ? edit.getHora() : "" %>" required>
                </div>

                <div class="form-row">
                    <select name="titulo" onchange="mostrarOtro(this)" required>
                        <option value="" disabled selected>-- Selecciona --</option>
                        <% for(String op : opciones) { 
                             boolean selected = (edit != null && op.equals(edit.getTitulo()));
                             boolean isOtro = (edit != null && !java.util.Arrays.asList(opciones).contains(edit.getTitulo()));
                             if(op.equals("Otro") && isOtro) selected = true; 
                        %>
                            <option value="<%= op %>" <%= selected ? "selected" : "" %>><%= op %></option>
                        <% } %>
                    </select>
                    <input type="text" name="lugar" placeholder="Lugar (Clínica, Calle...)" value="<%= (edit != null) ? edit.getLugar() : "" %>">
                </div>

                <div class="form-row" id="div_otro" style="display: <%= (edit != null && !java.util.Arrays.asList(opciones).contains(edit.getTitulo())) ? "block" : "none" %>;">
                    <input type="text" id="input_otro" name="titulo_otro" placeholder="Escribe el título..." value="<%= (edit != null) ? edit.getTitulo() : "" %>">
                </div>

                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Notas extra..." value="<%= (edit != null && edit.getObservaciones() != null) ? edit.getObservaciones() : "" %>">
                </div>
                
                <button type="submit"><%= (edit != null) ? "💾 Guardar Cambios" : "Guardar Evento" %></button>
                <% if(edit != null) { %>
                    <a href="AgendaMadreServlet?tipo=<%= tipo %>" style="display:block; text-align:center; margin-top:10px; color:#666; text-decoration:none;">Cancelar Edición</a>
                <% } %>
            </form>
        </div>

        <h3 style="color: #555;">📅 Próximos Eventos</h3>
        
        <% if(pendientes != null && !pendientes.isEmpty()) { 
            for(CitaMadre c : pendientes) { %>
                <div class="cita-card">
                    <div class="cita-info">
                        <div class="cita-fecha"><%= c.getFecha().toLocalDate().format(fmt) %> <small>(<%= c.getHora() %>)</small></div>
                        <div style="font-size: 1.1em;"><strong><%= c.getTitulo() %></strong></div>
                        <div style="color: #666;">📍 <%= c.getLugar() %></div>
                        <% if(c.getObservaciones() != null && !c.getObservaciones().isEmpty()) { %>
                            <div style="font-style: italic; color: #888; font-size: 0.9em; margin-top: 5px;">📝 <%= c.getObservaciones() %></div>
                        <% } %>
                    </div>
                    <div class="acciones">
                        <a href="AgendaMadreServlet?tipo=<%= tipo %>&accion=editar&id=<%= c.getId() %>" class="btn-icon" title="Editar">✏️</a>
                        <a href="AgendaMadreServlet?tipo=<%= tipo %>&accion=borrar&id=<%= c.getId() %>" class="btn-icon" style="color:#d32f2f;" onclick="return confirm('¿Borrar <%= c.getTitulo() %>?')" title="Borrar">🗑️</a>
                    </div>
                </div>
        <% }} else { %>
            <p style="text-align: center; color: #888;">No hay eventos pendientes.</p>
        <% } %>

        <div class="historial-container">
            <details>
                <summary>📂 Ver Historial Anterior</summary>
                
                <table class="tabla-historial">
                    <thead>
                        <tr>
                            <th style="width: 30%;">Fecha</th>
                            <th style="width: 30%;">Evento</th>
                            <th style="width: 30%;">Lugar</th>
                            <th style="width: 10%;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(historial != null && !historial.isEmpty()) { 
                            for(CitaMadre h : historial) { %>
                            <tr>
                                <td><%= h.getFecha().toLocalDate().format(fmt) %></td>
                                <td><strong><%= h.getTitulo() %></strong></td>
                                <td><%= h.getLugar() %></td>
                                <td style="text-align: center;">
                                    <a href="AgendaMadreServlet?tipo=<%= tipo %>&accion=borrar&id=<%= h.getId() %>" style="color:#d32f2f; text-decoration:none; font-size: 1.2em;" onclick="return confirm('¿Borrar del historial?')" title="Borrar">🗑️</a>
                                </td>
                            </tr>
                        <% }} else { %>
                            <tr><td colspan="4" style="text-align:center; padding: 20px; color: #777;">No hay historial antiguo.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </details>
        </div>
    </div>
</body>
</html>