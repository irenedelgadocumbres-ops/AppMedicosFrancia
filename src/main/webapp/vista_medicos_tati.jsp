<%-- 
    Document   : vista_medicos_tati
    Created on : 24 ene 2026, 21:34:24
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.CitaTati" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CitaTati> pendientes = (List<CitaTati>) request.getAttribute("listaPendientes");
    List<CitaTati> historial = (List<CitaTati>) request.getAttribute("listaHistorial");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
    
    // TU LISTA DE ESPECIALISTAS
    String[] especialistas = {
        "Médico Cabecera", "Enfermera", "Traumatólogo", "Enfermera Trauma", 
        "Cirugía Bariátrica", "Endocrino", "Rehabilitación", "Rehabilitador", 
        "Reumatóloga (Autoinmune)", "Reumatóloga", "Otorrino", "Análisis", "Eco", 
        "Radiografía", "TAC / Resonancia", "Digestivo", "Unidad del Dolor", 
        "Ginecólogo", "Trauma Cirugía Ortopédica", "Neurocirujano", "Urólogo", 
        "Neumólogo", "Máquina Apnea Sueño", "Dentista", "Podólogo", "Oculista", "Otro"
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Médicos Tati</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e0f2f1; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #009688; margin-bottom: 25px; }
        input, select { width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        button { background: #009688; color: white; width: 100%; padding: 12px; border: none; border-radius: 10px; font-weight: bold; font-size: 1.1em; cursor: pointer; }
        
        .cita-card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; border-left: 8px solid #009688; box-shadow: 0 4px 8px rgba(0,0,0,0.05); position: relative; }
        .btn-delete { position: absolute; right: 15px; top: 15px; text-decoration: none; font-size: 1.3em; }
        
        details summary { background: #546e7a; color: white; padding: 10px 20px; border-radius: 20px; margin-top: 30px; cursor: pointer; font-weight: bold; display: inline-block; }
        .tabla-historial { width: 100%; background: white; margin-top: 10px; border-radius: 10px; border-collapse: collapse; }
        .tabla-historial td { padding: 10px; border-bottom: 1px solid #eee; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_tati.jsp" style="text-decoration:none; color:#009688; font-weight:bold; display:block; margin-bottom:15px;">⬅ Volver al Panel</a>
        <h1 style="text-align:center; color:#00796b;">🩺 Mis Especialistas</h1>

        <div class="form-box">
            <form action="CitasTatiServlet" method="POST">
                <input type="date" name="fecha" required>
                <input type="time" name="hora" required>
                <select name="especialista" required>
                    <option value="" disabled selected>-- Elige Especialista --</option>
                    <% for(String esp : especialistas) { %>
                        <option value="<%= esp %>"><%= esp %></option>
                    <% } %>
                </select>
                <input type="text" name="lugar" placeholder="Lugar (Hospital, Centro de Salud...)">
                <input type="text" name="observaciones" placeholder="Notas (llevar papeles, ayunas...)">
                <button type="submit">Guardar Cita</button>
            </form>
        </div>

        <% if(pendientes != null && !pendientes.isEmpty()) { 
            for(CitaTati c : pendientes) { %>
            <div class="cita-card">
                <a href="CitasTatiServlet?accion=borrar&id=<%= c.getId() %>" class="btn-delete" onclick="return confirm('¿Borrar?')">🗑️</a>
                <div style="color:#00796b; font-weight:bold; font-size:1.1em;"><%= c.getEspecialista() %></div>
                <div>📅 <%= c.getFecha().toLocalDate().format(fmt) %> - ⏰ <%= c.getHora() %></div>
                <div style="color:#666;">📍 <%= c.getLugar() %></div>
                <% if(c.getObservaciones() != null && !c.getObservaciones().isEmpty()) { %>
                    <div style="margin-top:5px; font-style:italic; color:#888;">📝 <%= c.getObservaciones() %></div>
                <% } %>
            </div>
        <% }} else { %>
            <p style="text-align:center; color:#888;">No tienes citas pendientes.</p>
        <% } %>

        <div style="text-align:center;">
            <details>
                <summary>📂 Ver Historial</summary>
                <table class="tabla-historial">
                    <% if(historial != null) { for(CitaTati h : historial) { %>
                        <tr>
                            <td><%= h.getFecha().toLocalDate().format(fmt) %></td>
                            <td><strong><%= h.getEspecialista() %></strong></td>
                            <td><%= h.getLugar() %></td>
                        </tr>
                    <% }} %>
                </table>
            </details>
        </div>
    </div>
</body>
</html>
