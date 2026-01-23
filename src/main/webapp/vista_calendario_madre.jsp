<%-- 
    Document   : vista_calendario_madre
    Created on : 23 ene 2026, 23:21:42
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.CitaMadre" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<CitaMadre> lista = (List<CitaMadre>) request.getAttribute("listaTotal");
    // Protección: Si entramos sin datos, volver al Servlet para cargarlos
    if(lista == null) { 
        response.sendRedirect("CalendarioMadreServlet"); 
        return; 
    }

    // CONSTRUIR JSON PARA JAVASCRIPT
    StringBuilder jsData = new StringBuilder("[");
    boolean primero = true;
    for(CitaMadre c : lista) {
        if(!primero) jsData.append(",");
        jsData.append("{fecha:'").append(c.getFecha().toString())
              .append("', hora:'").append(c.getHora())
              .append("', titulo:'").append(c.getTitulo())
              .append("', lugar:'").append(c.getLugar())
              .append("', cat:'").append(c.getCategoria()) 
              .append("', obs:'").append(c.getObservaciones() != null ? c.getObservaciones().replace("\n", " ") : "").append("'}");
        primero = false;
    }
    jsData.append("]");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendario Global</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%); padding: 20px; color: #444; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 20px; padding: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        h1 { text-align: center; color: #8e24aa; margin-top: 0; }
        .btn-volver { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #666; font-weight: bold; }

        /* LEYENDA DE COLORES */
        .leyenda { display: flex; justify-content: center; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .leyenda-item { display: flex; align-items: center; gap: 5px; font-size: 0.9em; }
        .dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }
        
        .c-medico { background-color: #e91e63; }
        .c-cuidados { background-color: #9c27b0; }
        .c-nali { background-color: #4caf50; }

        /* CALENDARIO */
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .btn-nav { background: #f3e5f5; border: none; padding: 5px 15px; border-radius: 10px; cursor: pointer; font-size: 1.2em; color: #8e24aa; }
        
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center; }
        .cal-day-header { font-weight: bold; color: #aaa; padding-bottom: 10px; }
        
        .calendar-day { 
            min-height: 80px; background: #fafafa; border-radius: 10px; padding: 5px; cursor: pointer; 
            border: 2px solid transparent; display: flex; flex-direction: column; align-items: center;
        }
        .calendar-day:hover { background: #f0f0f0; }
        
        /* Puntos dentro del día */
        .event-dots { display: flex; gap: 3px; margin-top: 5px; flex-wrap: wrap; justify-content: center; }
        .mini-dot { width: 8px; height: 8px; border-radius: 50%; }

        /* MODAL */
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-content { background: white; margin: 20% auto; padding: 20px; border-radius: 20px; width: 85%; max-width: 400px; position: relative; }
        .close { float: right; font-size: 28px; font-weight: bold; cursor: pointer; color: #aaa; }
        
        .modal-item { padding: 10px; border-radius: 10px; margin-bottom: 10px; border-left: 5px solid #ccc; background: #f9f9f9; }
        .modal-time { font-weight: bold; font-size: 1.1em; }
    </style>
</head>
<body onload="renderCalendar()">
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        <h1>📅 Calendario</h1>

        <div class="leyenda">
            <div class="leyenda-item"><span class="dot c-medico"></span> Médicos</div>
            <div class="leyenda-item"><span class="dot c-cuidados"></span> Cuidados</div>
            <div class="leyenda-item"><span class="dot c-nali"></span> Nali</div>
        </div>

        <div class="cal-header">
            <button class="btn-nav" onclick="cambiarMes(-1)">◀</button>
            <div id="mes-anio" style="font-weight: bold; font-size: 1.3em; color: #444;"></div>
            <button class="btn-nav" onclick="cambiarMes(1)">▶</button>
        </div>

        <div class="calendar-grid" id="grid"></div>
    </div>

    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modal-date" style="margin-top:0; color: #8e24aa;"></h2>
            <div id="modal-body"></div>
        </div>
    </div>

    <script>
        const eventos = <%= jsData.toString() %>;
        let fechaActual = new Date();
        const meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

        function cambiarMes(d) {
            fechaActual.setMonth(fechaActual.getMonth() + d);
            renderCalendar();
        }

        function renderCalendar() {
            const grid = document.getElementById("grid");
            const label = document.getElementById("mes-anio");
            grid.innerHTML = "";

            // Cabeceras
            ["L","M","X","J","V","S","D"].forEach(d => {
                const div = document.createElement("div");
                div.className = "cal-day-header";
                div.innerText = d;
                grid.appendChild(div);
            });

            const mes = fechaActual.getMonth();
            const anio = fechaActual.getFullYear();
            label.innerText = meses[mes] + " " + anio;

            const primerDia = new Date(anio, mes, 1).getDay();
            const ajuste = (primerDia === 0) ? 6 : primerDia - 1;
            const diasMes = new Date(anio, mes + 1, 0).getDate();

            for(let i=0; i<ajuste; i++) grid.appendChild(document.createElement("div"));

            for(let i=1; i<=diasMes; i++) {
                const fISO = anio + "-" + (mes+1).toString().padStart(2,'0') + "-" + i.toString().padStart(2,'0');
                const eventosDia = eventos.filter(e => e.fecha === fISO);

                const cell = document.createElement("div");
                cell.className = "calendar-day";
                cell.innerHTML = "<strong>" + i + "</strong>";

                if(eventosDia.length > 0) {
                    const dotsContainer = document.createElement("div");
                    dotsContainer.className = "event-dots";
                    
                    eventosDia.forEach(ev => {
                        const dot = document.createElement("div");
                        dot.className = "mini-dot";
                        if(ev.cat === "Medico") dot.classList.add("c-medico");
                        else if(ev.cat === "Cuidados") dot.classList.add("c-cuidados");
                        else if(ev.cat === "Nali") dot.classList.add("c-nali");
                        dotsContainer.appendChild(dot);
                    });
                    cell.appendChild(dotsContainer);
                    cell.onclick = () => openModal(i, mes, anio, eventosDia);
                    cell.style.background = "#f3e5f5";
                    cell.style.borderColor = "#e1bee7";
                }
                grid.appendChild(cell);
            }
        }

        function openModal(dia, mes, anio, lista) {
            const modal = document.getElementById("modal");
            document.getElementById("modal-date").innerText = dia + " de " + meses[mes];
            const body = document.getElementById("modal-body");
            body.innerHTML = "";

            lista.forEach(ev => {
                let color = "#ccc";
                let icono = "📅";
                if(ev.cat === "Medico") { color="#e91e63"; icono="🩺"; }
                else if(ev.cat === "Cuidados") { color="#9c27b0"; icono="💅"; }
                else if(ev.cat === "Nali") { color="#4caf50"; icono="🐶"; }

                const div = document.createElement("div");
                div.className = "modal-item";
                div.style.borderLeftColor = color;
                div.innerHTML = "<div class='modal-time' style='color:"+color+"'>" + icono + " " + ev.hora.substring(0,5) + "</div>" +
                                "<div><strong>" + ev.titulo + "</strong></div>" +
                                "<div style='font-size:0.9em; color:#666;'>📍 " + ev.lugar + "</div>" +
                                (ev.obs ? "<div style='font-style:italic; font-size:0.85em; margin-top:5px;'>📝 " + ev.obs + "</div>" : "");
                body.appendChild(div);
            });
            modal.style.display = "block";
        }

        function closeModal() { document.getElementById("modal").style.display = "none"; }
        window.onclick = (e) => { if(e.target == document.getElementById("modal")) closeModal(); }
    </script>
</body>
</html>
