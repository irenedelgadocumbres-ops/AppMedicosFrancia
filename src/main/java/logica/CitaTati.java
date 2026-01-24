/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class CitaTati {
    private int id;
    private Date fecha;
    private String hora;
    private String especialista;
    private String lugar;
    private String observaciones;

    public CitaTati(int id, Date fecha, String hora, String especialista, String lugar, String observaciones) {
        this.id = id;
        this.fecha = fecha;
        this.hora = hora;
        this.especialista = especialista;
        this.lugar = lugar;
        this.observaciones = observaciones;
    }
    // Getters
    public int getId() { return id; }
    public Date getFecha() { return fecha; }
    public String getHora() { return hora; }
    public String getEspecialista() { return especialista; }
    public String getLugar() { return lugar; }
    public String getObservaciones() { return observaciones; }
}