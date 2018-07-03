/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Stock;

import Avisos.MovimientoCantidad;
import DataBase.Conexion;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JComboBox;
import javax.swing.JTextField;

/**
 *
 * @author matias
 */
public class EditarMovimiento extends javax.swing.JFrame {

    /**
     * Creates new form editarNuevoMovimiento
     */
    public EditarMovimiento() {
        initComponents();
        codigo.setEditable(false);
        this.setLocationRelativeTo(null);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        NombreTabla = new javax.swing.JPanel();
        Cod_Cliente = new javax.swing.JLabel();
        Cod_Cliente2 = new javax.swing.JLabel();
        Cod_Cliente3 = new javax.swing.JLabel();
        salir = new javax.swing.JButton();
        tipoMov = new javax.swing.JComboBox<>();
        aceptar = new javax.swing.JButton();
        cant = new javax.swing.JTextField();
        codigo = new javax.swing.JTextField();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);

        NombreTabla.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "EDITAR MOVIMIENTO", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Bitstream Vera Serif", 1, 20), new java.awt.Color(0, 0, 0))); // NOI18N
        NombreTabla.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N

        Cod_Cliente.setFont(new java.awt.Font("Bitstream Vera Serif", 0, 20)); // NOI18N
        Cod_Cliente.setText(" TIPO");
        Cod_Cliente.setPreferredSize(new java.awt.Dimension(199, 24));

        Cod_Cliente2.setFont(new java.awt.Font("Bitstream Vera Serif", 0, 20)); // NOI18N
        Cod_Cliente2.setText("ARTICULO");
        Cod_Cliente2.setPreferredSize(new java.awt.Dimension(199, 24));

        Cod_Cliente3.setFont(new java.awt.Font("Bitstream Vera Serif", 0, 20)); // NOI18N
        Cod_Cliente3.setText("CANTIDAD");
        Cod_Cliente3.setPreferredSize(new java.awt.Dimension(199, 24));

        salir.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        salir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/delete.png"))); // NOI18N
        salir.setText("SALIR");
        salir.setPreferredSize(new java.awt.Dimension(122, 36));
        salir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                salirActionPerformed(evt);
            }
        });

        tipoMov.setFont(new java.awt.Font("Bitstream Vera Serif", 0, 20)); // NOI18N
        tipoMov.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "INGRESO", "EGRESO" }));
        tipoMov.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                tipoMovActionPerformed(evt);
            }
        });

        aceptar.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 14)); // NOI18N
        aceptar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/accept.png"))); // NOI18N
        aceptar.setText("ACEPTAR");
        aceptar.setPreferredSize(new java.awt.Dimension(122, 36));
        aceptar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aceptarActionPerformed(evt);
            }
        });

        cant.setFont(new java.awt.Font("Ubuntu", 0, 20)); // NOI18N

        codigo.setFont(new java.awt.Font("Ubuntu", 0, 20)); // NOI18N

        javax.swing.GroupLayout NombreTablaLayout = new javax.swing.GroupLayout(NombreTabla);
        NombreTabla.setLayout(NombreTablaLayout);
        NombreTablaLayout.setHorizontalGroup(
            NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, NombreTablaLayout.createSequentialGroup()
                .addContainerGap(442, Short.MAX_VALUE)
                .addComponent(salir, javax.swing.GroupLayout.PREFERRED_SIZE, 149, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(209, 209, 209))
            .addGroup(NombreTablaLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(aceptar, javax.swing.GroupLayout.PREFERRED_SIZE, 154, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(NombreTablaLayout.createSequentialGroup()
                        .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(Cod_Cliente, javax.swing.GroupLayout.DEFAULT_SIZE, 113, Short.MAX_VALUE)
                            .addComponent(Cod_Cliente2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(Cod_Cliente3, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addGap(33, 33, 33)
                        .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(codigo, javax.swing.GroupLayout.PREFERRED_SIZE, 113, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(tipoMov, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(cant, javax.swing.GroupLayout.PREFERRED_SIZE, 79, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(28, 28, 28)))
                .addContainerGap(466, Short.MAX_VALUE))
        );
        NombreTablaLayout.setVerticalGroup(
            NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(NombreTablaLayout.createSequentialGroup()
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(NombreTablaLayout.createSequentialGroup()
                        .addGap(86, 86, 86)
                        .addComponent(Cod_Cliente2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, NombreTablaLayout.createSequentialGroup()
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(codigo, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(Cod_Cliente, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(tipoMov))
                .addGap(18, 18, 18)
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(Cod_Cliente3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(cant))
                .addGap(55, 55, 55)
                .addComponent(aceptar, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(48, 48, 48)
                .addComponent(salir, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(NombreTabla, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(37, Short.MAX_VALUE)
                .addComponent(NombreTabla, javax.swing.GroupLayout.PREFERRED_SIZE, 457, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void salirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_salirActionPerformed
        try {
            this.dispose();
            PantallaMovimientoStock ms = new PantallaMovimientoStock();
            ms.setVisible(true);
        } catch (SQLException ex) {
            Logger.getLogger(EditarMovimiento.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_salirActionPerformed

    private void tipoMovActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_tipoMovActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_tipoMovActionPerformed

    private void aceptarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aceptarActionPerformed
        try {
            Conexion sc = new Conexion("org.postgresql.Driver", "jdbc:postgresql://127.0.0.1:5432/postgres", "root", DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/postgres", "postgres", "root"), "postgres");
            if (("".equals(cant.getText())) || (Integer.parseInt(cant.getText()) < 1)) {
                /*
                 * cant not exist or invalid
                 */
                MovimientoCantidad mc = new MovimientoCantidad();
                mc.setVisible(true);
            } else {
                /*
                 * cant exist and valid
                 */
                String query5 = "UPDATE facturacion.movimiento_actual SET cantidad = '" + Integer.parseInt(cant.getText()) + "' , tipo = '" + (String) tipoMov.getSelectedItem() + "' WHERE cod_articulo ='" + codigo.getText() + "'";
                PreparedStatement statement6 = sc.getConnectio().prepareStatement(query5);
                statement6.executeUpdate();
                this.dispose();
                PantallaMovimientoStock ms = new PantallaMovimientoStock();
                ms.setVisible(true);
            }

        } catch (SQLException ex) {
            Logger.getLogger(NuevoMovimiento.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_aceptarActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(EditarMovimiento.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(EditarMovimiento.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(EditarMovimiento.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(EditarMovimiento.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> {
            new EditarMovimiento().setVisible(true);
        });
    }

    /**
     *
     * @return code of the article
     */
    public JTextField getCodigo() {
        return codigo;
    }

    /**
     *
     * @return units of the article
     */
    public JTextField getCantidad() {
        return cant;
    }

    /**
     *
     * @return movement type
     */
    public JComboBox getTipoMovimiento() {
        return tipoMov;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel Cod_Cliente;
    private javax.swing.JLabel Cod_Cliente2;
    private javax.swing.JLabel Cod_Cliente3;
    private javax.swing.JPanel NombreTabla;
    private javax.swing.JButton aceptar;
    private javax.swing.JTextField cant;
    private javax.swing.JTextField codigo;
    private javax.swing.JButton salir;
    private javax.swing.JComboBox<String> tipoMov;
    // End of variables declaration//GEN-END:variables
}
