<%-- 
    Document   : editar_medicina
    Created on : 23 ene 2026, 13:48:12
    Author     : Asus
--%>

<%@ page import="logica.Medicina" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Recuperamos la medicina que nos manda el Servlet
    Medicina m = (Medicina) request.getAttribute("medicinaEditar");
    if(m == null) { response.sendRedirect("MedicinasServlet"); return; }
    String mom = m.getMomento(); // Para saber qué checkboxes marcar
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Medicina</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #e0f2f1; padding: 20px; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        input[type="text"], select { padding: 12px; margin-bottom: 15px; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; }
        .checkbox-group { margin-bottom: 20px; }
        .check-label { display: block; margin-bottom: 5px; }
        button { background-color: #00897b; color: white; width: 100%; padding: 15px; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; font-size: 1.1em; }
        .btn-cancel { background-color: #ef5350; margin-top: 10px; display: block; text-align: center; text-decoration: none; padding: 12px; color: white; border-radius: 8px; font-weight: bold;}
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="margin-top:0; color: #00796b; text-align: center;">✏️ Editar Medicina</h2>
        
        <form action="MedicinasServlet" method="POST">
            <input type="hidden" name="id" value="<%= m.getId() %>">

            <label>¿De quién es?</label>
            <select name="usuario" required>
                <option value="Abuelo" <%= m.getUsuario().equals("Abuelo") ? "selected" : "" %>>Abuelo</option>
                <option value="Abuela" <%= m.getUsuario().equals("Abuela") ? "selected" : "" %>>Abuela</option>
            </select>

            <label>Medicamento</label>
            <input type="text" name="nombre" value="<%= m.getNombre() %>" required>

            <label>Dosis</label>
            <input type="text" name="dosis" value="<%= m.getDosis() %>" required>

            <label>Momentos (Marca los nuevos)</label>
            <div class="checkbox-group">
                <label class="check-label"><input type="checkbox" name="momento" value="Desayuno" <%= mom.contains("Desayuno") ? "checked" : "" %>> ☕ Desayuno</label>
                <label class="check-label"><input type="checkbox" name="momento" value="Comida" <%= mom.contains("Comida") ? "checked" : "" %>> 🍲 Comida</label>
                <label class="check-label"><input type="checkbox" name="momento" value="Cena" <%= mom.contains("Cena") ? "checked" : "" %>> 🌙 Cena</label>
                <label class="check-label"><input type="checkbox" name="momento" value="Dormir" <%= mom.contains("Dormir") ? "checked" : "" %>> 🛌 Dormir</label>
            </div>

            <label>Utilidad</label>
            <input type="text" name="para_que" value="<%= m.getParaQue() %>">

            <button type="submit">💾 Guardar Cambios</button>
            <a href="MedicinasServlet" class="btn-cancel">Cancelar</a>
        </form>
    </div>
</body>
</html>