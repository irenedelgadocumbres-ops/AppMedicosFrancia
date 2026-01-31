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
    <title>Agenda Mamá</title>
    <style>
        /* ESTILO GENERAL MODERNO */
        body { font-family: 'Segoe UI', system-ui, sans-serif; background: #fdf2f8; padding: 20px; margin: 0; color: #444; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 25px; padding: 25px; box-shadow: 0 15px 35px rgba(233, 30, 99, 0.1); }
        
        h1 { text-align: center; color: #880e4f; margin-top: 0; font-weight: 700; letter-spacing: -0.5px; }
        .btn-volver { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #ad1457; font-weight: bold; font-size: 0.9em; transition: transform 0.2s; }
        .btn-volver:active { transform: scale(0.95); }

        /* LEYENDA */
        .leyenda { display: flex; justify-content: center; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; }
        .leyenda-item { display: flex; align-items: center; gap: 6px; font-size: 0.85em; font-weight: 600; color: #666; background: #f8f9fa; padding: 5px 12px; border-radius: 20px; }
        .dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; }
        
        /* COLORES */
        .c-CITA { background-color: #e91e63; box-shadow: 0 0 5px rgba(233, 30, 99, 0.4); }      
        .c-FARMACIA { background-color: #00897b; box-shadow: 0 0 5px rgba(0, 137, 123, 0.4); }  
        .c-HOGAR { background-color: #d32f2f; box-shadow: 0 0 5px rgba(211, 47, 47, 0.4); }     

        /* CABECERA CALENDARIO */
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 0 10px; }
        .btn-nav { background: #fce4ec; border: none; width: 40px; height: 40px; border-radius: 50%; cursor: pointer; color: #ad1457; font-weight: bold; font-size: 1.2em; display: flex; align-items: center; justify-content: center; transition: background 0.3s; }
        .btn-nav:hover { background: #f8bbd0; }
        #mes-anio { font-size: 1.4em; color: #880e4f; font-weight: 700; text-transform: capitalize; }

        /* REJILLA */
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px; text-align: center; }
        .cal-day-header { font-weight: 700; color: #999; font-size: 0.8em; padding-bottom: 10px; }
        
        /* DÍA INDIVIDUAL */
        .calendar-day { 
            min-height: 85px; background: #ffffff; border-radius: 16px; padding: 6px; 
            border: 1px solid #f0f0f0; display: flex; flex-direction: column; align-items: center;
            transition: all 0.2s ease; cursor: default; position: relative;
        }
        .calendar-day.clickable { cursor: pointer; }
        .calendar-day.clickable:active { transform: scale(0.95); background: #fff0f6; }
        
        .day-number { font-weight: 600; font-size: 0.95em; color: #555; margin-bottom: 4px; }
        .hoy { background: #fce4ec !important; border: 2px solid #f48fb1 !important; }
        .hoy .day-number { color: #880e4f; }

        /* PUNTITOS */
        .event-dots { display: flex; gap: 3px; flex-wrap: wrap; justify-content: center; width: 100%; }
        .mini-dot { width: 8px; height: 8px; border-radius: 50%; }

        /* --- VENTANA EMERGENTE (MODAL) --- */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.4); backdrop-filter: blur(3px); z-index: 1000;
            justify-content: center; align-items: center;
            animation: fadeIn 0.2s;
        }
        .modal-content {
            background: white; width: 85%; max-width: 380px; border-radius: 25px; padding: 25px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2); position: relative;
            transform: translateY(20px); animation: slideUp 0.3s forwards;
        }
        @keyframes fadeIn { from {opacity:0;} to {opacity:1;} }
        @keyframes slideUp { to {transform: translateY(0);} }

        .modal-header { font-size: 1.3em; font-weight: 700; color: #880e4f; margin-bottom: 15px; border-bottom: 2px solid #fce4ec; padding-bottom: 10px; }
        .close-btn { position: absolute; top: 20px; right: 25px; font-size: 1.5em; color: #aaa; cursor: pointer; }
        
        /* Items dentro del modal */
        .evento-item { 
            padding: 12px; margin-bottom: 10px; border-radius: 12px; background: #f9f9f9; 
            border-left: 5px solid #ccc; font-size: 0.95em; display: flex; align-items: center; gap: 10px;
        }
        .b-CITA { border-left-color: #e91e63; background: #fff0f5; color: #880e4f; }
        .b-FARMACIA { border-left-color: #00897b; background: #e0f2f1; color: #004d40; }
        .b-HOGAR { border-left-color: #d32f2f; background: #ffebee; color: #b71c1c; }

    </style>
</head>
<body onload="renderCalendar()">
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        <h1>📅 Calendario</h1>

        <div class="leyenda">
            <div class="leyenda-item"><span class="dot c-CITA"></span> Medicos</div>
            <div class="leyenda-item"><span class="dot c-FARMACIA"></span> Farmacia</div>
            <div class="leyenda-item"><span class="dot c-HOGAR"></span> Hogar</div>
        </div>

        <div class="cal-header">
            <button class="btn-nav" onclick="cambiarMes(-1)">‹</button>
            <div id="mes-anio"></div>
            <button class="btn-nav" onclick="cambiarMes(1)">›</button>
        </div>

        <div class="calendar-grid" id="grid"></div>
    </div>

    <div id="modal" class="modal-overlay" onclick="cerrarModal(event)">
        <div class="modal-content">
            <span class="close-btn" onclick="document.getElementById('modal').style.display='none'">&times;</span>
            <div id="modal-fecha" class="modal-header"></div>
            <div id="modal-lista"></div>
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

            // Días de la semana
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

            // Rellenar huecos vacíos
            for(let i=0; i<ajuste; i++) {
                const empty = document.createElement("div");
                empty.style.background = "transparent";
                grid.appendChild(empty);
            }

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
                
                cell.innerHTML = "<span class='day-number'>" + i + "</span>";

                if(eventosDia.length > 0) {
                    cell.classList.add("clickable");
                    const dotsContainer = document.createElement("div");
                    dotsContainer.className = "event-dots";
                    
                    eventosDia.forEach(ev => {
                        const dot = document.createElement("div");
                        dot.className = "mini-dot c-" + ev.tipo; 
                        dotsContainer.appendChild(dot);
                    });
                    cell.appendChild(dotsContainer);
                    
                    // Al hacer clic, abrimos el MODAL
                    cell.onclick = () => abrirModal(i, mes, anio, eventosDia);
                }
                grid.appendChild(cell);
            }
        }

        function abrirModal(dia, mes, anio, lista) {
            const modal = document.getElementById('modal');
            const titulo = document.getElementById('modal-fecha');
            const contenido = document.getElementById('modal-lista');
            
            titulo.innerText = dia + " de " + meses[mes];
            contenido.innerHTML = "";

            lista.forEach(ev => {
                const item = document.createElement("div");
                // Asigna clase b-CITA, b-FARMACIA o b-HOGAR para colorear el fondo
                item.className = "evento-item b-" + ev.tipo; 
                item.innerHTML = "<span>" + ev.titulo + "</span>";
                contenido.appendChild(item);
            });

            modal.style.display = "flex";
        }

        function cerrarModal(e) {
            // Cierra solo si pulsamos en el fondo oscuro (overlay) o en la X
            if(e.target.id === 'modal') {
                document.getElementById('modal').style.display = 'none';
            }
        }
    </script>
</body>
</html>