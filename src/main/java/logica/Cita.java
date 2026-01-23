/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

import java.sql.Date;

public class Cita {
    // Estos son los datos que maneja tu base de datos
    private int id;
    private String usuario;
    private Date fecha;
    private String hora;
    private String lugar;
    private String medico;
    private String observaciones;

    // Constructor (para rellenar los datos rápidamente)
    public Cita(int id, String usuario, Date fecha, String hora, String lugar, String medico, String observaciones) {
        this.id = id;
        this.usuario = usuario;
        this.fecha = fecha;
        this.hora = hora;
        this.lugar = lugar;
        this.medico = medico;
        this.observaciones = observaciones;
    }

    // Getters (necesarios para que el JSP pueda leer los datos con ${cita.medico})
    public int getId() { return id; }
    public String getUsuario() { return usuario; }
    public Date getFecha() { return fecha; }
    public String getHora() { return hora; }
    public String getLugar() { return lugar; }
    public String getMedico() { return medico; }
    public String getObservaciones() { return observaciones; }
}
