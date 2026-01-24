<%-- 
    Document   : vista_mascotas_tati
    Created on : 24 ene 2026, 21:41:46
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.MascotaTati" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<MascotaTati> historial = (List<MascotaTati>) request.getAttribute("historialMascotas");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mascotas Tati</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fff3e0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        
        /* Encabezado */
        h1 { text-align: center; color: #d84315; }
        .btn-volver { color: #d84315; text-decoration: none; font-weight: bold; margin-bottom: 15px; display: inline-block; }

        /* Formulario */
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #ff7043; margin-bottom: 30px; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; }
        input, select { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 10px; }
        button { background: #ff7043; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; font-size: 1.1em; }

        /* Tarjetas */
        .pet-card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); position: relative; border-left: 6px solid #ccc; }
        
        /* Colores por Mascota (Visual) */
        .pet-cuky { border-left-color: #ffca28; } /* Amarillo */
        .pet-leo { border-left-color: #42a5f5; }  /* Azul */
        .pet-thais { border-left-color: #ec407a; } /* Rosa */

        .pet-name { font-weight: bold; text-transform: uppercase; color: #555; font-size: 0.9em; }
        .evento-titulo { font-size: 1.2em; font-weight: bold; color: #333; margin: 5px 0; }
        
        .aviso-proximo {
            background-color: #e3f2fd; color: #1565c0; 
            padding: 8px; border-radius: 8px; margin-top: 10px; 
            display: inline-block; font-size: 0.9em; font-weight: bold;
        }

        .btn-delete { position: absolute; right: 15px; top: 15px; text-decoration: none; font-size: 1.3em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_tati.jsp" class="btn-volver">⬅ Volver al Panel</a>
        <h1>🐾 Historial Mascotas</h1>

        <div class="form-box">
            <h3 style="margin-top:0; color: #bf360c;">➕ Nuevo Evento</h3>
            <form action="MascotasTatiServlet" method="POST">
                <div class="form-row">
                    <select name="nombre_mascota" required>
                        <option value="" disabled selected>-- ¿Quién es? --</option>
                        <option value="Cuky">🐶 Cuky</option>
                        <option value="Leo">🐶 Leo</option>
                        <option value="Thais">🐶 Thais</option>
                        <option value="Otro">🐾 Otro</option>
                    </select>
                    <input type="date" name="fecha" required title="Fecha del evento">
                </div>

                <div class="form-row">
                    <select name="tipo_evento" required>
                        <option value="" disabled selected>-- ¿Qué le hemos hecho? --</option>
                        <option value="Vacuna">💉 Vacuna</option>
                        <option value="Desparasitación Interna">💊 Desparasitación Interna</option>
                        <option value="Desparasitación Externa">💧 Desparasitación Externa (Pipeta/Collar)</option>
                        <option value="Peluquería">✂️ Peluquería</option>
                        <option value="Medicación">💊 Medicación / Tratamiento</option>
                        <option value="Comprar Pienso">🍖 Comprar Pienso</option>
                        <option value="Revisión Vet">🩺 Revisión Veterinario</option>
                        <option value="Otro">📝 Otro</option>
                    </select>
                </div>

                <div class="form-row">
                    <input type="text" name="producto" placeholder="Producto (ej: Bravecto, Royal Canin...)">
                </div>
                
                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Notas (Peso, precio, reacción...)">
                </div>

                <div class="form-row">
                    <label style="align-self:center; font-size:0.9em; color:#d84315;">¿Próxima vez?: </label>
                    <input type="date" name="proxima_fecha" title="Fecha del próximo aviso (Opcional)">
                </div>

                <button type="submit">Guardar en Historial</button>
            </form>
        </div>

        <% if(historial != null && !historial.isEmpty()) { 
            for(MascotaTati m : historial) { 
                String claseColor = "";
                if("Cuky".equals(m.getNombre())) claseColor = "pet-cuky";
                else if("Leo".equals(m.getNombre())) claseColor = "pet-leo";
                else if("Thais".equals(m.getNombre())) claseColor = "pet-thais";
        %>
            <div class="pet-card <%= claseColor %>">
                <a href="MascotasTatiServlet?accion=borrar&id=<%= m.getId() %>" class="btn-delete" onclick="return confirm('¿Borrar este evento?')">🗑️</a>
                
                <div class="pet-name"><%= m.getNombre() %></div>
                <div class="evento-titulo"><%= m.getTipo() %></div>
                <div style="color: #666;">
                    📅 <%= m.getFecha().toLocalDate().format(fmt) %> 
                    <% if(m.getProducto() != null && !m.getProducto().isEmpty()) { %>
                        | 📦 <%= m.getProducto() %>
                    <% } %>
                </div>

                <% if(m.getObservaciones() != null && !m.getObservaciones().isEmpty()) { %>
                    <div style="margin-top:5px; font-style:italic; color:#888;">📝 <%= m.getObservaciones() %></div>
                <% } %>

                <% if(m.getProximaFecha() != null) { %>
                    <div class="aviso-proximo">
                        ⏰ Toca repetir el: <%= m.getProximaFecha().toLocalDate().format(fmt) %>
                    </div>
                <% } %>
            </div>
        <% }} else { %>
            <p style="text-align: center; color: #888;">No hay historial de mascotas aún.</p>
        <% } %>
    </div>
</body>
</html>
