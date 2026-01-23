/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

public class Medicina {
    private int id;
    private String usuario;
    private String nombre;
    private String dosis;
    private String momento; 
    private String paraQue;

    public Medicina(int id, String usuario, String nombre, String dosis, String momento, String paraQue) {
        this.id = id;
        this.usuario = usuario;
        this.nombre = nombre;
        this.dosis = dosis;
        this.momento = momento;
        this.paraQue = paraQue;
    }

    // Getters
    public int getId() { return id; }
    public String getUsuario() { return usuario; }
    public String getNombre() { return nombre; }
    public String getDosis() { return dosis; }
    public String getMomento() { return momento; }
    public String getParaQue() { return paraQue; }
}