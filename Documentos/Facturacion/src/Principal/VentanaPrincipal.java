/**
 * main screen of the system
 *
 * @autor. Komarofky.
 */
package Principal;

import Usuario.*;
import Cliente.*;
import Empresa.NuevaEmpresa;
import Stock.PantallaArticulo;
import Stock.PantallaMovimientoStock;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Komarofky.
 */
public class VentanaPrincipal extends javax.swing.JFrame {

    /**
     * Creates new form VentanaPrincipal
     */
    public VentanaPrincipal() {
        initComponents();
        setExtendedState(MAXIMIZED_BOTH);
        /*HACE QUE LA VENTANA OCUPE TODA LA PANTALLA*/
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jMenuBar1 = new javax.swing.JMenuBar();
        VENTAS = new javax.swing.JMenu();
        facturacion = new javax.swing.JMenuItem();
        cliente = new javax.swing.JMenuItem();
        CuentaCorriente = new javax.swing.JMenuItem();
        reporte = new javax.swing.JMenu();
        libroiva = new javax.swing.JMenuItem();
        liscliente = new javax.swing.JMenuItem();
        vencliente = new javax.swing.JMenuItem();
        venvendedor = new javax.swing.JMenuItem();
        vencondicion = new javax.swing.JMenuItem();
        STOCK = new javax.swing.JMenu();
        articulos = new javax.swing.JMenuItem();
        movstock = new javax.swing.JMenuItem();
        repor = new javax.swing.JMenu();
        lisarticulo = new javax.swing.JMenuItem();
        lisprecios = new javax.swing.JMenuItem();
        movarticulos = new javax.swing.JMenuItem();
        CONFIGURACION = new javax.swing.JMenu();
        usuario = new javax.swing.JMenuItem();
        Empresa = new javax.swing.JMenuItem();
        conexion = new javax.swing.JMenuItem();
        SALIR = new javax.swing.JMenu();
        salir = new javax.swing.JMenuItem();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);

        VENTAS.setText("         VENTAS      ");
        VENTAS.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 30)); // NOI18N
        VENTAS.setPreferredSize(new java.awt.Dimension(343, 50));

        facturacion.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        facturacion.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/page_edit.png"))); // NOI18N
        facturacion.setText("   FACTURACION");
        facturacion.setPreferredSize(new java.awt.Dimension(340, 60));
        facturacion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                facturacionActionPerformed(evt);
            }
        });
        VENTAS.add(facturacion);

        cliente.setFont(new java.awt.Font("Ubuntu", 1, 24)); // NOI18N
        cliente.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/users_mixed_gender.png"))); // NOI18N
        cliente.setText("   CLIENTES");
        cliente.setPreferredSize(new java.awt.Dimension(250, 60));
        cliente.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clienteActionPerformed(evt);
            }
        });
        VENTAS.add(cliente);

        CuentaCorriente.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        CuentaCorriente.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/folder_files.png"))); // NOI18N
        CuentaCorriente.setText("   CUENTA CORRIENTE");
        CuentaCorriente.setPreferredSize(new java.awt.Dimension(289, 60));
        CuentaCorriente.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CuentaCorrienteActionPerformed(evt);
            }
        });
        VENTAS.add(CuentaCorriente);

        reporte.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/bar_chart.png"))); // NOI18N
        reporte.setText("   REPORTE");
        reporte.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        reporte.setPreferredSize(new java.awt.Dimension(325, 60));

        libroiva.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        libroiva.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_edit.png"))); // NOI18N
        libroiva.setText("   LIBRO DE IVA");
        libroiva.setPreferredSize(new java.awt.Dimension(195, 60));
        libroiva.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                libroivaActionPerformed(evt);
            }
        });
        reporte.add(libroiva);

        liscliente.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        liscliente.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_user.png"))); // NOI18N
        liscliente.setText("   LISTADO DE CLIENTE");
        liscliente.setPreferredSize(new java.awt.Dimension(283, 60));
        liscliente.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                lisclienteActionPerformed(evt);
            }
        });
        reporte.add(liscliente);

        vencliente.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        vencliente.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_magnify.png"))); // NOI18N
        vencliente.setText("   VENTAS POR CLIENTE");
        vencliente.setPreferredSize(new java.awt.Dimension(291, 60));
        reporte.add(vencliente);

        venvendedor.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        venvendedor.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_disk.png"))); // NOI18N
        venvendedor.setText("   VENTAS POR VENDEDOR");
        venvendedor.setPreferredSize(new java.awt.Dimension(343, 60));
        reporte.add(venvendedor);

        vencondicion.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        vencondicion.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_word.png"))); // NOI18N
        vencondicion.setText("   VENTAS POR CONDICION DE VENTA");
        vencondicion.setPreferredSize(new java.awt.Dimension(475, 60));
        reporte.add(vencondicion);

        VENTAS.add(reporte);

        jMenuBar1.add(VENTAS);

        STOCK.setText("               STOCK  ");
        STOCK.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 30)); // NOI18N
        STOCK.setPreferredSize(new java.awt.Dimension(451, 39));

        articulos.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        articulos.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/stock_id.png"))); // NOI18N
        articulos.setText("   ARTICULOS");
        articulos.setPreferredSize(new java.awt.Dimension(447, 60));
        articulos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                articulosActionPerformed(evt);
            }
        });
        STOCK.add(articulos);

        movstock.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        movstock.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/barcode_gear.png"))); // NOI18N
        movstock.setText("   MOVIMIENTO DE STOCK");
        movstock.setPreferredSize(new java.awt.Dimension(279, 60));
        movstock.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                movstockActionPerformed(evt);
            }
        });
        STOCK.add(movstock);

        repor.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/bar_chart.png"))); // NOI18N
        repor.setText("   REPORTES");
        repor.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        repor.setPreferredSize(new java.awt.Dimension(325, 60));

        lisarticulo.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        lisarticulo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_edit.png"))); // NOI18N
        lisarticulo.setText("   LISTADO DE ARTICULOS");
        lisarticulo.setPreferredSize(new java.awt.Dimension(279, 60));
        repor.add(lisarticulo);

        lisprecios.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        lisprecios.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/coins_add.png"))); // NOI18N
        lisprecios.setText("   LISTAS DE PRECIOS");
        lisprecios.setPreferredSize(new java.awt.Dimension(229, 60));
        repor.add(lisprecios);

        movarticulos.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        movarticulos.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/report_add.png"))); // NOI18N
        movarticulos.setText("   MOVIMIENTO DE ARTICULOS");
        movarticulos.setPreferredSize(new java.awt.Dimension(400, 60));
        movarticulos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                movarticulosActionPerformed(evt);
            }
        });
        repor.add(movarticulos);

        STOCK.add(repor);

        jMenuBar1.add(STOCK);

        CONFIGURACION.setText("        CONFIGURACION");
        CONFIGURACION.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 30)); // NOI18N
        CONFIGURACION.setPreferredSize(new java.awt.Dimension(508, 39));

        usuario.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        usuario.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/group_add.png"))); // NOI18N
        usuario.setText("   USUARIOS");
        usuario.setPreferredSize(new java.awt.Dimension(505, 60));
        usuario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                usuarioActionPerformed(evt);
            }
        });
        CONFIGURACION.add(usuario);

        Empresa.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        Empresa.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/company_gear.png"))); // NOI18N
        Empresa.setText("   EMPRESA");
        Empresa.setPreferredSize(new java.awt.Dimension(161, 60));
        Empresa.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                EmpresaActionPerformed(evt);
            }
        });
        CONFIGURACION.add(Empresa);

        conexion.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        conexion.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/configure.png"))); // NOI18N
        conexion.setText("   CONEXION");
        conexion.setPreferredSize(new java.awt.Dimension(150, 60));
        CONFIGURACION.add(conexion);

        jMenuBar1.add(CONFIGURACION);

        SALIR.setText("         SALIR");
        SALIR.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 30)); // NOI18N
        SALIR.setPreferredSize(new java.awt.Dimension(440, 39));

        salir.setFont(new java.awt.Font("Bitstream Vera Serif", 1, 20)); // NOI18N
        salir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Imagenes/exit.png"))); // NOI18N
        salir.setText("   SALIR");
        salir.setPreferredSize(new java.awt.Dimension(438, 60));
        salir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                salirActionPerformed(evt);
            }
        });
        SALIR.add(salir);

        jMenuBar1.add(SALIR);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 1042, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 309, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    /**
     * exit the program
     *
     * @param evt
     */
    private void salirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_salirActionPerformed
        System.exit(0);
    }//GEN-LAST:event_salirActionPerformed

    /**
     * client module
     *
     * @param evt
     */
    private void usuarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_usuarioActionPerformed
        Registracion reg = new Registracion();
        reg.setVisible(true);
    }//GEN-LAST:event_usuarioActionPerformed

    /**
     * article module
     *
     * @param evt
     */
    private void articulosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_articulosActionPerformed

        try {
            PantallaArticulo a = new PantallaArticulo();
            a.setVisible(true);
        } catch (SQLException ex) {
            Logger.getLogger(VentanaPrincipal.class.getName()).log(Level.SEVERE, null, ex);
        }

    }//GEN-LAST:event_articulosActionPerformed

    /**
     * company module
     *
     * @param evt
     */
    private void EmpresaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_EmpresaActionPerformed
        NuevaEmpresa em = new NuevaEmpresa();
        em.setVisible(true);
    }//GEN-LAST:event_EmpresaActionPerformed

    /**
     * current account module
     * @param evt
     */
    private void CuentaCorrienteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CuentaCorrienteActionPerformed
        try {
            CuentaCorriente a = new CuentaCorriente();
            a.setVisible(true);
        } catch (SQLException ex) {
            Logger.getLogger(VentanaPrincipal.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_CuentaCorrienteActionPerformed

    /**
     * stock movement module
     * @param evt 
     */
    private void movstockActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_movstockActionPerformed

        try {
            PantallaMovimientoStock pm = new PantallaMovimientoStock();
            pm.setVisible(true);
        } catch (SQLException ex) {
            Logger.getLogger(VentanaPrincipal.class.getName()).log(Level.SEVERE, null, ex);
        }

    }//GEN-LAST:event_movstockActionPerformed

    private void clienteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clienteActionPerformed
        try{
            PantallaCliente pc = new PantallaCliente();
            pc.setVisible(true);
        } catch (SQLException ex){
            Logger.getLogger(VentanaPrincipal.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_clienteActionPerformed

    private void facturacionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_facturacionActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_facturacionActionPerformed

    private void libroivaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_libroivaActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_libroivaActionPerformed

    private void lisclienteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_lisclienteActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_lisclienteActionPerformed

    private void movarticulosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_movarticulosActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_movarticulosActionPerformed

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
            java.util.logging.Logger.getLogger(VentanaPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(VentanaPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(VentanaPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(VentanaPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> {
            new VentanaPrincipal().setVisible(true);
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenu CONFIGURACION;
    private javax.swing.JMenuItem CuentaCorriente;
    private javax.swing.JMenuItem Empresa;
    private javax.swing.JMenu SALIR;
    private javax.swing.JMenu STOCK;
    private javax.swing.JMenu VENTAS;
    private javax.swing.JMenuItem articulos;
    private javax.swing.JMenuItem cliente;
    private javax.swing.JMenuItem conexion;
    private javax.swing.JMenuItem facturacion;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuItem libroiva;
    private javax.swing.JMenuItem lisarticulo;
    private javax.swing.JMenuItem liscliente;
    private javax.swing.JMenuItem lisprecios;
    private javax.swing.JMenuItem movarticulos;
    private javax.swing.JMenuItem movstock;
    private javax.swing.JMenu repor;
    private javax.swing.JMenu reporte;
    private javax.swing.JMenuItem salir;
    private javax.swing.JMenuItem usuario;
    private javax.swing.JMenuItem vencliente;
    private javax.swing.JMenuItem vencondicion;
    private javax.swing.JMenuItem venvendedor;
    // End of variables declaration//GEN-END:variables
}