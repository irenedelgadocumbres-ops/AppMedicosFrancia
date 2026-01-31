/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;
import java.sql.Date;

public class EventoMadre {
    private Date fecha;
    private String titulo; // Ej: "Cardiólogo" o "Recoger Farmacia"
    private String tipo;   // "CITA" o "FARMACIA"

    public EventoMadre(Date fecha, String titulo, String tipo) {
        this.fecha = fecha;
        this.titulo = titulo;
        this.tipo = tipo;
    }

    public Date getFecha() { return fecha; }
    public String getTitulo() { return titulo; }
    public String getTipo() { return tipo; }
}
