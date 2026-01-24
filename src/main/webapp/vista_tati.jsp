<%-- 
    Document   : vista_tati
    Created on : 24 ene 2026, 21:31:47
    Author     : Asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espacio de Tati</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            padding: 20px; 
            background: linear-gradient(135deg, #e0f2f1 0%, #b2dfdb 100%); 
            text-align: center; 
            min-height: 100vh;
            margin: 0;
        }
        h1 { color: #00695c; margin-bottom: 30px; letter-spacing: 1px;}
        
        .grid-botones {
            display: flex; flex-direction: column; gap: 20px;
            max-width: 400px; margin: 0 auto;
        }
        .boton-grande {
            display: flex; align-items: center; justify-content: center; gap: 15px;
            padding: 25px; font-size: 1.3em; border-radius: 20px;
            text-decoration: none; color: white; font-weight: bold;
            box-shadow: 0 6px 15px rgba(0,0,0,0.15); transition: transform 0.2s;
        }
        .boton-grande:hover { transform: scale(1.03); }

        /* Colores Tati */
        .btn-medicos { background: linear-gradient(to right, #009688, #00796b); }
        .btn-mascotas { background: linear-gradient(to right, #ff7043, #d84315); } /* Naranja teja */
        .btn-hogar { background: linear-gradient(to right, #5c6bc0, #3949ab); } /* Indigo */
        .btn-compra { background: linear-gradient(to right, #78909c, #455a64); } /* Gris azulado */
        
        .btn-salir {
            display: inline-block; margin-top: 40px; padding: 10px 20px;
            background-color: white; color: #00695c; text-decoration: none;
            border-radius: 50px; font-weight: bold; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <h1>🌟 Panel Tati</h1>
    
    <div class="grid-botones">
        <a href="CalendarioTatiServlet" class="boton-grande" style="background: linear-gradient(to right, #673ab7, #512da8);">
            📅 CALENDARIO 
        </a>
        
        <a href="CitasTatiServlet" class="boton-grande btn-medicos">🩺 MÉDICOS</a>
        
        <a href="MascotasTatiServlet" class="boton-grande btn-mascotas">
            🐾 MASCOTAS 
        </a>
        <a href="HogarTatiServlet" class="boton-grande btn-hogar">
            🏠 GESTIÓN HOGAR
        </a>
        <a href="ListaTatiServlet" class="boton-grande btn-compra">
            🛒 LISTA COMPRA
        </a>
    </div>
    
    <a href="index.html" class="btn-salir">🔒 Cerrar Sesión</a>
</body>
</html>
