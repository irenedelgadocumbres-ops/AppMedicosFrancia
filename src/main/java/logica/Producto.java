/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

public class Producto {
    private int id;
    private String nombre;
    private String tienda;
    private boolean comprado;

    public Producto(int id, String nombre, String tienda, boolean comprado) {
        this.id = id;
        this.nombre = nombre;
        this.tienda = tienda;
        this.comprado = comprado;
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public String getTienda() { return tienda; }
    public boolean isComprado() { return comprado; }
}
