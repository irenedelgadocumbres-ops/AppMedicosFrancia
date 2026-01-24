/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class EventoTati implements Comparable<EventoTati> {
    private Date fecha;
    private String titulo;      // Ej: "Dentista" o "Vacuna Cuky" o "Seguro Coche"
    private String subtitulo;   // Ej: "Hospital Sur" o "Bravecto" o "Mapfre"
    private String tipo;        // "MEDICO", "MASCOTA", "HOGAR"
    
    public EventoTati(Date fecha, String titulo, String subtitulo, String tipo) {
        this.fecha = fecha;
        this.titulo = titulo;
        this.subtitulo = subtitulo;
        this.tipo = tipo;
    }

    public Date getFecha() { return fecha; }
    public String getTitulo() { return titulo; }
    public String getSubtitulo() { return subtitulo; }
    public String getTipo() { return tipo; }

    // Esto sirve para ordenar la lista por fecha automáticamente
    @Override
    public int compareTo(EventoTati o) {
        return this.fecha.compareTo(o.getFecha());
    }
}
