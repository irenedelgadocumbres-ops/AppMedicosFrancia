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
    // Recuperar datos del Servlet
    String persona = (String) request.getAttribute("personaActual");
    List<CitaTati> pendientes = (List<CitaTati>) request.getAttribute("listaPendientes");
    List<CitaTati> historial = (List<CitaTati>) request.getAttribute("listaHistorial");
    
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
    
    // Configuración de Colores según persona
    String colorPrincipal = "#e91e63"; // Rosa por defecto (Tati)
    String colorFondo = "#fce4ec";
    String tituloPage = "Agenda de Tati";
    
    if ("Tio".equals(persona)) {
        colorPrincipal = "#1976d2"; // Azul (Tío)
        colorFondo = "#e3f2fd";
        tituloPage = "Agenda de Tío";
    }

    // Tu lista de especialistas
    String[] especialistas = {
        "Médico Cabecera", "Enfermera", "Traumatólogo", "Enfermera Trauma", 
        "Cirugía Bariátrica", "Endocrino", "Rehabilitación", "Rehabilitador", 
        "Reumatóloga (Autoinmune)", "Reumatóloga", "Otorrino", "Análisis", "Eco", 
        "Radiografía", "TAC / Resonancia", "Digestivo", "Unidad del Dolor", 
        "Ginecólogo", "Trauma Cirugía Ortopédica", "Neurocirujano", "Urólogo", 
        "Neumólogo", "Máquina Apnea Sueño", "Dentista", "Podólogo", "Oculista", "Farmacia Hospital", "Otro"
    };
    // LISTA DE LUGARES
    String[] lugares = {
        "Severo Ochoa", 
        "Hosp. Juan Carlos I Móstoles","Centro Salud", "Enfermera Centro Salud", "Dentista Leganes", 
        "Podologo Leganes", "Otro"
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Médicos Tati y Tío</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: <%= colorFondo %>; padding: 20px; transition: background 0.3s; }
        .container { max-width: 800px; margin: 0 auto; }
        
        /* SELECTOR DE PERSONA (PESTAÑAS) */
        .selector-persona { display: flex; gap: 10px; margin-bottom: 20px; }
        .tab { 
            flex: 1; text-align: center; padding: 15px; border-radius: 15px; 
            text-decoration: none; font-weight: bold; font-size: 1.1em;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); opacity: 0.6; transition: all 0.2s;
            background: white; color: #555;
        }
        .tab.active { opacity: 1; color: white; transform: scale(1.02); }
        .tab-tati.active { background: #e91e63; }
        .tab-tio.active { background: #1976d2; }

        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid <%= colorPrincipal %>; margin-bottom: 25px; }
        input, select { width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        
        button { background: <%= colorPrincipal %>; color: white; width: 100%; padding: 12px; border: none; border-radius: 10px; font-weight: bold; font-size: 1.1em; cursor: pointer; transition: background 0.3s; }
        
        .cita-card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; border-left: 8px solid <%= colorPrincipal %>; box-shadow: 0 4px 8px rgba(0,0,0,0.05); position: relative; }
        .btn-delete { position: absolute; right: 15px; top: 15px; text-decoration: none; font-size: 1.3em; }
        
        details summary { background: #607d8b; color: white; padding: 10px 20px; border-radius: 20px; margin-top: 30px; cursor: pointer; font-weight: bold; display: inline-block; }
        .tabla-historial { width: 100%; background: white; margin-top: 10px; border-radius: 10px; border-collapse: collapse; }
        .tabla-historial td { padding: 10px; border-bottom: 1px solid #eee; }
    </style>
    
    <script>
        function gestionarCampo(select, idInputOculto) {
            var input = document.getElementById(idInputOculto);
            
            if(select.value === "Otro") {
                // Si eligen Otro: Mostramos input, vaciamos y enfocamos
                input.style.display = "block";
                input.value = "";
                input.placeholder = "Escribe aquí...";
                input.required = true;
                input.focus();
            } else {
                // Si eligen lista: Ocultamos input y copiamos el valor
                input.style.display = "none";
                input.value = select.value;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <a href="vista_tati.jsp" style="text-decoration:none; color:<%= colorPrincipal %>; font-weight:bold; display:block; margin-bottom:15px;">⬅ Volver al Panel</a>
        
        <div class="selector-persona">
            <a href="CitasTatiServlet?persona=Tati" class="tab tab-tati <%= "Tati".equals(persona) ? "active" : "" %>">👩 Tati</a>
            <a href="CitasTatiServlet?persona=Tio" class="tab tab-tio <%= "Tio".equals(persona) ? "active" : "" %>">👨 Tío</a>
        </div>

        <h1 style="text-align:center; color:<%= colorPrincipal %>;">🩺 <%= tituloPage %></h1>

        <div class="form-box">
            <form action="CitasTatiServlet" method="POST">
                <input type="hidden" name="persona" value="<%= persona %>">
                
                <input type="date" name="fecha" required>
                <input type="time" name="hora" required>
                
                <select onchange="gestionarCampo(this, 'campo_especialista')" required>
                    <option value="" disabled selected>-- Elige Especialista --</option>
                    <% for(String esp : especialistas) { %>
                        <option value="<%= esp %>"><%= esp %></option>
                    <% } %>
                </select>
                <input type="text" id="campo_especialista" name="especialista" style="display:none;">

                <select onchange="gestionarCampo(this, 'campo_lugar')" required>
                    <option value="" disabled selected>-- Elige Lugar --</option>
                    <% for(String lug : lugares) { %>
                        <option value="<%= lug %>"><%= lug %></option>
                    <% } %>
                </select>
                <input type="text" id="campo_lugar" name="lugar" style="display:none;">

                <input type="text" name="observaciones" placeholder="Notas (llevar papeles, ayunas...)">
                <button type="submit">Guardar Cita para <%= persona %></button>
            </form>
        </div>

        <% if(pendientes != null && !pendientes.isEmpty()) { 
            for(CitaTati c : pendientes) { %>
            <div class="cita-card">
                <a href="CitasTatiServlet?accion=borrar&id=<%= c.getId() %>&persona=<%= persona %>" class="btn-delete" onclick="return confirm('¿Borrar?')">🗑️</a>
                <div style="color:<%= colorPrincipal %>; font-weight:bold; font-size:1.1em;"><%= c.getEspecialista() %></div>
                <div>📅 <%= c.getFecha().toLocalDate().format(fmt) %> - ⏰ <%= c.getHora() %></div>
                <div style="color:#666;">📍 <%= c.getLugar() %></div>
                <% if(c.getObservaciones() != null && !c.getObservaciones().isEmpty()) { %>
                    <div style="margin-top:5px; font-style:italic; color:#888;">📝 <%= c.getObservaciones() %></div>
                <% } %>
            </div>
        <% }} else { %>
            <p style="text-align:center; color:#888;">No hay citas pendientes para <%= persona %>.</p>
        <% } %>

        <div style="text-align:center;">
            <details>
                <summary>📂 Historial de <%= persona %></summary>
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