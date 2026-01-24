<%-- 
    Document   : vista_medicacion_madre
    Created on : 24 ene 2026, 1:13:07
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.MedicamentoMadre" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Verificamos si venimos de pulsar "editar"
    MedicamentoMadre edit = (MedicamentoMadre) request.getAttribute("medEditar");
    String horarioGuardado = (edit != null) ? edit.getHorario() : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Medicación</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fce4ec; padding: 15px; margin: 0; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 20px; border-radius: 25px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        h1 { color: #e91e63; text-align: center; }
        
        .form-box { background: #fff1f5; padding: 20px; border-radius: 20px; border: 2px solid #f8bbd0; margin-bottom: 25px; }
        input[type="text"] { width: 100%; padding: 12px; margin-bottom: 15px; border-radius: 10px; border: 1px solid #ddd; box-sizing: border-box; }
        
        .horarios-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 15px; }
        .chip {
            background: white; border: 1px solid #f8bbd0; padding: 8px 12px; border-radius: 20px;
            display: flex; align-items: center; gap: 5px; cursor: pointer; font-size: 0.9em;
        }
        .btn-add { background: #e91e63; color: white; border: none; padding: 15px; width: 100%; border-radius: 12px; font-weight: bold; cursor: pointer; }
        .btn-cancel { display: block; text-align: center; margin-top: 10px; color: #888; text-decoration: none; font-size: 0.9em; }

        .med-card { background: white; border-left: 6px solid #e91e63; padding: 15px; margin-bottom: 12px; border-radius: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); position: relative; }
        .horario-tag { background: #fce4ec; color: #e91e63; padding: 3px 10px; border-radius: 5px; font-size: 0.8em; font-weight: bold; margin-top: 5px; display: inline-block; }
        
        .acciones { position: absolute; right: 15px; top: 15px; display: flex; gap: 10px; }
        .btn-accion { text-decoration: none; font-size: 1.3em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="AgendaMadreServlet?tipo=Medico" style="text-decoration:none; color:#e91e63; font-weight:bold;">⬅ Volver</a>
        <h1>💊 Mi Medicación</h1>
        
        <div class="form-box">
            <h3 style="margin-top:0; color: #c2185b;"><%= (edit != null) ? "✏️ Editando Medicamento" : "➕ Añadir Nuevo" %></h3>
            <form action="MedicacionMadreServlet" method="POST">
                <% if(edit != null) { %> <input type="hidden" name="id" value="<%= edit.getId() %>"> <% } %>
                
                <input type="text" name="nombre" placeholder="Nombre (ej: Enantyum)" value="<%= (edit != null) ? edit.getNombre() : "" %>" required>
                <input type="text" name="dosis" placeholder="Dosis (ej: 1 sobre)" value="<%= (edit != null) ? edit.getDosis() : "" %>">
                
                <p style="margin: 0 0 10px 0; font-weight: bold; color: #e91e63;">Horario:</p>
                <div class="horarios-grid">
                    <% String[] opciones = {"Desayuno", "Comida", "Merienda", "Cena", "Dormir"};
                       String[] iconos = {"☕", "🥗", "🍎", "🌙", "🛌"};
                       for(int i=0; i<opciones.length; i++) {
                           boolean check = horarioGuardado.contains(opciones[i]);
                    %>
                        <label class="chip">
                            <input type="checkbox" name="horarios" value="<%= opciones[i] %>" <%= check ? "checked" : "" %>> 
                            <%= iconos[i] %> <%= opciones[i].substring(0,3) %>.
                        </label>
                    <% } %>
                </div>

                <input type="text" name="observaciones" placeholder="Notas extra..." value="<%= (edit != null && edit.getObservaciones() != null) ? edit.getObservaciones() : "" %>">
                
                <button type="submit" class="btn-add">
                    <%= (edit != null) ? "💾 GUARDAR CAMBIOS" : "GUARDAR MEDICACIÓN" %>
                </button>
                
                <% if(edit != null) { %>
                    <a href="MedicacionMadreServlet" class="btn-cancel">Cancelar edición</a>
                <% } %>
            </form>
        </div>

        <% 
            List<MedicamentoMadre> lista = (List<MedicamentoMadre>) request.getAttribute("misMedicinas");
            if(lista != null && !lista.isEmpty()) {
                for(MedicamentoMadre m : lista) { 
        %>
            <div class="med-card">
                <div class="acciones">
                    <a href="MedicacionMadreServlet?accion=editar&id=<%= m.getId() %>" class="btn-accion" title="Editar">✏️</a>
                    <a href="MedicacionMadreServlet?accion=borrar&id=<%= m.getId() %>" class="btn-accion" style="color:#e57373;" onclick="return confirm('¿Borrar?')">🗑️</a>
                </div>
                
                <strong style="font-size: 1.1em; color: #c2185b;"><%= m.getNombre() %></strong><br>
                <span style="font-size: 0.9em; color: #555;"><%= m.getDosis() %></span><br>
                <div class="horario-tag">⏰ <%= m.getHorario() %></div>
                
                <% if(m.getObservaciones() != null && !m.getObservaciones().isEmpty()) { %>
                    <p style="font-size: 0.8em; color: #888; font-style: italic; margin: 8px 0 0 0;">📝 <%= m.getObservaciones() %></p>
                <% } %>
            </div>
        <% }} %>
    </div>
</body>
</html>
