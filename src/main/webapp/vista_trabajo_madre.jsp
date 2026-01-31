<%-- 
    Document   : vista_trabajo_madre
    Created on : 31 ene 2026, 13:42:57
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.DiaTrabajo" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<DiaTrabajo> lista = (List<DiaTrabajo>) request.getAttribute("listaTrabajo");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));

    // Recuperamos los contadores
    int cVac = (int) request.getAttribute("countVacaciones");
    int cMos = (int) request.getAttribute("countMoscosos");
    int cLib = (int) request.getAttribute("countLibre");
    boolean hasSanNicasio = (boolean) request.getAttribute("checkSanNicasio");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión Trabajo</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e3f2fd; padding: 15px; margin: 0; color: #333; }
        .container { max-width: 650px; margin: 0 auto; }
        
        h1 { text-align: center; color: #1565c0; margin-bottom: 20px; text-transform: uppercase; font-size: 1.4em; }
        .btn-volver { color: #1565c0; text-decoration: none; font-weight: bold; display: inline-block; margin-bottom: 15px; }

        /* DASHBOARD - TARJETAS DE CONTADORES */
        .dashboard { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 25px; }
        .card-stat { background: white; padding: 15px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); text-align: center; }
        .stat-num { font-size: 1.8em; font-weight: bold; color: #1565c0; }
        .stat-label { font-size: 0.85em; color: #666; text-transform: uppercase; margin-top: 5px; }
        
        /* FORMULARIO */
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #2196f3; margin-bottom: 30px; }
        input, select { width: 100%; padding: 12px; margin-bottom: 12px; border: 1px solid #bbdefb; border-radius: 10px; box-sizing: border-box; font-size: 1em; }
        button { background: #1565c0; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; font-size: 1.1em; }

        /* LISTADO HISTORIAL */
        .item-row { 
            background: white; border-radius: 12px; padding: 15px; margin-bottom: 10px; 
            display: flex; justify-content: space-between; align-items: center;
            border-left: 6px solid #ccc; box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        /* COLORES SEGÚN TIPO */
        .t-VACACIONES { border-left-color: #ff9800; } /* Naranja */
        .t-ASUNTOS { border-left-color: #4caf50; }    /* Verde */
        .t-LIBRE { border-left-color: #00bcd4; }      /* Cian */
        .t-SAN { border-left-color: #f44336; }        /* Rojo */
        .t-CAMBIO { border-left-color: #9c27b0; }     /* Morado */

        .date-box { font-weight: bold; color: #333; font-size: 1.1em; }
        .type-badge { font-size: 0.85em; color: #666; background: #f5f5f5; padding: 3px 8px; border-radius: 5px; margin-top: 5px; display: inline-block; }
        .btn-del { text-decoration: none; font-size: 1.2em; color: #e57373; margin-left: 10px; }

        /* Icono visual de OK para San Nicasio */
        .check-ok { color: #4caf50; font-size: 1.2em; }
        .check-no { color: #ccc; font-size: 1.2em; filter: grayscale(100%); opacity: 0.5;}
    </style>
    <script>
        function actualizarSubtipo(select) {
            const subtipo = document.getElementById("subtipo");
            const val = select.value;
            
            // Limpiar opciones
            subtipo.innerHTML = "";
            
            if (val === "VACACIONES") {
                addOption(subtipo, "Verano", "Verano");
                addOption(subtipo, "Invierno", "Invierno");
            } else if (val === "ASUNTOS PROPIOS") {
                addOption(subtipo, "Normal (6+2)", "Normal");
                addOption(subtipo, "Nochebuena", "Nochebuena");
                addOption(subtipo, "Nochevieja", "Nochevieja");
            } else if (val === "CAMBIO") {
                addOption(subtipo, "Turno Mañana", "Mañana");
                addOption(subtipo, "Turno Tarde", "Tarde");
                addOption(subtipo, "Turno Noche", "Noche");
            } else {
                addOption(subtipo, "General", "General");
            }
        }
        
        function addOption(select, text, value) {
            let opt = document.createElement("option");
            opt.text = text;
            opt.value = value;
            select.add(opt);
        }
    </script>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        <h1>💼 Control Trabajo</h1>

        <div class="dashboard">
            <div class="card-stat">
                <div class="stat-num" style="color:#4caf50;"><%= cMos %></div>
                <div class="stat-label">Asuntos Propios</div>
            </div>
            <div class="card-stat">
                <div class="stat-num" style="color:#ff9800;"><%= cVac %></div>
                <div class="stat-label">Días Vacaciones</div>
            </div>
            <div class="card-stat">
                <div class="stat-num" style="color:#00bcd4;"><%= cLib %></div>
                <div class="stat-label">Libre Disposic.</div>
            </div>
            <div class="card-stat">
                <div class="stat-num">
                    <%= hasSanNicasio ? "✅" : "❌" %>
                </div>
                <div class="stat-label">San Nicasio</div>
            </div>
        </div>

        <div class="form-box">
            <h3 style="margin-top:0; color:#1565c0;">📅 Pedir Día / Cambio</h3>
            <form action="TrabajoMadreServlet" method="POST">
                <label>Fecha:</label>
                <input type="date" name="fecha" required>

                <label>Tipo de Día:</label>
                <select name="tipo" onchange="actualizarSubtipo(this)" required>
                    <option value="" disabled selected>-- Selecciona --</option>
                    <option value="ASUNTOS PROPIOS">🟢 Asuntos Propios (Moscosos)</option>
                    <option value="VACACIONES">☀️ Vacaciones</option>
                    <option value="LIBRE DISPOSICION">🔵 Libre Disposición</option>
                    <option value="DIAS VERANO">🏖️ Días de Verano</option>
                    <option value="SAN NICASIO">🐂 San Nicasio</option>
                    <option value="CAMBIO">🔄 Cambio de Turno</option>
                </select>

                <label>Detalle:</label>
                <select name="subtipo" id="subtipo">
                    <option value="General">General</option>
                </select>

                <input type="text" name="observaciones" placeholder="Notas (Con quién cambias, etc...)">
                
                <button type="submit">Guardar</button>
            </form>
        </div>

        <% if(lista != null && !lista.isEmpty()) { 
            for(DiaTrabajo d : lista) { 
                String estilo = "t-VACACIONES"; // Default
                if(d.getTipo().contains("ASUNTOS")) estilo = "t-ASUNTOS";
                if(d.getTipo().contains("LIBRE")) estilo = "t-LIBRE";
                if(d.getTipo().contains("SAN")) estilo = "t-SAN";
                if(d.getTipo().contains("CAMBIO")) estilo = "t-CAMBIO";
        %>
            <div class="item-row <%= estilo %>">
                <div>
                    <div class="date-box"><%= d.getFecha().toLocalDate().format(fmt) %></div>
                    <div class="type-badge"><%= d.getTipo() %> 
                        <% if(!d.getSubtipo().equals("General")) { %> • <%= d.getSubtipo() %> <% } %>
                    </div>
                    <% if(d.getObservaciones() != null && !d.getObservaciones().isEmpty()) { %>
                        <div style="font-size:0.85em; color:#888; margin-top:3px;">📝 <%= d.getObservaciones() %></div>
                    <% } %>
                </div>
                <a href="TrabajoMadreServlet?accion=borrar&id=<%= d.getId() %>" class="btn-del" onclick="return confirm('¿Borrar?')">🗑️</a>
            </div>
        <% }} else { %>
            <p style="text-align: center; color: #999;">No hay días registrados.</p>
        <% } %>
    </div>
</body>
</html>
