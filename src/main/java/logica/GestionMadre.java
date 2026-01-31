/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class GestionMadre {
    private int id;
    private String categoria;
    private String concepto;
    private Date fechaLimite;
    private double importe;
    private String observaciones;

    public GestionMadre(int id, String categoria, String concepto, Date fechaLimite, double importe, String observaciones) {
        this.id = id;
        this.categoria = categoria;
        this.concepto = concepto;
        this.fechaLimite = fechaLimite;
        this.importe = importe;
        this.observaciones = observaciones;
    }

    public int getId() { return id; }
    public String getCategoria() { return categoria; }
    public String getConcepto() { return concepto; }
    public Date getFechaLimite() { return fechaLimite; }
    public double getImporte() { return importe; }
    public String getObservaciones() { return observaciones; }
}
