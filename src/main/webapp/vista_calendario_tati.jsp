<%-- 
    Document   : vista_calendario_tati
    Created on : 24 ene 2026, 22:01:07
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.EventoTati" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<EventoTati> lista = (List<EventoTati>) request.getAttribute("listaTotal");
    
    // CONSTRUIR EL JSON
    StringBuilder jsData = new StringBuilder("[");
    boolean primero = true;
    if (lista != null) {
        for(EventoTati e : lista) {
            if(!primero) jsData.append(",");
            // Limpiamos caracteres que rompen el JS
            String tituloSafe = e.getTitulo().replace("'", "\\'").replace("\"", "\\\"");
            String subSafe = e.getSubtitulo() != null ? e.getSubtitulo().replace("'", "\\'").replace("\"", "\\\"") : "";
            String notasSafe = e.getNotas() != null ? e.getNotas().replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ") : "";
            
            jsData.append("{fecha:'").append(e.getFecha().toString())
                  .append("', titulo:'").append(tituloSafe)
                  .append("', detalle:'").append(subSafe)
                  .append("', notas:'").append(notasSafe)
                  .append("', tipo:'").append(e.getTipo()).append("'}");
            primero = false;
        }
    }
    jsData.append("]");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendario Tati</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e0f2f1; padding: 20px; color: #444; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 20px; padding: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        h1 { text-align: center; color: #00695c; margin-top: 0; }
        .btn-volver { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #00897b; font-weight: bold; }

        /* LEYENDA */
        .leyenda { display: flex; justify-content: center; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
        .leyenda-item { display: flex; align-items: center; gap: 5px; font-size: 0.85em; font-weight: bold; color: #555; }
        .dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }
        
        /* COLORES */
        .c-MEDICO_TATI { background-color: #e91e63; box-shadow: 0 0 5px rgba(233, 30, 99, 0.4); } 
        .c-MEDICO_TIO { background-color: #1976d2; box-shadow: 0 0 5px rgba(25, 118, 210, 0.4); }
        .c-MASCOTA { background-color: #ff7043; } 
        .c-HOGAR { background-color: #3949ab; }   

        /* CALENDARIO */
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .btn-nav { background: #e0f2f1; border: none; padding: 8px 20px; border-radius: 20px; cursor: pointer; font-size: 1.2em; color: #00695c; font-weight: bold; }
        
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center; }
        .cal-day-header { font-weight: bold; color: #aaa; padding-bottom: 10px; font-size: 0.9em; }
        
        .calendar-day { 
            min-height: 80px; background: #fafafa; border-radius: 10px; padding: 5px; cursor: pointer; 
            border: 2px solid transparent; display: flex; flex-direction: column; align-items: center;
            transition: background 0.2s;
        }
        .calendar-day:hover { background: #f0f0f0; }
        .hoy { border-color: #00bcd4; background: #e0f7fa; }
        
        .event-dots { display: flex; gap: 4px; margin-top: 8px; flex-wrap: wrap; justify-content: center; }
        .mini-dot { width: 10px; height: 10px; border-radius: 50%; box-shadow: 0 1px 2px rgba(0,0,0,0.2); }

        /* MODAL */
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
        .modal-content { 
            background: white; margin: 20% auto; padding: 25px; border-radius: 25px; 
            width: 85%; max-width: 400px; position: relative; box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: slideUp 0.3s;
        }
        @keyframes slideUp { from {transform: translateY(50px); opacity: 0;} to {transform: translateY(0); opacity: 1;} }
        
        .close { float: right; font-size: 28px; font-weight: bold; cursor: pointer; color: #aaa; }
        
        /* TARJETAS DENTRO DEL POPUP */
        .modal-item { 
            padding: 15px; border-radius: 12px; margin-bottom: 12px; 
            border-left: 6px solid #ccc; background: #f5f5f5; 
            text-align: left;
        }
        
        .b-MEDICO_TATI { border-left-color: #e91e63; background: #fce4ec; color: #880e4f; }
        .b-MEDICO_TIO  { border-left-color: #1976d2; background: #e3f2fd; color: #0d47a1; }
        .b-MASCOTA { border-left-color: #ff7043; background: #fbe9e7; color: #bf360c; }
        .b-HOGAR { border-left-color: #3949ab; background: #e8eaf6; color: #1a237e; }

        .item-titulo { font-weight: bold; font-size: 1.1em; margin-bottom: 5px; }
        .item-detalle { font-size: 0.95em; opacity: 0.9; margin-bottom: 5px; }
        .item-notas { font-size: 0.9em; font-style: italic; opacity: 0.8; border-top: 1px solid rgba(0,0,0,0.1); padding-top: 5px; margin-top: 5px; }

    </style>
</head>
<body onload="renderCalendar()">
    <div class="container">
        <a href="vista_tati.jsp" class="btn-volver">⬅ Volver al Panel</a>
        <h1>📅 Agenda Global Tati</h1>

        <div class="leyenda">
            <div class="leyenda-item"><span class="dot c-MEDICO_TATI"></span> Tati</div>
            <div class="leyenda-item"><span class="dot c-MEDICO_TIO"></span> Tío</div>
            <div class="leyenda-item"><span class="dot c-MASCOTA"></span> Mascotas</div>
            <div class="leyenda-item"><span class="dot c-HOGAR"></span> Hogar</div>
        </div>

        <div class="cal-header">
            <button class="btn-nav" onclick="cambiarMes(-1)">◀</button>
            <div id="mes-anio" style="font-weight: bold; font-size: 1.3em; color: #333;"></div>
            <button class="btn-nav" onclick="cambiarMes(1)">▶</button>
        </div>

        <div class="calendar-grid" id="grid"></div>
    </div>

    <div id="modal" class="modal" onclick="if(event.target == this) closeModal()">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modal-date" style="margin-top:0; color: #00796b; border-bottom: 1px solid #eee; padding-bottom: 10px;"></h2>
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

            const hoy = new Date();
            for(let i=1; i<=diasMes; i++) {
                const mesStr = (mes+1).toString().padStart(2,'0');
                const diaStr = i.toString().padStart(2,'0');
                const fISO = anio + "-" + mesStr + "-" + diaStr;
                
                const eventosDia = eventos.filter(e => e.fecha === fISO);

                const cell = document.createElement("div");
                cell.className = "calendar-day";
                if(i === hoy.getDate() && mes === hoy.getMonth() && anio === hoy.getFullYear()) {
                    cell.classList.add("hoy");
                }
                
                cell.innerHTML = "<div style='font-weight:bold; color:#555;'>" + i + "</div>";

                if(eventosDia.length > 0) {
                    const dotsContainer = document.createElement("div");
                    dotsContainer.className = "event-dots";
                    
                    eventosDia.forEach(ev => {
                        const dot = document.createElement("div");
                        dot.className = "mini-dot c-" + ev.tipo;
                        dotsContainer.appendChild(dot);
                    });
                    cell.appendChild(dotsContainer);
                    
                    cell.onclick = () => openModal(i, mes, anio, eventosDia);
                    cell.style.backgroundColor = "#e0f2f1"; 
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
                const div = document.createElement("div");
                div.className = "modal-item b-" + ev.tipo;
                
                // Construimos el HTML de la tarjeta con toda la info
                let html = "<div class='item-titulo'>" + ev.titulo + "</div>" +
                           "<div class='item-detalle'>" + ev.detalle + "</div>";
                
                // Si hay notas, las añadimos
                if (ev.notas && ev.notas !== "") {
                    html += "<div class='item-notas'>📝 " + ev.notas + "</div>";
                }

                div.innerHTML = html;
                body.appendChild(div);
            });
            modal.style.display = "block";
        }

        function closeModal() { 
            document.getElementById("modal").style.display = "none"; 
        }
    </script>
</body>
</html>