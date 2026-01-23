<%-- 
    Document   : vista_mayores
    Created on : 20 dic 2025, 12:49:45
    Updated on : 24 ene 2026 (Separación Historial)
    Author     : Asus & Gemini
--%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="logica.Cita" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%
    // TRUCO DE SEGURIDAD:
    // Si entramos aquí y la lista de citas está vacía (null), significa que
    // no hemos pasado por el Servlet (el camarero).
    // Así que obligamos al navegador a ir al Servlet primero.
    if (request.getAttribute("misCitas") == null) {
        response.sendRedirect("CitasServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas Médicas - Vista Familiar</title>
    <style>
        /* Estilos Base Pastel */
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #fdfcfb 0%, #e2d1c3 100%); margin: 0; padding: 15px; color: #444; }
        h1 { text-align: center; color: #546e7a; font-size: 1.8em; margin-bottom: 20px; }

        /* Botonera */
        .botonera { display: flex; justify-content: center; gap: 10px; margin-bottom: 20px; }
        .btn-nav { border: none; padding: 15px 20px; border-radius: 15px; font-weight: bold; font-size: 1em; cursor: pointer; box-shadow: 0 4px 10px rgba(0,0,0,0.1); text-decoration: none; display: inline-block; }
        .btn-cal { background-color: #c8e6c9; color: #2e7d32; }
        .btn-logout { background-color: #ffcdd2; color: #b71c1c; }
        
        .btn-admin {
            background-color: #28a745; 
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-admin:hover { background-color: #218838; }

        /* Paneles de Citas */
        .contenedor-citas { display: flex; flex-direction: column; gap: 20px; }
        .titulo-usuario { font-size: 1.8em; text-align: center; margin-bottom: 15px; }
        .panel-abuelo { background-color: #e3f2fd; border-radius: 25px; padding: 15px; border-left: 10px solid #90caf9; }
        .panel-abuela { background-color: #fce4ec; border-radius: 25px; padding: 15px; border-left: 10px solid #f48fb1; }
        .cita-card { background: white; border-radius: 18px; padding: 15px; margin-bottom: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.03); }
        .cita-fecha { font-weight: bold; color: #d32f2f; font-size: 1.25em; text-transform: capitalize; }

        /* Calendario y Colores */
        #seccion-calendario { display: none; background: white; border-radius: 25px; padding: 20px; margin-bottom: 25px; box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center; }
        .calendar-day { padding: 15px 2px; border-radius: 10px; background: #fafafa; font-size: 1.1em; cursor: pointer; border: 2px solid transparent; }
        
        .has-cita-abuelo { background: #bbdefb !important; border-color: #90caf9 !important; color: #0d47a1 !important; font-weight: bold; }
        .has-cita-abuela { background: #f8bbd0 !important; border-color: #f48fb1 !important; color: #880e4f !important; font-weight: bold; }
        .has-cita-ambos { background: linear-gradient(135deg, #bbdefb 50%, #f8bbd0 50%) !important; border-color: #ce93d8 !important; font-weight: bold; }

        /* Modal de Detalles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-contenido { background: white; margin: 20% auto; padding: 25px; border-radius: 25px; width: 85%; max-width: 400px; position: relative; }
        .cerrar-modal { float: right; font-size: 28px; font-weight: bold; cursor: pointer; color: #999; }

        /* Estilos del Historial (NUEVO) */
        .historial-container { margin-top: 40px; text-align: center; padding-bottom: 40px; }
        details summary {
            background-color: #78909c; color: white; padding: 12px 25px; border-radius: 20px;
            cursor: pointer; font-size: 1.1em; font-weight: bold; display: inline-block; box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        details[open] summary { background-color: #546e7a; }
        .tabla-historial { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 10px; overflow: hidden; font-size: 0.9em; }
        .tabla-historial th { background-color: #cfd8dc; padding: 10px; text-align: left; }
        .tabla-historial td { border-bottom: 1px solid #eee; padding: 10px; }
    </style>
</head>
<body onload="actualizarCalendario()">

    <h1>📅 Mis Citas Médicas</h1>

    <div class="botonera">
        <a href="index.html" class="btn-nav btn-logout">🔒 Cerrar</a>
        <button class="btn-nav btn-cal" onclick="toggleCalendario()">Ver Calendario</button>
        <a href="admin_panel.jsp" class="btn-nav btn-admin">➕ Nueva</a>
    </div>

    <div id="seccion-calendario">
        <div class="cal-header">
            <button class="btn-nav" style="padding: 5px 15px" onclick="cambiarMes(-1)">◀</button>
            <div id="mes-anio" style="font-weight: bold; font-size: 1.2em;"></div>
            <button class="btn-nav" style="padding: 5px 15px" onclick="cambiarMes(1)">▶</button>
        </div>
        <div class="calendar-grid" id="grid-dias">
            <div style="font-weight: bold; color: #88a0a8;">L</div><div style="font-weight: bold; color: #88a0a8;">M</div>
            <div style="font-weight: bold; color: #88a0a8;">X</div><div style="font-weight: bold; color: #88a0a8;">J</div>
            <div style="font-weight: bold; color: #88a0a8;">V</div><div style="font-weight: bold; color: #88a0a8;">S</div>
            <div style="font-weight: bold; color: #88a0a8;">D</div>
        </div>
    </div>

    <div id="modalCita" class="modal">
        <div class="modal-contenido">
            <span class="cerrar-modal" onclick="cerrarModal()">&times;</span>
            <h2 id="modal-titulo" style="margin-top: 0; color: #546e7a;">Citas del día</h2>
            <div id="modal-detalle"></div>
        </div>
    </div>

    <div class="contenedor-citas">
        <%
            // 1. RECUPERAR DATOS DEL SERVLET (Ya no hacemos SQL aquí)
            List<Cita> listaPendientes = (List<Cita>) request.getAttribute("misCitas");
            List<Cita> listaHistorial = (List<Cita>) request.getAttribute("historialCitas");

            // Si se accede directo al JSP sin pasar por Servlet, evitamos error null
            if(listaPendientes == null) listaPendientes = new ArrayList<>();
            if(listaHistorial == null) listaHistorial = new ArrayList<>();

            // Variables para construir HTML
            StringBuilder htmlAbuelo = new StringBuilder();
            StringBuilder htmlAbuela = new StringBuilder();
            StringBuilder jsData = new StringBuilder("[");
            
            DateTimeFormatter fmtBonito = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("es", "ES"));

            // 2. PROCESAR LISTA DE PENDIENTES (Para las tarjetas visibles)
            for(Cita c : listaPendientes) {
                String fechaBonita = c.getFecha().toLocalDate().format(fmtBonito);
                
                String card = "<div class='cita-card'>" +
                              "<div class='cita-fecha'>" + fechaBonita + " - " + c.getHora() + "</div>" +
                              "<div>📍 " + c.getLugar() + "</div>" +
                              "<div>⚕️ Médico: " + c.getMedico() + "</div>" +
                              "<div>📝 " + (c.getObservaciones() != null ? c.getObservaciones() : "") + "</div>" +
                              "</div>";

                if(c.getUsuario().equalsIgnoreCase("Abuelo")) htmlAbuelo.append(card);
                else if(c.getUsuario().equalsIgnoreCase("Abuela")) htmlAbuela.append(card);
            }

            // 3. PROCESAR CALENDARIO (Pendientes + Historial para que el calendario tenga todo)
            List<Cita> todasLasCitas = new ArrayList<>(listaPendientes);
            todasLasCitas.addAll(listaHistorial);
            boolean primero = true;
            
            for(Cita c : todasLasCitas) {
                if(!primero) jsData.append(",");
                jsData.append("{fecha:'").append(c.getFecha().toString())
                      .append("', usuario:'").append(c.getUsuario())
                      .append("', hora:'").append(c.getHora())
                      .append("', lugar:'").append(c.getLugar())
                      .append("', medico:'").append(c.getMedico())
                      .append("', obs:'").append(c.getObservaciones() != null ? c.getObservaciones().replace("\n", " ") : "").append("'}");
                primero = false;
            }
            jsData.append("]");
        %>
        
        <div class="panel-abuelo">
            <div class="titulo-usuario">👴 Citas del Abuelo</div>
            <div><%= htmlAbuelo.length() > 0 ? htmlAbuelo.toString() : "<p>No hay citas próximas.</p>" %></div>
        </div>

        <div class="panel-abuela">
            <div class="titulo-usuario">👵 Citas de la Abuela</div>
            <div><%= htmlAbuela.length() > 0 ? htmlAbuela.toString() : "<p>No hay citas próximas.</p>" %></div>
        </div>
    </div>

    <div class="historial-container">
        <details>
            <summary>📂 Ver Registro de Citas Anteriores</summary>
            
            <table class="tabla-historial">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Quién</th>
                        <th>Médico</th>
                        <th>Lugar</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if(listaHistorial.isEmpty()) { 
                    %>
                        <tr><td colspan="4" style="text-align:center;">No hay historial registrado.</td></tr>
                    <% 
                    } else {
                        for(Cita h : listaHistorial) { 
                    %>
                        <tr>
                            <td><%= h.getFecha().toString() %></td>
                            <td><%= h.getUsuario() %></td>
                            <td><%= h.getMedico() %></td>
                            <td><%= h.getLugar() %></td>
                        </tr>
                    <% 
                        } 
                    } 
                    %>
                </tbody>
            </table>
        </details>
    </div>

    <script>
        // Los datos ahora vienen de la lista combinada (pasado + futuro)
        const citasData = <%= jsData.toString() %>;
        
        let fechaActual = new Date();
        const nombresMeses = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];

        function toggleCalendario() {
            const sec = document.getElementById("seccion-calendario");
            sec.style.display = (sec.style.display === "none" || sec.style.display === "") ? "block" : "none";
        }

        function cambiarMes(delta) {
            fechaActual.setMonth(fechaActual.getMonth() + delta);
            actualizarCalendario();
        }

        function actualizarCalendario() {
            const grid = document.getElementById("grid-dias");
            const label = document.getElementById("mes-anio");
            while (grid.children.length > 7) grid.removeChild(grid.lastChild);
            
            const mes = fechaActual.getMonth();
            const anio = fechaActual.getFullYear();
            label.innerText = nombresMeses[mes] + " " + anio;

            const primerDia = new Date(anio, mes, 1).getDay();
            const ajuste = (primerDia === 0) ? 6 : primerDia - 1;
            const totalDias = new Date(anio, mes + 1, 0).getDate();

            for (let e = 0; e < ajuste; e++) grid.appendChild(document.createElement("div"));

            for (let i = 1; i <= totalDias; i++) {
                const fISO = anio + "-" + (mes + 1).toString().padStart(2, '0') + "-" + i.toString().padStart(2, '0');
                const citasDia = citasData.filter(c => c.fecha === fISO);
                
                const div = document.createElement("div");
                div.className = "calendar-day";
                div.innerText = i;

                if(citasDia.length > 0) {
                    const tieneAbuelo = citasDia.some(c => c.usuario.toLowerCase() === "abuelo");
                    const tieneAbuela = citasDia.some(c => c.usuario.toLowerCase() === "abuela");
                    
                    if(tieneAbuelo && tieneAbuela) div.classList.add("has-cita-ambos");
                    else if(tieneAbuelo) div.classList.add("has-cita-abuelo");
                    else if(tieneAbuela) div.classList.add("has-cita-abuela");

                    div.onclick = () => mostrarDetalles(i, mes, anio, citasDia);
                }
                grid.appendChild(div);
            }
        }

        function mostrarDetalles(dia, mes, anio, citas) {
            const modal = document.getElementById("modalCita");
            const detalle = document.getElementById("modal-detalle");
            document.getElementById("modal-titulo").innerText = "Citas del " + dia + " de " + nombresMeses[mes].toLowerCase();
            
            let html = "";
            citas.forEach(c => {
                const colorBorder = c.usuario.toLowerCase() === "abuelo" ? "#90caf9" : "#f48fb1";
                html += "<div style='border-left: 6px solid " + colorBorder + "; padding-left: 15px; margin-bottom: 20px;'>" +
                        "<strong style='font-size:1.1em;'>" + c.usuario + " (" + c.hora + ")</strong><br>" +
                        "📍 " + c.lugar + "<br>👨‍⚕️ " + c.medico + "<br><i>" + (c.obs ? c.obs : "") + "</i></div>";
            });
            detalle.innerHTML = html;
            modal.style.display = "block";
        }

        function cerrarModal() { document.getElementById("modalCita").style.display = "none"; }
        window.onclick = (e) => { if(e.target == document.getElementById("modalCita")) cerrarModal(); }
    </script>
</body>
</html>