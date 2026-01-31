<%-- 
    Document   : vista_hogar_madre
    Created on : 31 ene 2026, 13:18:43
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.GestionMadre" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<GestionMadre> lista = (List<GestionMadre>) request.getAttribute("listaHogar");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hogar Mamá</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #ffebee; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        
        h1 { text-align: center; color: #c62828; }
        .btn-volver { color: #d32f2f; text-decoration: none; font-weight: bold; margin-bottom: 15px; display: inline-block; }

        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-top: 5px solid #d32f2f; margin-bottom: 25px; }
        .form-row { display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap; }
        input, select { flex: 1; padding: 12px; border: 1px solid #ef9a9a; border-radius: 10px; }
        button { background: #d32f2f; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; }

        .card { background: white; padding: 15px; border-radius: 15px; margin-bottom: 15px; border-left: 6px solid #ef5350; position: relative; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .categoria { font-size: 0.85em; font-weight: bold; color: #999; text-transform: uppercase; letter-spacing: 1px; }
        .titulo { font-size: 1.1em; font-weight: bold; color: #333; margin: 5px 0; }
        .datos-row { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; }
        .precio { background: #ffebee; color: #c62828; padding: 4px 8px; border-radius: 5px; font-weight: bold; }
        
        .btn-delete { position: absolute; right: 15px; top: 15px; text-decoration: none; font-size: 1.2em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Volver al Menú</a>
        <h1>🏠 Gestión Hogar</h1>

        <div class="form-box">
            <form action="HogarMadreServlet" method="POST">
                <div class="form-row">
                    <select name="categoria" required>
                        <option value="" disabled selected>-- ¿Qué gestionamos? --</option>
                        <option value="COCHE 1">🚗 Coche 1</option>
                        <option value="COCHE 2">🚙 Coche 2</option>
                        <option value="CASA">🏠 Casa / Seguro Hogar</option>
                        <option value="SALUD">🏥 Seguro Salud</option>
                        <option value="VACACIONES">✈️ Vacaciones</option>
                        <option value="OTROS">📝 Otros</option>
                    </select>
                </div>
                <div class="form-row">
                    <select name="concepto" required>
                        <option value="" disabled selected>-- Concepto --</option>
                        <option value="Seguro">🛡️ Seguro</option>
                        <option value="ITV">🔧 ITV</option>
                        <option value="Numerito">📄 Numerito (Impuesto)</option>
                        <option value="Revisión Taller">⚙️ Revisión Taller</option>
                        <option value="Verano">☀️ Verano</option>
                        <option value="Invierno">❄️ Invierno</option>
                        <option value="Otro">✏️ Otro</option>
                    </select>
                </div>
                
                <div class="form-row">
                    <div style="flex:1">
                        <label style="font-size:0.8em; color:#d32f2f;">Fecha Vencimiento/Viaje:</label>
                        <input type="date" name="fecha_limite">
                    </div>
                    <div style="flex:1">
                        <label style="font-size:0.8em; color:#d32f2f;">Importe (€):</label>
                        <input type="number" step="0.01" name="importe" placeholder="0.00">
                    </div>
                </div>

                <div class="form-row">
                    <input type="text" name="observaciones" placeholder="Notas (Compañía, matrícula, hotel...)">
                </div>

                <button type="submit">Guardar Gestión</button>
            </form>
        </div>

        <% if(lista != null && !lista.isEmpty()) { 
            for(GestionMadre g : lista) { 
        %>
            <div class="card">
                <a href="HogarMadreServlet?accion=borrar&id=<%= g.getId() %>" class="btn-delete" onclick="return confirm('¿Borrar?')">🗑️</a>
                <div class="categoria"><%= g.getCategoria() %></div>
                <div class="titulo"><%= g.getConcepto() %></div>
                
                <div class="datos-row">
                    <% if(g.getFechaLimite() != null) { %>
                        <span style="color:#d32f2f; font-weight:bold;">📅 <%= g.getFechaLimite().toLocalDate().format(fmt) %></span>
                    <% } else { %> <span></span> <% } %>

                    <% if(g.getImporte() > 0) { %>
                        <span class="precio"><%= g.getImporte() %> €</span>
                    <% } %>
                </div>

                <% if(g.getObservaciones() != null && !g.getObservaciones().isEmpty()) { %>
                    <div style="margin-top:10px; font-style:italic; color:#666; font-size:0.9em; border-top:1px solid #ffebee; padding-top:5px;">
                        📝 <%= g.getObservaciones() %>
                    </div>
                <% } %>
            </div>
        <% }} else { %>
            <p style="text-align: center; color: #999;">No hay gestiones pendientes.</p>
        <% } %>
    </div>
</body>
</html>
