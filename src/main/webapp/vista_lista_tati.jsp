<%-- 
    Document   : vista_lista_tati
    Created on : 24 ene 2026, 21:55:27
    Author     : Asus
--%>

<%@ page import="java.util.List" %>
<%@ page import="logica.ProductoTati" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista Compra Tati</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #eceff1; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; }
        
        h1 { text-align: center; color: #455a64; }
        .btn-volver { color: #607d8b; text-decoration: none; font-weight: bold; margin-bottom: 15px; display: inline-block; }

        /* Formulario */
        .form-box { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #607d8b; margin-bottom: 30px; }
        input, select { width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        button { background: #607d8b; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: bold; cursor: pointer; font-size: 1.1em; }

        /* Lista */
        .tienda-header { 
            background: #546e7a; color: white; padding: 8px 15px; border-radius: 8px; 
            margin-top: 25px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9em;
        }
        .item { 
            background: white; border-bottom: 1px solid #cfd8dc; padding: 15px; 
            display: flex; justify-content: space-between; align-items: center;
        }
        .item:first-of-type { border-top-left-radius: 10px; border-top-right-radius: 10px; margin-top: 5px; }
        .item:last-child { border-bottom: none; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; }
        
        .producto-nombre { font-size: 1.1em; color: #37474f; }
        .btn-check { text-decoration: none; font-size: 1.4em; color: #b0bec5; transition: color 0.2s; }
        .btn-check:hover { color: #4caf50; } /* Se pone verde al pasar el ratón */

    </style>
</head>
<body>
    <div class="container">
        <a href="vista_tati.jsp" class="btn-volver">⬅ Volver al Panel</a>
        <h1>🛒 Lista de la Compra</h1>

        <div class="form-box">
            <form action="ListaTatiServlet" method="POST">
                <input type="text" name="producto" placeholder="¿Qué necesitas?" required>
                
                <select name="tienda" required>
                    <option value="MERCADONA">Mercadona</option>
                    <option value="LIDL">Lidl</option>
                    <option value="CARREFOUR">Carrefour</option>
                    <option value="MERCADO">Mercado</option>
                    <option value="COSTCO">Costco</option>
                    <option value="AHORRA MAS">Ahorra Mas</option>
                    <option value="ALDI">Aldi</option>
                    <option value="DIA">Dia</option>
                    <option value="ALCAMPO">Alcampo</option>
                    <option value="FAMILY">Family Cash</option>
                    <option value="FARMACIA">Farmacia</option>
                    <option value="OTROS">Otros</option>
                </select>

                <button type="submit">➕ Añadir</button>
            </form>
        </div>

        <div class="lista">
            <% 
                List<ProductoTati> lista = (List<ProductoTati>) request.getAttribute("listaTati");
                String tiendaActual = "";
                
                if (lista != null && !lista.isEmpty()) {
                    for (ProductoTati p : lista) { 
                        // Si cambia la tienda, ponemos título nuevo
                        if (!p.getTienda().equals(tiendaActual)) {
                            tiendaActual = p.getTienda();
            %>
                            <div class="tienda-header"><%= tiendaActual %></div>
            <% 
                        } 
            %>
                        <div class="item">
                            <span class="producto-nombre"><%= p.getNombre() %></span>
                            <a href="ListaTatiServlet?accion=borrar&id=<%= p.getId() %>" class="btn-check">✅</a>
                        </div>
            <% 
                    }
                } else { 
            %>
                <p style="text-align: center; color: #90a4ae; margin-top: 40px;">No hay nada en la lista.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
