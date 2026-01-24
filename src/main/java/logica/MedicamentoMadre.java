/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

public class MedicamentoMadre {
    private int id;
    private String nombre;
    private String dosis;
    private String horario;
    private String observaciones;

    public MedicamentoMadre(int id, String nombre, String dosis, String horario, String observaciones) {
        this.id = id;
        this.nombre = nombre;
        this.dosis = dosis;
        this.horario = horario;
        this.observaciones = observaciones;
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public String getDosis() { return dosis; }
    public String getHorario() { return horario; }
    public String getObservaciones() { return observaciones; }
}