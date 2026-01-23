<%-- 
    Document   : vista_medicinas
    Created on : 23 ene 2026, 13:25:38
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="logica.Medicina" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Si entras directo sin pasar por el Servlet, te redirige para cargar los datos
    if (request.getAttribute("medsAbuelo") == null) {
        response.sendRedirect("MedicinasServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control de Medicación 💊</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #e0f7fa 0%, #e8f5e9 100%); padding: 20px; color: #444; padding-bottom: 80px; }
        h1 { text-align: center; color: #00796b; margin-bottom: 20px;}
        .container { max-width: 900px; margin: 0 auto; }
        
        /* Botón Volver */
        .btn-volver { background-color: #90a4ae; text-decoration: none; padding: 10px 20px; border-radius: 5px; color: white; display: inline-block; margin-bottom: 20px;}

        /* Formulario de Añadir (Arriba) */
        .form-box { background: white; padding: 20px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-row { display: flex; flex-direction: column; gap: 15px; }
        input[type="text"], select { padding: 10px; border: 1px solid #ccc; border-radius: 8px; width: 100%; box-sizing: border-box; }
        
        /* Checkboxes */
        .checkbox-group { display: flex; gap: 8px; flex-wrap: wrap; }
        .check-label { background-color: #eee; padding: 5px 12px; border-radius: 15px; cursor: pointer; border: 1px solid #ccc; font-size: 0.9em; display: flex; align-items: center;}
        input[type="checkbox"] { transform: scale(1.2); margin-right: 5px; }
        
        button { background-color: #00897b; color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; font-weight: bold; width: 100%; font-size: 1.1em; }
        
        /* Paneles de Medicinas */
        .panel { background: white; border-radius: 15px; padding: 15px; margin-bottom: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
        .titulo-sec { font-size: 1.4em; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 5px; }
        
        /* TABLAS CON BOTONES DENTRO */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: #777; font-size: 0.9em; padding-bottom: 10px;}
        td { padding: 12px 5px; border-bottom: 1px solid #f0f0f0; vertical-align: top; }
        
        /* Etiquetas de colores */
        .tag { padding: 3px 8px; border-radius: 8px; font-size: 0.8em; font-weight: bold; color: white; display: inline-block; margin: 1px; }
        .tag-d { background-color: #ffb74d; } .tag-c { background-color: #ef5350; } 
        .tag-n { background-color: #5c6bc0; } .tag-o { background-color: #8d6e63; }

        /* ICONOS DE ACCIÓN (LÁPIZ Y BASURA) */
        .acciones { display: flex; gap: 15px; justify-content: flex-end; align-items: center; height: 100%; }
        .btn-icon { text-decoration: none; font-size: 1.3em; transition: transform 0.2s; cursor: pointer; }
        .btn-icon:hover { transform: scale(1.2); }
        .edit { color: #fbc02d; } /* Amarillo */
        .del { color: #e53935; }  /* Rojo */
    </style>
</head>
<body>
    <div class="container">
        <a href="CitasServlet" class="btn-volver">⬅ Volver a Citas</a>
        
        <h1>💊 Pastillero Semanal</h1>

        <div class="form-box">
            <h3 style="margin-top:0; color: #00796b;">Añadir medicina</h3>
            <form action="MedicinasServlet" method="POST">
                <div class="form-row">
                    <div style="display: flex; gap: 10px;">
                        <select name="usuario" style="width: 35%;" required>
                            <option value="Abuelo">Abuelo</option>
                            <option value="Abuela">Abuela</option>
                        </select>
                        <input type="text" name="nombre" placeholder="Nombre (ej: Sintrom)" style="width: 65%;" required>
                    </div>
                    <input type="text" name="dosis" placeholder="Dosis (ej: 1/2 pastilla)" required>
                    
                    <div class="checkbox-group">
                        <label class="check-label"><input type="checkbox" name="momento" value="Desayuno"> ☕ Desayuno</label>
                        <label class="check-label"><input type="checkbox" name="momento" value="Comida"> 🍲 Comida</label>
                        <label class="check-label"><input type="checkbox" name="momento" value="Cena"> 🌙 Cena</label>
                        <label class="check-label"><input type="checkbox" name="momento" value="Dormir"> 🛌 Dormir</label>
                    </div>
                    
                    <input type="text" name="para_que" placeholder="¿Para qué sirve? (Opcional)">
                    <button type="submit">➕ Guardar Medicina</button>
                </div>
            </form>
        </div>

        <%
            List<Medicina> abuelo = (List<Medicina>) request.getAttribute("medsAbuelo");
            List<Medicina> abuela = (List<Medicina>) request.getAttribute("medsAbuela");
        %>
        
        <div class="panel" style="border-left: 10px solid #90caf9;">
            <div class="titulo-sec">👴 Medicinas del Abuelo</div>
            <table>
                <thead>
                    <tr><th style="width: 30%">Momento</th><th>Medicamento / Dosis</th><th>Utilidad</th></tr>
                </thead>
                <tbody>
                    <% if(abuelo != null) { for(Medicina m : abuelo) { %>
                    <tr>
                        <td>
                            <% 
                                String mom = m.getMomento();
                                if(mom.contains("Desayuno")) out.print("<span class='tag tag-d'>☕ Desayuno</span>");
                                if(mom.contains("Comida")) out.print("<span class='tag tag-c'>🍲 Comida</span>");
                                if(mom.contains("Cena")) out.print("<span class='tag tag-n'>🌙 Cena</span>");
                                if(!mom.contains("Desayuno") && !mom.contains("Comida") && !mom.contains("Cena")) out.print("<span class='tag tag-o'>"+mom+"</span>");
                            %>
                        </td>
                        <td><strong style="font-size: 1.1em"><%= m.getNombre() %></strong><br><span style="color: #666;">Dosis: <%= m.getDosis() %></span></td>
                        <td style="color: #777; font-style: italic;"><%= m.getParaQue() != null ? m.getParaQue() : "-" %></td>
                        
                        <td>
                            <div class="acciones">
                                <a href="MedicinasServlet?accion=editar&id=<%= m.getId() %>" class="btn-icon edit" title="Editar">✏️</a>
                                <a href="MedicinasServlet?accion=borrar&id=<%= m.getId() %>" class="btn-icon del" onclick="return confirm('¿Borrar <%= m.getNombre() %>?');" title="Borrar">🗑️</a>
                            </div>
                        </td>
                    </tr>
                    <% }} else { %>
                        <tr><td colspan="3" style="text-align: center;">No hay medicinas.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="panel" style="border-left: 10px solid #f48fb1;">
            <div class="titulo-sec">👵 Medicinas de la Abuela</div>
            <table>
                <thead>
                    <tr><th style="width: 30%">Momento</th><th>Medicamento / Dosis</th><th>Utilidad</th></tr>
                </thead>
                <tbody>
                    <% if(abuela != null) { for(Medicina m : abuela) { %>
                    <tr>
                        <td>
                            <% 
                                String mom = m.getMomento();
                                if(mom.contains("Desayuno")) out.print("<span class='tag tag-d'>☕ Desayuno</span>");
                                if(mom.contains("Comida")) out.print("<span class='tag tag-c'>🍲 Comida</span>");
                                if(mom.contains("Cena")) out.print("<span class='tag tag-n'>🌙 Cena</span>");
                                if(!mom.contains("Desayuno") && !mom.contains("Comida") && !mom.contains("Cena")) out.print("<span class='tag tag-o'>"+mom+"</span>");
                            %>
                        </td>
                        <td><strong style="font-size: 1.1em"><%= m.getNombre() %></strong><br><span style="color: #666;">Dosis: <%= m.getDosis() %></span></td>
                        <td style="color: #777; font-style: italic;"><%= m.getParaQue() != null ? m.getParaQue() : "-" %></td>
                        
                        <td>
                            <div class="acciones">
                                <a href="MedicinasServlet?accion=editar&id=<%= m.getId() %>" class="btn-icon edit" title="Editar">✏️</a>
                                <a href="MedicinasServlet?accion=borrar&id=<%= m.getId() %>" class="btn-icon del" onclick="return confirm('¿Borrar <%= m.getNombre() %>?');" title="Borrar">🗑️</a>
                            </div>
                        </td>
                    </tr>
                    <% }} else { %>
                        <tr><td colspan="3" style="text-align: center;">No hay medicinas.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
               
    </div>
</body>
</html>