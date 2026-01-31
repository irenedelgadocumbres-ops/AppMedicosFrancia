/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class EventoTati implements Comparable<EventoTati> {
    private Date fecha;
    private String titulo;      // Ej: Especialista
    private String subtitulo;   // Ej: Hora y Lugar
    private String notas;       // NUEVO: Observaciones
    private String tipo;        // MEDICO_TATI, MEDICO_TIO, MASCOTA...
    
    public EventoTati(Date fecha, String titulo, String subtitulo, String notas, String tipo) {
        this.fecha = fecha;
        this.titulo = titulo;
        this.subtitulo = subtitulo;
        this.notas = notas;
        this.tipo = tipo;
    }

    public Date getFecha() { return fecha; }
    public String getTitulo() { return titulo; }
    public String getSubtitulo() { return subtitulo; }
    public String getNotas() { return notas; }
    public String getTipo() { return tipo; }

    @Override
    public int compareTo(EventoTati o) {
        return this.fecha.compareTo(o.getFecha());
    }
}