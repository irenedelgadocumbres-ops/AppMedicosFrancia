<%-- 
    Document   : vista_madre
    Created on : 23 ene 2026, 16:50:27
    Author     : Asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espacio de Mamá</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            padding: 20px; 
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%); 
            text-align: center; 
            margin: 0;
            min-height: 100vh;
        }
        
        h1 { color: #8e24aa; margin-bottom: 30px; }

        .grid-botones {
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-width: 400px;
            margin: 0 auto;
        }

        .boton-grande {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            padding: 25px;
            font-size: 1.3em;
            border-radius: 20px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
            transition: transform 0.2s;
        }
        
        .boton-grande:hover { transform: scale(1.03); }

        /* Colores Específicos */
        .btn-medicos { background: linear-gradient(to right, #e91e63, #c2185b); }
        .btn-cuidados { background: linear-gradient(to right, #9c27b0, #7b1fa2); }
        .btn-nali { background: linear-gradient(to right, #4caf50, #388e3c); }
        .btn-compra { background: linear-gradient(to right, #ff9800, #f57c00); }

        .btn-salir {
            display: inline-block;
            margin-top: 40px;
            padding: 10px 20px;
            background-color: white;
            color: #8e24aa;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <h1>👩 Espacio Personal</h1>
    
    <div class="grid-botones">
        <a href="CalendarioMadreServlet" class="boton-grande" style="background: linear-gradient(to right, #607d8b, #455a64);">
            📅 CALENDARIO
        </a>
        
        <a href="AgendaMadreServlet?tipo=Medico" class="boton-grande btn-medicos">
            🩺 MÉDICOS
        </a>
        
        <a href="TrabajoMadreServlet" class="boton-grande" style="background: linear-gradient(to right, #42a5f5, #1e88e5);">
    💼 GESTIÓN TRABAJO
</a>
        
        <a href="AgendaMadreServlet?tipo=Cuidados" class="boton-grande btn-cuidados">
            💅 CUIDADOS (Pelu, Uñas)
        </a>
        
        <a href="AgendaMadreServlet?tipo=Nali" class="boton-grande btn-nali">
            🐶 NALI (Vet, Vacunas)
        </a>
        
        <a href="CompraServlet" class="boton-grande btn-compra">
            🛒 LISTA COMPRA
        </a>
        
        <a href="HogarMadreServlet" class="boton-grande" style="background: linear-gradient(to right, #ef5350, #d32f2f);">
    🏠 GESTIÓN CASA
</a>
    </div>
    
    <a href="index.html" class="btn-salir">🔒 Cerrar Sesión</a>
</body>
</html>