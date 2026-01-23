/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

import java.sql.Date;

public class CitaMadre {
    private int id;
    private Date fecha;
    private String hora;
    private String titulo;
    private String lugar;
    private String categoria; // 'Medico', 'Cuidados', 'Nali'
    private String observaciones;

    public CitaMadre(int id, Date fecha, String hora, String titulo, String lugar, String categoria, String observaciones) {
        this.id = id;
        this.fecha = fecha;
        this.hora = hora;
        this.titulo = titulo;
        this.lugar = lugar;
        this.categoria = categoria;
        this.observaciones = observaciones;
    }

    public int getId() { return id; }
    public Date getFecha() { return fecha; }
    public String getHora() { return hora; }
    public String getTitulo() { return titulo; }
    public String getLugar() { return lugar; }
    public String getCategoria() { return categoria; }
    public String getObservaciones() { return observaciones; }
}
