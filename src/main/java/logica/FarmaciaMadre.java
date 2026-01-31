/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class FarmaciaMadre {
    private int id;
    private Date fechaRecogida;
    private Date proximaRecogida;
    private String observaciones;

    public FarmaciaMadre(int id, Date fechaRecogida, Date proximaRecogida, String observaciones) {
        this.id = id;
        this.fechaRecogida = fechaRecogida;
        this.proximaRecogida = proximaRecogida;
        this.observaciones = observaciones;
    }
    // Getters
    public int getId() { return id; }
    public Date getFechaRecogida() { return fechaRecogida; }
    public Date getProximaRecogida() { return proximaRecogida; }
    public String getObservaciones() { return observaciones; }
}
