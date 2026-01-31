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
    CitaMadre edit = (CitaMadre) request.getAttribute("citaEditar");

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("es", "ES"));

    String titulo = ""; String colorPrincipal = ""; 
    String[] opciones = {}; 
    String[] lugares = {}; // Nuevo array para lugares

    if(tipo.equals("Medico")) {
        titulo = "Mis Médicos"; colorPrincipal = "#e91e63"; 
        // LISTA ACTUALIZADA CON EMOTICONOS
        opciones = new String[]{
            "Médico Cabecera 🩺", "Enfermera 💉", "Digestivo 🤢", "Análisis Sangre 🩸", 
            "Eco 🖥️", "Mamografía 🍈", "Radiografía 💀", "TAC / Resonancia ☢️", 
            "Cardiólogo ❤️", "Podólogo 🦶", "Dentista 🦷", "Oculista 👁️", 
            "Ginecólogo 🌸", "Dermatólogo 🧴", "Traumatólogo 🦴", "Otro 📝"
        };
        // LISTA DE LUGARES
        lugares = new String[]{
            "Afidea", "Ruber Internacional", "Severo Ochoa", 
            "Hosp. Juan Carlos I Móstoles", "Pedroches", "Centro Salud", 
            "Fisio / La Fortuna", "Otro"
        };
        
    } else if(tipo.equals("Cuidados")) {
        titulo = "Peluquería y Cuidados"; colorPrincipal = "#9c27b0";
        opciones = new String[]{"Peluquería", "Manicura/Uñas", "Pedicura", "Masaje", "Esteticista", "Laser", "Otro"};
        lugares = new String[]{"Peluquería habitual", "Centro Estética", "Casa", "Otro"};

    } else if(tipo.equals("Nali")) {
        titulo = "Cosas de Nali"; colorPrincipal = "#4caf50";
        opciones = new String[]{"Veterinario (Revisión)", "Vacunas", "Desparasitación", "Peluquería Canina", "Comprar Pienso", "Urgencia", "Otro"};
        lugares = new String[]{"Veterinario Habitual", "Tienda Animales", "Peluquería Canina", "Otro"};
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= titulo %></title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fce4ec; padding: 20px; color: #444; min-height: 100vh;}
        .container { max-width: 800px; margin: 0 auto; }
        
        h1 { text-align: center; color: <%= colorPrincipal %>; text-transform: uppercase; }
        .btn-volver { background-color: white; color: <%= colorPrincipal %>; text-decoration: none; padding: 10px 20px; border-radius: 20px; font-weight: bold; display: inline-block; margin-bottom: 20px; }

        .form-box { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 30px; border-top: 5px solid <%= colorPrincipal %>; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; }
        input, select { padding: 12px; border: 1px solid #ddd; border-radius: 10px; flex: 1; font-size: 1em; }
        button { background-color: <%= colorPrincipal %>; color: white; border: none; padding: 12px 25px; border-radius: 10px; font-weight: bold; cursor: pointer; width: 100%; }

        .cita-card { background: white; border-radius: 18px; padding: 20px; margin-bottom: 15px; border-left: 8px solid <%= colorPrincipal %>; position: relative; }
        .btn-icon { text-decoration: none; font-size: 1.3em; margin-left: 10px; }
        .acciones { position: absolute; right: 20px; top: 20px; }

        /* Estilo Historial */
        details { margin-top: 30px; text-align: center; }
        summary { background: #90a4ae; color: white; padding: 10px 20px; border-radius: 20px; display: inline-block; cursor: pointer; }
        table { width: 100%; background: white; margin-top: 10px; border-collapse: collapse; }
        td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }
    </style>
    <script>
        // Función genérica para mostrar campo de texto si eligen "Otro"
        function comprobarOtro(selectObj, inputId) {
            var input = document.getElementById(inputId);
            if (selectObj.value.includes("Otro")) {
                input.style.display = "block";
                input.required = true;
                input.value = ""; // Limpiar para que escriban
            } else {
                input.style.display = "none";
                input.required = false;
                // Si no es otro, copiamos el valor del select al input (oculto) por si acaso se envía
                input.value = selectObj.value;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        <h1><%= titulo %></h1>

        <% if("Medico".equals(tipo)) { %>
            <div style="text-align: center; margin-bottom: 20px; display: flex; gap: 10px; justify-content: center;">
                <a href="MedicacionMadreServlet" style="background: <%= colorPrincipal %>; color: white; padding: 10px 20px; border-radius: 20px; text-decoration: none; font-weight: bold;">💊 Pastillas</a>
                <a href="FarmaciaMadreServlet" style="background: #00897b; color: white; padding: 10px 20px; border-radius: 20px; text-decoration: none; font-weight: bold;">🏥 Farmacia (Recogida)</a>
            </div>
        <% } %>

        <div class="form-box">
            <h3 style="margin-top:0; color: <%= colorPrincipal %>;">
                <%= (edit != null) ? "✏️ Editar Cita" : "➕ Nueva Cita" %>
            </h3>
            
            <form action="AgendaMadreServlet" method="POST">
                <input type="hidden" name="tipo" value="<%= tipo %>">
                <% if(edit != null) { %> <input type="hidden" name="id" value="<%= edit.getId() %>"> <% } %>

                <div class="form-row">
                    <input type="date" name="fecha" value="<%= (edit != null) ? edit.getFecha() : "" %>" required>
                    <input type="time" name="hora" value="<%= (edit != null) ? edit.getHora() : "" %>" required>
                </div>

                <div class="form-row">
                    <select id="sel_titulo" onchange="comprobarOtro(this, 'input_titulo')" required>
                        <option value="" disabled selected>-- Especialista --</option>
                        <% for(String op : opciones) { 
                             boolean selected = (edit != null && op.equals(edit.getTitulo())); 
                        %>
                            <option value="<%= op %>" <%= selected ? "selected" : "" %>><%= op %></option>
                        <% } %>
                    </select>
                    <input type="text" id="input_titulo" name="titulo" placeholder="Escribe el nombre..." 
                           style="display: <%= (edit != null && !java.util.Arrays.asList(opciones).contains(edit.getTitulo())) ? "block" : "none" %>;"
                           value="<%= (edit != null) ? edit.getTitulo() : "" %>">
                </div>

                <div class="form-row">
                    <select id="sel_lugar" onchange="comprobarOtro(this, 'input_lugar')">
                        <option value="" disabled selected>-- Lugar --</option>
                        <% for(String lug : lugares) { 
                             boolean selected = (edit != null && lug.equals(edit.getLugar())); 
                        %>
                            <option value="<%= lug %>" <%= selected ? "selected" : "" %>><%= lug %></option>
                        <% } %>
                    </select>
                    <input type="text" id="input_lugar" name="lugar" placeholder="Escribe el lugar..." 
                           style="display: <%= (edit != null && !java.util.Arrays.asList(lugares).contains(edit.getLugar())) ? "block" : "none" %>;"
                           value="<%= (edit != null) ? edit.getLugar() : "" %>">
                </div>

                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Notas extra..." value="<%= (edit != null && edit.getObservaciones() != null) ? edit.getObservaciones() : "" %>">
                </div>
                
                <button type="submit"><%= (edit != null) ? "💾 Guardar" : "Guardar Evento" %></button>
            </form>
        </div>

        <% if(pendientes != null) { for(CitaMadre c : pendientes) { %>
            <div class="cita-card">
                <div class="acciones">
                    <a href="AgendaMadreServlet?tipo=<%= tipo %>&accion=editar&id=<%= c.getId() %>" class="btn-icon">✏️</a>
                    <a href="AgendaMadreServlet?tipo=<%= tipo %>&accion=borrar&id=<%= c.getId() %>" class="btn-icon" style="color:#d32f2f;" onclick="return confirm('¿Borrar?')">🗑️</a>
                </div>
                <div style="font-size: 1.1em; font-weight: bold; color: <%= colorPrincipal %>;"><%= c.getTitulo() %></div>
                <div>📅 <%= c.getFecha().toLocalDate().format(fmt) %> (<%= c.getHora() %>)</div>
                <div style="color: #666;">📍 <%= c.getLugar() %></div>
            </div>
        <% }} %>

        <details>
            <summary>📂 Ver Historial</summary>
            <table>
                <% if(historial != null) { for(CitaMadre h : historial) { %>
                    <tr>
                        <td><%= h.getFecha().toLocalDate().format(fmt) %></td>
                        <td><strong><%= h.getTitulo() %></strong></td>
                        <td><%= h.getLugar() %></td>
                    </tr>
                <% }} %>
            </table>
        </details>
    </div>
</body>
</html>