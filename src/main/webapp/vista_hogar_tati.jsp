<%-- 
    Document   : vista_hogar_tati
    Created on : 24 ene 2026, 21:51:49
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.GestionTati" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<GestionTati> lista = (List<GestionTati>) request.getAttribute("listaHogar");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hogar Tati</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e8eaf6; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        
        h1 { text-align: center; color: #283593; }
        .btn-volver { color: #3949ab; text-decoration: none; font-weight: bold; margin-bottom: 15px; display: inline-block; }

        /* Formulario */
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #3949ab; margin-bottom: 30px; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; }
        input, select { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 10px; }
        button { background: #3949ab; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; font-size: 1.1em; }

        /* Tarjetas */
        .item-card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); position: relative; border-left: 6px solid #9fa8da; }
        
        /* Iconos y Datos */
        .card-header { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .icon-box { background: #e8eaf6; padding: 8px; border-radius: 50%; font-size: 1.2em; }
        .titulo { font-weight: bold; color: #283593; font-size: 1.1em; }
        
        .datos-row { display: flex; justify-content: space-between; font-size: 0.9em; color: #555; margin-bottom: 5px; }
        .precio { color: #d32f2f; font-weight: bold; background: #ffebee; padding: 2px 8px; border-radius: 5px; }
        .fecha-renov { color: #00695c; font-weight: bold; }

        .btn-delete { position: absolute; right: 15px; top: 15px; text-decoration: none; font-size: 1.3em; }
        .btn-call { text-decoration: none; color: white; background: #4caf50; padding: 3px 8px; border-radius: 5px; font-size: 0.8em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_tati.jsp" class="btn-volver">⬅ Volver al Panel</a>
        <h1>🏠 Gestión del Hogar</h1>

        <div class="form-box">
            <h3 style="margin-top:0; color: #283593;">➕ Nuevo Registro</h3>
            <form action="HogarTatiServlet" method="POST">
                <div class="form-row">
                    <select name="categoria" required>
                        <option value="" disabled selected>-- Categoría --</option>
                        <option value="Coche">🚗 Coche (Seguro/ITV)</option>
                        <option value="Casa">🏠 Casa / Hipoteca</option>
                        <option value="Seguros">🛡️ Seguro Vida/Salud</option>
                        <option value="Movil">📱 Móvil / Fibra</option>
                        <option value="Oximesa">💨 Oximesa</option>
                        <option value="Vacaciones">✈️ Vacaciones</option>
                        <option value="Otro">📄 Otro</option>
                    </select>
                </div>

                <div class="form-row">
                    <input type="text" name="titulo" placeholder="Título (ej: Seguro Coche Mapfre)" required>
                </div>
                
                <div class="form-row">
                    <input type="text" name="compania" placeholder="Compañía (ej: Vodafone)">
                    <input type="text" name="telefono_contacto" placeholder="Teléfono contacto">
                </div>

                <div class="form-row">
                    <input type="number" step="0.01" name="importe" placeholder="Importe (€)">
                    <div style="flex:1;">
                        <span style="font-size:0.8em; color:#666; display:block;">Fecha Renovación / Inicio:</span>
                        <input type="date" name="fecha_renovacion">
                    </div>
                </div>

                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Datos extra (Matrícula, conductor, num. póliza...)">
                </div>

                <button type="submit">Guardar</button>
            </form>
        </div>

        <% if(lista != null && !lista.isEmpty()) { 
            for(GestionTati item : lista) { 
                // Asignar icono según categoría
                String icono = "📄";
                if("Coche".equals(item.getCategoria())) icono = "🚗";
                else if("Casa".equals(item.getCategoria())) icono = "🏠";
                else if("Seguros".equals(item.getCategoria())) icono = "🛡️";
                else if("Movil".equals(item.getCategoria())) icono = "📱";
                else if("Vacaciones".equals(item.getCategoria())) icono = "✈️";
                else if("Oximesa".equals(item.getCategoria())) icono = "💨";
        %>
            <div class="item-card">
                <a href="HogarTatiServlet?accion=borrar&id=<%= item.getId() %>" class="btn-delete" onclick="return confirm('¿Borrar este registro?')">🗑️</a>
                
                <div class="card-header">
                    <div class="icon-box"><%= icono %></div>
                    <div class="titulo"><%= item.getTitulo() %></div>
                </div>

                <div class="datos-row">
                    <span>🏢 <%= (item.getCompania() != null) ? item.getCompania() : "-" %></span>
                    <% if(item.getTelefono() != null && !item.getTelefono().isEmpty()) { %>
                        <a href="tel:<%= item.getTelefono() %>" class="btn-call">📞 Llamar</a>
                    <% } %>
                </div>

                <div class="datos-row">
                    <% if(item.getFechaRenovacion() != null) { %>
                        <span class="fecha-renov">📅 <%= item.getFechaRenovacion().toLocalDate().format(fmt) %></span>
                    <% } else { %> <span></span> <% } %>
                    
                    <% if(item.getImporte() > 0) { %>
                        <span class="precio"><%= item.getImporte() %> €</span>
                    <% } %>
                </div>

                <% if(item.getObservaciones() != null && !item.getObservaciones().isEmpty()) { %>
                    <div style="margin-top:8px; font-size:0.9em; color:#666; font-style:italic; border-top:1px solid #eee; padding-top:5px;">
                        📝 <%= item.getObservaciones() %>
                    </div>
                <% } %>
            </div>
        <% }} else { %>
            <p style="text-align: center; color: #888;">No hay gestiones guardadas.</p>
        <% } %>
    </div>
</body>
</html>
