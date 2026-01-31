<%-- 
    Document   : vista_farmacia_madre
    Created on : 31 ene 2026, 12:32:17
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.FarmaciaMadre" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<FarmaciaMadre> lista = (List<FarmaciaMadre>) request.getAttribute("historialFarmacia");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmacia</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e0f2f1; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-top: 5px solid #00897b; margin-bottom: 20px; }
        input { width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        button { background: #00897b; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; }
        
        .card { background: white; padding: 15px; border-radius: 15px; margin-bottom: 10px; border-left: 6px solid #80cbc4; position: relative; }
        .aviso { background: #fff3e0; color: #e65100; padding: 5px 10px; border-radius: 5px; font-weight: bold; display: inline-block; margin-top: 5px; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="AgendaMadreServlet?tipo=Medico" style="text-decoration:none; color:#00897b; font-weight:bold;">⬅ Volver a Médicos</a>
        <h1 style="text-align:center; color:#00695c;">🏥 Recogida Farmacia</h1>

        <div class="form-box">
            <h3 style="margin-top:0;">📝 Registrar Recogida</h3>
            <form action="FarmaciaMadreServlet" method="POST">
                <label>¿Cuándo has ido?</label>
                <input type="date" name="fecha_recogida" required>
                
                <label>¿Cuándo toca volver? (Para aviso)</label>
                <input type="date" name="proxima_recogida">
                
                <input type="text" name="observaciones" placeholder="¿Qué has recogido? (Opcional)">
                <button type="submit">Guardar</button>
            </form>
        </div>

        <% if(lista != null) { for(FarmaciaMadre f : lista) { %>
            <div class="card">
                <a href="FarmaciaMadreServlet?accion=borrar&id=<%= f.getId() %>" style="float:right; text-decoration:none; font-size:1.2em;" onclick="return confirm('¿Borrar?')">🗑️</a>
                <div><strong>Recogido:</strong> <%= f.getFechaRecogida().toLocalDate().format(fmt) %></div>
                <% if(f.getObservaciones() != null && !f.getObservaciones().isEmpty()) { %>
                    <div style="color:#666; font-style:italic;"><%= f.getObservaciones() %></div>
                <% } %>
                
                <% if(f.getProximaRecogida() != null) { %>
                    <div class="aviso">⏰ Próxima vez: <%= f.getProximaRecogida().toLocalDate().format(fmt) %></div>
                <% } %>
            </div>
        <% }} %>
    </div>
</body>
</html>
