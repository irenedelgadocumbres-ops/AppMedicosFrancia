/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class GestionTati {
    private int id;
    private String categoria;   // Coche, Casa, Seguro...
    private String titulo;      // "Seguro Allianz", "ITV Coche"
    private String compania;
    private String telefono;
    private Date fechaRenovacion;
    private double importe;
    private String observaciones;

    public GestionTati(int id, String categoria, String titulo, String compania, String telefono, Date fechaRenovacion, double importe, String observaciones) {
        this.id = id;
        this.categoria = categoria;
        this.titulo = titulo;
        this.compania = compania;
        this.telefono = telefono;
        this.fechaRenovacion = fechaRenovacion;
        this.importe = importe;
        this.observaciones = observaciones;
    }

    // Getters
    public int getId() { return id; }
    public String getCategoria() { return categoria; }
    public String getTitulo() { return titulo; }
    public String getCompania() { return compania; }
    public String getTelefono() { return telefono; }
    public Date getFechaRenovacion() { return fechaRenovacion; }
    public double getImporte() { return importe; }
    public String getObservaciones() { return observaciones; }
}
