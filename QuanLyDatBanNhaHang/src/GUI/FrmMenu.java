package GUI;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.sql.*;

public class FrmMenu extends JFrame {

    private JPanel panelMenu;

    public FrmMenu() {
        setTitle("Thực đơn nhà hàng");
        setSize(900, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        panelMenu = new JPanel();
        panelMenu.setLayout(new GridLayout(0, 4, 15, 15));
        panelMenu.setBackground(Color.WHITE);

        JScrollPane scrollPane = new JScrollPane(panelMenu);
        add(scrollPane);

        loadDataFromDatabase();
    }

    private void loadDataFromDatabase() {

        String url = "jdbc:sqlserver://localhost:1433;databaseName=QuanLyNhaHang;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String password = "sapassword";

        String sql = "SELECT tenMonAn, giaBan, donVi, moTa, anhMon FROM MonAn WHERE tinhTrang = 1";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            panelMenu.removeAll();

            while (rs.next()) {
                String ten = rs.getString("tenMonAn");
                String gia = String.format("%,.0f đ", rs.getFloat("giaBan"));
                String donVi = rs.getString("donVi");
                String moTa = rs.getString("moTa");
                String anh = rs.getString("anhMon");

                panelMenu.add(createItem(ten, gia, donVi, moTa, anh));
            }

            panelMenu.revalidate();
            panelMenu.repaint();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private JPanel createItem(String ten, String gia, String donVi, String moTa, String anh) {

        JPanel item = new JPanel();
        item.setPreferredSize(new Dimension(180, 220));
        item.setLayout(new BorderLayout());
        item.setBorder(BorderFactory.createLineBorder(new Color(220, 220, 220)));
        item.setBackground(Color.WHITE);

        JLabel lblImg = new JLabel();
        lblImg.setPreferredSize(new Dimension(180, 130));
        lblImg.setHorizontalAlignment(SwingConstants.CENTER);

        hienThiAnh(lblImg, anh);


        JPanel info = new JPanel(new GridLayout(2,1));
        info.setBackground(Color.WHITE);

        JLabel lblTen = new JLabel(ten, SwingConstants.CENTER);
        lblTen.setFont(new Font("Segoe UI", Font.BOLD, 14));

        JLabel lblGia = new JLabel(gia, SwingConstants.CENTER);
        lblGia.setForeground(Color.RED);

        info.add(lblTen);
        info.add(lblGia);

        item.add(lblImg, BorderLayout.NORTH);
        item.add(info, BorderLayout.CENTER);

        item.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                showDetail(ten, gia, donVi, moTa, anh);
            }
        });

        return item;
    }

    private void hienThiAnh(JLabel label, String path) {

        label.setIcon(null);

        if (path == null || path.trim().isEmpty()) {
            label.setText("No Image");
            return;
        }

        try {
            ImageIcon icon;

            File file = new File(path);
            if (file.exists()) {
                icon = new ImageIcon(path);
            } else {
                // nếu là ảnh trong project
                java.net.URL url = getClass().getResource("/images/monan/" + path);
                if (url == null) {
                    label.setText("Not found");
                    return;
                }
                icon = new ImageIcon(url);
            }

            Image img = icon.getImage().getScaledInstance(180, 130, Image.SCALE_SMOOTH);
            label.setText("");
            label.setIcon(new ImageIcon(img));

        } catch (Exception e) {
            label.setText("Error");
        }
    }

    private void showDetail(String ten, String gia, String donVi, String moTa, String anh) {

        JPanel panel = new JPanel(new BorderLayout(10,10));
        panel.setPreferredSize(new Dimension(350, 300));


        JLabel lblImg = new JLabel();
        lblImg.setHorizontalAlignment(SwingConstants.CENTER);
        hienThiAnh(lblImg, anh);

        JLabel lblInfo = new JLabel(
                "<html><h2>" + ten + "</h2>" +
                        "<b>Giá:</b> " + gia + "<br>" +
                        "<b>Đơn vị:</b> " + donVi + "<br><br>" +
                        "<b>Mô tả:</b><br>" + (moTa == null ? "..." : moTa) +
                        "</html>"
        );

        panel.add(lblImg, BorderLayout.NORTH);
        panel.add(lblInfo, BorderLayout.CENTER);

        JOptionPane.showMessageDialog(this, panel, "Chi tiết món ăn", JOptionPane.PLAIN_MESSAGE);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new FrmMenu().setVisible(true));
    }
}