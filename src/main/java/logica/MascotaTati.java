/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class MascotaTati {
    private int id;
    private String nombre;      // Cuky, Leo, Thais...
    private Date fecha;
    private String tipo;        // Vacuna, Peluquería, Desparasitación...
    private String producto;    // Nombre del pienso o pastilla
    private String observaciones;
    private Date proximaFecha;  // Para saber cuándo toca la siguiente

    public MascotaTati(int id, String nombre, Date fecha, String tipo, String producto, String observaciones, Date proximaFecha) {
        this.id = id;
        this.nombre = nombre;
        this.fecha = fecha;
        this.tipo = tipo;
        this.producto = producto;
        this.observaciones = observaciones;
        this.proximaFecha = proximaFecha;
    }

    // Getters
    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public Date getFecha() { return fecha; }
    public String getTipo() { return tipo; }
    public String getProducto() { return producto; }
    public String getObservaciones() { return observaciones; }
    public Date getProximaFecha() { return proximaFecha; }
}
