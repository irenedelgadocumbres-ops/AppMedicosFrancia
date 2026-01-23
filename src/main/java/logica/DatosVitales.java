/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package logica;

public class DatosVitales {
    private String usuario;
    private String sip;
    private String dni;
    private String sangre;
    private String alergias;
    private String contacto;

    public DatosVitales(String usuario, String sip, String dni, String sangre, String alergias, String contacto) {
        this.usuario = usuario;
        this.sip = sip;
        this.dni = dni;
        this.sangre = sangre;
        this.alergias = alergias;
        this.contacto = contacto;
    }

    public String getUsuario() { return usuario; }
    public String getSip() { return sip; }
    public String getDni() { return dni; }
    public String getSangre() { return sangre; }
    public String getAlergias() { return alergias; }
    public String getContacto() { return contacto; }
}
