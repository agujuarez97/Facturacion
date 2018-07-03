/**
 * New stock movement
 *
 * @autor. Komarofky.
 */
package Stock;

import Avisos.ArticuloExistente;
import Avisos.MovimientoArticulo;
import Avisos.MovimientoCantidad;
import Avisos.MovimientoRepetido;
import DataBase.Conexion;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Komarofky.
 */
public class NuevoMovimiento extends javax.swing.JFrame {

    /**
     * Creates new form MovimientoStock
     */
    public NuevoMovimiento() {
        initComponents();
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
        buscar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);

        NombreTabla.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "NUEVO MOVIMIENTO", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Bitstream Vera Serif", 1, 20), new java.awt.Color(0, 0, 0))); // NOI18N
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

        buscar.setFont(new java.awt.Font("Dialog", 1, 24)); // NOI18N
        buscar.setText("...");
        buscar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                buscarActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout NombreTablaLayout = new javax.swing.GroupLayout(NombreTabla);
        NombreTabla.setLayout(NombreTablaLayout);
        NombreTablaLayout.setHorizontalGroup(
            NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(NombreTablaLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(aceptar, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(NombreTablaLayout.createSequentialGroup()
                        .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(Cod_Cliente, javax.swing.GroupLayout.DEFAULT_SIZE, 113, Short.MAX_VALUE)
                            .addComponent(Cod_Cliente2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(Cod_Cliente3, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addGap(33, 33, 33)
                        .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cant, javax.swing.GroupLayout.PREFERRED_SIZE, 79, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(tipoMov, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(NombreTablaLayout.createSequentialGroup()
                                .addComponent(codigo, javax.swing.GroupLayout.PREFERRED_SIZE, 113, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(buscar, javax.swing.GroupLayout.PREFERRED_SIZE, 62, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(11, 11, 11)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, NombreTablaLayout.createSequentialGroup()
                .addContainerGap(451, Short.MAX_VALUE)
                .addComponent(salir, javax.swing.GroupLayout.PREFERRED_SIZE, 149, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(256, 256, 256))
        );
        NombreTablaLayout.setVerticalGroup(
            NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(NombreTablaLayout.createSequentialGroup()
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, NombreTablaLayout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(buscar, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, NombreTablaLayout.createSequentialGroup()
                        .addContainerGap(98, Short.MAX_VALUE)
                        .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(Cod_Cliente2, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(codigo, javax.swing.GroupLayout.Alignment.TRAILING))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(Cod_Cliente, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(tipoMov))
                .addGap(18, 18, 18)
                .addGroup(NombreTablaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(Cod_Cliente3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(cant))
                .addGap(51, 51, 51)
                .addComponent(aceptar, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(55, 55, 55)
                .addComponent(salir, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(NombreTabla, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(NombreTabla, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    /**
     * cancel action
     *
     * @param evt
     */

    private void salirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_salirActionPerformed
        try {
            this.dispose();
            PantallaMovimientoStock ms = new PantallaMovimientoStock();
            ms.setVisible(true);
        } catch (SQLException ex) {
            Logger.getLogger(NuevoMovimiento.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_salirActionPerformed

    private void tipoMovActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_tipoMovActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_tipoMovActionPerformed

    /**
     * save the stock movement
     *
     * @param evt
     */

    private void aceptarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aceptarActionPerformed
        try {

            Conexion sc = new Conexion("org.postgresql.Driver", "jdbc:postgresql://127.0.0.1:5432/postgres", "root", DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/postgres", "postgres", "root"), "postgres");
            String query4 = "SELECT * FROM facturacion.movimiento_actual WHERE cod_articulo = '" + codigo.getText() + "'";
            PreparedStatement statement4 = sc.getConnectio().prepareStatement(query4);
            ResultSet res4 = statement4.executeQuery();
            if (!res4.next()) {
                /*
                 * article no repeat
                 */
                String query5 = "SELECT * FROM facturacion.Articulo WHERE cod_articulo = '" + codigo.getText() + "'";
                PreparedStatement statement5 = sc.getConnectio().prepareStatement(query5);
                ResultSet res5 = statement5.executeQuery();
                if (res5.next()) {
                    /*
                     * article exist
                     */
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
                        String query6 = "INSERT INTO facturacion.movimiento_actual (cod_articulo, cantidad, tipo) values('" + codigo.getText() + "', '" + Integer.parseInt(cant.getText()) + "', '" + (String) tipoMov.getSelectedItem() + "')";
                        PreparedStatement statement6 = sc.getConnectio().prepareStatement(query6);
                        statement6.executeUpdate();
                        this.dispose();
                        NuevoMovimiento nv = new NuevoMovimiento();
                        nv.setVisible(true);

                    }
                } else {
                    /**
                     * article not exist
                     */
                    MovimientoArticulo mov = new MovimientoArticulo();
                    mov.setVisible(true);

                }
            } else {
                /*
                 * article repeat
                 */
                MovimientoRepetido mr = new MovimientoRepetido();
                mr.setVisible(true);
            }

        } catch (SQLException ex) {
            Logger.getLogger(NuevoMovimiento.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_aceptarActionPerformed

    /**
     * search list article
     *
     * @param evt
     */
    private void buscarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buscarActionPerformed
        // TODO add your handling code here:

    }//GEN-LAST:event_buscarActionPerformed

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
            java.util.logging.Logger.getLogger(NuevoMovimiento.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(NuevoMovimiento.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(NuevoMovimiento.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(NuevoMovimiento.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> {
            new NuevoMovimiento().setVisible(true);
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel Cod_Cliente;
    private javax.swing.JLabel Cod_Cliente2;
    private javax.swing.JLabel Cod_Cliente3;
    private javax.swing.JPanel NombreTabla;
    private javax.swing.JButton aceptar;
    private javax.swing.JButton buscar;
    private javax.swing.JTextField cant;
    private javax.swing.JTextField codigo;
    private javax.swing.JButton salir;
    private javax.swing.JComboBox<String> tipoMov;
    // End of variables declaration//GEN-END:variables
}