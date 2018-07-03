
package Usuario;

import Principal.*;
import Avisos.*;
import DataBase.Conexion;
import java.awt.event.KeyEvent;
import java.sql.*;

import java.util.logging.Level;
import java.util.logging.Logger;

/*CLASE LA CUAL HACE REFERENCIA A LA VENTANA DE ENTRADA AL SISTEMA*/
public class Ingreso extends javax.swing.JFrame {

    /*CONSTRUCTOR DE LA CLASE*/
    public Ingreso() {
        initComponents();
        this.setLocationRelativeTo(null);   /*HACE QUE LA VENTANA SE CENTRE EN EL MEDIO DE LA PANTALLA*/
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        clave = new javax.swing.JPasswordField();
        usuario = new javax.swing.JTextField();
        cancelar = new javax.swing.JButton();
        aceptar = new javax.swing.JButton();

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/fondo.png"))); // NOI18N

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jLabel2.setFont(new java.awt.Font("Dialog", 1, 20)); // NOI18N
        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/group.png"))); // NOI18N
        jLabel2.setText("USUARIO");
        getContentPane().add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 70, 180, 30));

        jLabel3.setFont(new java.awt.Font("Dialog", 1, 20)); // NOI18N
        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/group_key.png"))); // NOI18N
        jLabel3.setText("CONTRASEÑA");
        getContentPane().add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 150, 200, 36));

        clave.setFont(new java.awt.Font("Dialog", 1, 20)); // NOI18N
        clave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                claveActionPerformed(evt);
            }
        });
        clave.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                claveKeyPressed(evt);
            }
        });
        getContentPane().add(clave, new org.netbeans.lib.awtextra.AbsoluteConstraints(280, 140, 220, 40));

        usuario.setFont(new java.awt.Font("Dialog", 0, 20)); // NOI18N
        usuario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                usuarioActionPerformed(evt);
            }
        });
        getContentPane().add(usuario, new org.netbeans.lib.awtextra.AbsoluteConstraints(280, 70, 220, 40));

        cancelar.setBackground(java.awt.Color.gray);
        cancelar.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        cancelar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/delete.png"))); // NOI18N
        cancelar.setText("SALIR");
        cancelar.setPreferredSize(new java.awt.Dimension(122, 36));
        cancelar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelarActionPerformed(evt);
            }
        });
        getContentPane().add(cancelar, new org.netbeans.lib.awtextra.AbsoluteConstraints(60, 230, 160, 40));

        aceptar.setBackground(java.awt.Color.gray);
        aceptar.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        aceptar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/accept.png"))); // NOI18N
        aceptar.setText("ACEPTAR");
        aceptar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aceptarActionPerformed(evt);
            }
        });
        aceptar.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                aceptarKeyPressed(evt);
            }
        });
        getContentPane().add(aceptar, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 230, 160, 40));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    /*METODO EL CUAL NOS PERMITE CODIFICAR EL BOTON CANCELAR PARA QUE AL SER PRECIONADO
    SE CORTE LA EJECUCION*/
    private void cancelarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cancelarActionPerformed
        System.exit(0);
    }//GEN-LAST:event_cancelarActionPerformed

    private void claveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_claveActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_claveActionPerformed

    private void usuarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_usuarioActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_usuarioActionPerformed

    /*METODO EL CUAL NOS PERMITE CODIFICAR EL BOTON ACEPTAR PARA QUE AL SER PRECIONADO
    CHEQUE LOS DATOS Y SI SON CORRECTOS ENTRA AL SISTEMA EN CASO CONTRARIO NO*/
    private void aceptarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aceptarActionPerformed

        try {
            Conexion sc = new Conexion("org.postgresql.Driver", "jdbc:postgresql://127.0.0.1:5432/postgres", "root", DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/postgres", "postgres", "root"), "postgres");
            String query1 = "SELECT login FROM facturacion.conf_usuario WHERE login = '"+usuario.getText()+"'";
            PreparedStatement statement1 = sc.getConnectio().prepareStatement(query1);
            ResultSet res = statement1.executeQuery();
            if(res.next()) {
                String query2 = "SELECT pas FROM facturacion.conf_usuario WHERE login = '"+usuario.getText()+"'";
                PreparedStatement statement2 = sc.getConnectio().prepareStatement(query2);
                ResultSet res1 = statement2.executeQuery();
                res1.next();
                if(!res1.getString("pas").equals(clave.getText())){
                    UsuarioContraseña cla = new UsuarioContraseña();
                    cla.setVisible(true);
                } else{
                    VentanaPrincipal ven = new VentanaPrincipal();
                    ven.setVisible(true);
                    this.dispose();
                }
                
            }else{
                UsuarioNoReg chec = new UsuarioNoReg();
                chec.setVisible(true);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Ingreso.class.getName()).log(Level.SEVERE, null, ex);
        } 
    }//GEN-LAST:event_aceptarActionPerformed

    private void aceptarKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_aceptarKeyPressed
       
    }//GEN-LAST:event_aceptarKeyPressed

    
    /*METODO QUE NOS PERMITE INGRESAR A LA VENTANA PRINCIPAL DEL SISTEMA
    PRECIONANDO LA TECLA ENTER*/
    private void claveKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_claveKeyPressed
        if(evt.getKeyCode() == KeyEvent.VK_ENTER){
            try {
            Conexion sc = new Conexion("org.postgresql.Driver", "jdbc:postgresql://127.0.0.1:5432/postgres", "root", DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/postgres", "postgres", "root"), "postgres");
            String query1 = "SELECT login FROM facturacion.conf_usuario WHERE login = '"+usuario.getText()+"'";
            PreparedStatement statement1 = sc.getConnectio().prepareStatement(query1);
            ResultSet res = statement1.executeQuery();
            if(res.next()) {
                String query2 = "SELECT pas FROM facturacion.conf_usuario WHERE login = '"+usuario.getText()+"'";
                PreparedStatement statement2 = sc.getConnectio().prepareStatement(query2);
                ResultSet res1 = statement2.executeQuery();
                res1.next();
                if(!res1.getString("pas").equals(clave.getText())){
                    UsuarioContraseña cla = new UsuarioContraseña();
                    cla.setVisible(true);
                } else{
                    VentanaPrincipal ven = new VentanaPrincipal();
                    ven.setVisible(true);
                    this.dispose();
                }
                
            }else{
                UsuarioNoReg chec = new UsuarioNoReg();
                chec.setVisible(true);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Ingreso.class.getName()).log(Level.SEVERE, null, ex);
        } 
        }
    }//GEN-LAST:event_claveKeyPressed

    /*METODO PRINCIPAL DE LA CLASE*/
    public static void main(String args[]) {
        
         Conexion sc = new Conexion();
         System.out.println("-------- Conexion A La Base De Datos PostgreSQL ------------");
		try {
			sc.setDriver("org.postgresql.Driver");
			Class.forName(sc.getDriver());
		} catch (ClassNotFoundException e) {
			System.out.println("HUBO UN PORBLEMA EN LA CARGA DEL DRIVER");
			return;
		}
		System.out.println("-------- CARGA DEL DRIVER EXITOSA --------");
		sc.setConnectio(null);
                
                try {
                        sc.setUrl("jdbc:postgresql://127.0.0.1:5432/postgres");
                        sc.setNombre("postgres");
                        sc.setPassword("root");
			sc.setConnectio(DriverManager.getConnection(sc.getUrl(), sc.getNombre(), sc.getPassword()));
                        System.out.println("----------- CONECTADO CON LA BD ------------");
                        
                } catch (SQLException e) {

			System.out.println("-------- FALLA EN LA CONEXION --------");
			return;
		}
        
        java.awt.EventQueue.invokeLater(() -> {
            new Ingreso().setVisible(true);
         });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton aceptar;
    private javax.swing.JButton cancelar;
    private javax.swing.JPasswordField clave;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JTextField usuario;
    // End of variables declaration//GEN-END:variables
}
