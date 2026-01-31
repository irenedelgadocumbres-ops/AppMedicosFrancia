/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class DiaTrabajo {
    private int id;
    private Date fecha;
    private String tipo;
    private String subtipo;
    private String observaciones;

    public DiaTrabajo(int id, Date fecha, String tipo, String subtipo, String observaciones) {
        this.id = id;
        this.fecha = fecha;
        this.tipo = tipo;
        this.subtipo = subtipo;
        this.observaciones = observaciones;
    }

    public int getId() { return id; }
    public Date getFecha() { return fecha; }
    public String getTipo() { return tipo; }
    public String getSubtipo() { return subtipo; }
    public String getObservaciones() { return observaciones; }
}