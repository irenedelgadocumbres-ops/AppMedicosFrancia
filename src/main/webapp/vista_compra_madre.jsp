<%-- 
    Document   : vista_compra_madre
    Created on : 24 ene 2026, 0:54:35
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.Producto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista Compra - Mamá</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #fff3e0; padding: 15px; margin: 0; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 20px; border-radius: 25px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        h1 { color: #e67e22; text-align: center; margin-bottom: 20px; }
        .btn-volver { text-decoration: none; color: #ff9800; font-weight: bold; margin-bottom: 15px; display: inline-block; }

        .form-box { background: #fffaf0; padding: 15px; border-radius: 15px; border: 1px solid #ffe0b2; margin-bottom: 25px; }
        input, select { width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; font-size: 1em; }
        .btn-add { background: #ff9800; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; }

        .tienda-header { 
            background: #e67e22; color: white; padding: 8px 15px; border-radius: 10px; 
            margin-top: 25px; font-weight: bold; text-transform: uppercase; font-size: 0.85em;
        }
        .item { 
            display: flex; justify-content: space-between; align-items: center; 
            padding: 12px 5px; border-bottom: 1px solid #eee; 
        }
        .nombre-producto { font-size: 1.1em; color: #5d4037; }
        .btn-borrar { text-decoration: none; font-size: 1.4em; color: #e57373; }
    </style>
</head>
<body>
    <div class="container">
        <a href="vista_madre.jsp" class="btn-volver">⬅ Menú Mamá</a>
        <h1>🛒 Mi Lista</h1>

        <div class="form-box">
            <form action="CompraServlet" method="POST">
                <input type="text" name="producto" placeholder="¿Qué hay que comprar?" required>
                <select name="tienda" required>
    <option value="" disabled selected>-- Elige tienda --</option>
    
    <option value="🏠 MERCADONA">🏠 Mercadona</option>
    <option value="🏠 LIDL">🏠 Lidl</option>
    <option value="🏠 ALDI">🏠 Aldi</option>
    <option value="🏠 CARREFOUR">🏠 Carrefour</option>
    <option value="🔴 DIA">🔴 Dia</option>
    <option value="🟡 AHORRA MAS">🟡 Ahorra Más</option>
    <option value="🕊️ ALCAMPO">🕊️ Alcampo</option>
    <option value="🛒 FAMILY CASH">🛒 Family Cash</option>
    <option value="🛍️ BM">🛍️ BM Supermercados</option>
    <option value="📦 COSTCO">📦 Costco</option>
    
    <option value="🥝 KIWI">🥝 Kiwi</option>
    <option value="💊 FARMACIA">💊 Farmacia</option>
    
    <option value="🍎 FRUTERÍA">🍎 Frutería / Mercado</option>
    <option value="🥩 CARNICERÍA">🥩 Carnicería</option>
    <option value="📦 OTROS">📦 Otros</option>
</select>
                <button type="submit" class="btn-add">Añadir a la lista</button>
            </form>
        </div>

        <div class="lista">
            <% 
                List<Producto> lista = (List<Producto>) request.getAttribute("miLista");
                String tiendaActual = "";
                
                if (lista != null && !lista.isEmpty()) {
                    for (Producto p : lista) { 
                        if (!p.getTienda().equals(tiendaActual)) {
                            tiendaActual = p.getTienda();
            %>
                            <div class="tienda-header"><%= tiendaActual %></div>
            <% 
                        } 
            %>
                        <div class="item">
                            <span class="nombre-producto"><%= p.getNombre() %></span>
                            <a href="CompraServlet?accion=borrar&id=<%= p.getId() %>" class="btn-borrar">🗑️</a>
                        </div>
            <% 
                    }
                } else { 
            %>
                <p style="text-align: center; color: #999; margin-top: 40px;">No hay nada apuntado.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
