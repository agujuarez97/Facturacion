/**
 * connection to the database.
 * @autor. Komarofky.
 */

package Facturacion;

import java.sql.*;

public class Conexion {
    
    private String driver;
    private String url;
    private String password;
    private String nombre;
    private Connection connection;
    
    /**
     * Creates new form Conexion
     */
    public Conexion(){
        driver = null;
        url = null;
        password = null;
        connection = null;
        nombre = null;
    }
    
     /**
      * Creates new form Conexion
      * @param a
      * @param b
      * @param c
      * @param d
      * @param e 
      */
    public Conexion(String a, String b, String c, Connection d, String e){
        driver = a;
        url = b;
        password = c;
        connection = d;
        nombre = e;
    }
    
    public void setDriver(String a){
        driver = a;
    }
    
    public String getDriver(){
        return driver;
    }
    
    public void setUrl(String a){
        url = a;
    }
    
    public String getUrl(){
        return url;
    }
    
    public void setPassword(String a){
        password = a;
    }
    
    public String getPassword(){
        return password;
    }
    
    public void setConnectio(Connection a){
        connection = a;
    }
    
    public Connection getConnectio(){
        return connection;
    }
    
    public void setNombre(String e){
        nombre = e;
    }
    
    public String getNombre(){
        return nombre;
    }
}
