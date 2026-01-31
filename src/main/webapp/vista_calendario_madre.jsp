<%-- 
    Document   : vista_calendario_madre
    Created on : 23 ene 2026, 23:21:42
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.EventoMadre" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<EventoMadre> lista = (List<EventoMadre>) request.getAttribute("listaEventos");
    
    // CONSTRUIR EL JSON
    StringBuilder jsData = new StringBuilder("[");
    boolean primero = true;
    if (lista != null) {
        for(EventoMadre e : lista) {
            if(!primero) jsData.append(",");
            // Escapamos comillas por si acaso
            String tituloSafe = e.getTitulo().replace("'", "\\'");
            
            jsData.append("{fecha:'").append(e.getFecha().toString())
                  .append("', titulo:'").append(tituloSafe)
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
    <title>Calendario Mamá</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fce4ec; padding: 20px; color: #444; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 20px; padding: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        h1 { text-align: center; color: #ad1457; margin-top: 0; }
        .btn-volver { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #ad1457; font-weight: bold; }

        /* LEYENDA */
        .leyenda { display: flex; justify-content: center; gap: 15px; margin-bottom: 20px; }
        .leyenda-item { display: flex; align-items: center; gap: 5px; font-size: 0.9em; font-weight: bold; }
        .dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }
        
        /* COLORES */
        .c-CITA { background-color: #e91e63; }      /* Rosa Fuerte */
        .c-FARMACIA { background-color: #00897b; }  /* Verde Farmacia */

        /* CALENDARIO */
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .btn-nav { background: #fce4ec; border: none; padding: 8px 20px; border-radius: 20px; cursor: pointer; font-size: 1.2em; color: #ad1457; font-weight: bold; }
        
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center; }
        .cal-day-header { font-weight: bold; color: #aaa; padding-bottom: 10px; font-size: 0.9em; }
        
        .calendar-day { 
            min-height: 80px; background: #fafafa; border-radius: 10px; padding: 5px; 
            border: 2px solid transparent; display: flex; flex-direction: column; align-items: center;
        }
        .hoy { border-color: #f06292; background: #f8bbd0; }
        
        .event-dots { display: flex; gap: 4px; margin-top: 8px; flex-wrap: wrap; justify-content: center; }
        .mini-dot { width: 10px; height: 10px; border-radius: 50%; box-shadow: 0 1px 2px rgba(0,0,0,0.2); }
    </style>
</head>
<body onload="renderCalendar()">
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Panel</a>
        <h1>📅 Agenda de Mamá</h1>

        <div class="leyenda">
            <div class="leyenda-item"><span class="dot c-CITA"></span> Citas</div>
            <div class="leyenda-item"><span class="dot c-FARMACIA"></span> Farmacia</div>
        </div>

        <div class="cal-header">
            <button class="btn-nav" onclick="cambiarMes(-1)">◀</button>
            <div id="mes-anio" style="font-weight: bold; font-size: 1.3em; color: #880e4f;"></div>
            <button class="btn-nav" onclick="cambiarMes(1)">▶</button>
        </div>

        <div class="calendar-grid" id="grid"></div>
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
                        dot.className = "mini-dot c-" + ev.tipo; // Usa la clase CSS c-CITA o c-FARMACIA
                        dot.title = ev.titulo; // Al pasar el ratón sale el nombre
                        dotsContainer.appendChild(dot);
                    });
                    cell.appendChild(dotsContainer);
                    
                    // Al hacer clic (alerta simple para ver info rápida)
                    cell.onclick = () => {
                        let mensaje = "📅 Día " + i + ":\n";
                        eventosDia.forEach(e => mensaje += "- " + e.titulo + "\n");
                        alert(mensaje);
                    };
                    cell.style.cursor = "pointer";
                    cell.style.backgroundColor = "#fff0f6"; 
                }
                grid.appendChild(cell);
            }
        }
    </script>
</body>
</html>