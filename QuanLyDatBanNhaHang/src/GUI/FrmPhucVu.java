package GUI;

import DAO.PhucVuService;
import DAO.PhucVuServiceDb;
import Entity.MonAn;
import Entity.NhanVien;
import Model.BanAnModel;
import Model.MonAnModel;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.LineBorder;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

public class FrmPhucVu extends JFrame {

    private final NhanVien nhanVien;
    private final PhucVuService phucVuService = new PhucVuServiceDb();

    // Palette màu sắc hiện đại
    private static final Color PRIMARY_COLOR   = new Color(37, 99, 235);
    private static final Color SUCCESS_COLOR   = new Color(22, 163, 74);
    private static final Color DANGER_COLOR    = new Color(220, 38, 38);
    private static final Color BG_LIGHT        = new Color(249, 250, 251);
    private static final Color TEXT_MAIN       = new Color(17, 24, 39);
    private static final Color TEXT_SECONDARY  = new Color(107, 114, 128);
    private static final Color BORDER_COLOR    = new Color(229, 231, 235);

    private List<BanAnModel> danhSachBan;
    private BanAnModel banDangChon;
    private JPanel pnlDanhSachBan;
    private JPanel pnlChiTiet;
    private JTable tblMon;
    private JTabbedPane tabbedPane;
    private DefaultTableModel tblModel;

   
    private TableModelListener trangThaiListener;

    private JButton btnYeuCauTT;
    private JButton btnThemMon;
    private SwingWorker<List<BanAnModel>, Void> currentWorker;

    public FrmPhucVu(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
        initUI();
        taiDanhSachBan();

        Timer timer = new Timer(5000, e -> {
                    if (tblMon != null && !tblMon.isEditing()) {
                taiDanhSachBan();
            }
        });
        timer.setInitialDelay(5000);
        timer.start();
    }

    private void initUI() {
        try {
            UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception ignored) {}

        setTitle("Hệ thống Phục vụ - Nhà hàng Ngói Đỏ");
        setSize(1280, 800);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        // Khởi tạo JTabbedPane (đảm bảo đã khai báo 'private JTabbedPane tabbedPane;' ở trên đầu class)
        tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("Inter", Font.BOLD, 14));

        // --- CẤU CẤU TAB 1: PHỤC VỤ ---
        JPanel pnlPhucVuTab = new JPanel(new BorderLayout());
        pnlPhucVuTab.setBackground(BG_LIGHT);
        pnlPhucVuTab.add(createTopBar(), BorderLayout.NORTH);

        JSplitPane split = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, createLeftPanel(), createRightPanel());
        split.setDividerLocation(320);
        split.setDividerSize(1);
        split.setBorder(null);
        pnlPhucVuTab.add(split, BorderLayout.CENTER);

        // --- CẤU HÌNH TAB 2: THỰC ĐƠN ---
        // Khởi tạo FrmMenu để lấy giao diện bảng món ăn
        FrmMenu menu = new FrmMenu(); 
        
        // Thêm cả 2 vào TabbedPane ngay từ đầu
        tabbedPane.addTab("Phục Vụ", pnlPhucVuTab);
        tabbedPane.addTab("Thực Đơn", menu.getContentPane()); // Lấy phần nội dung của FrmMenu nhét vào tab
        
        // Đưa tabbedPane lên làm giao diện chính
        setContentPane(tabbedPane);
    }

    private void taiDanhSachBan() {
        if (currentWorker != null && !currentWorker.isDone()) {
            currentWorker.cancel(true);
        }

        currentWorker = new SwingWorker<>() {
            @Override
            protected List<BanAnModel> doInBackground() {
                return phucVuService.getDanhSachBanCanPhucVu();
            }

            @Override
            protected void done() {
                if (isCancelled()) return;
                try {
                    danhSachBan = get();
                    	if (banDangChon != null && danhSachBan != null) {
                        for (BanAnModel b : danhSachBan) {
                            if (b.maBan.equals(banDangChon.maBan)) {
                                banDangChon = b;
                                break;
                            }
                        }
                    }
                    veLaiDanhSachBan();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };
        currentWorker.execute();
    }


    private JPanel createTopBar() {
        JPanel bar = new JPanel(new BorderLayout());
        bar.setBackground(Color.WHITE);
        bar.setPreferredSize(new Dimension(0, 70));
        bar.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, BORDER_COLOR));

        JPanel left = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 15));
        left.setOpaque(false);

        JLabel btnBack = new JLabel("Đăng xuất");
        btnBack.setFont(new Font("Inter", Font.BOLD, 14));
        btnBack.setForeground(PRIMARY_COLOR);
        btnBack.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnBack.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) { dispose(); }
        });

        JLabel sep = new JLabel("|");
        sep.setForeground(BORDER_COLOR);

        JLabel title = new JLabel("QUẢN LÝ PHỤC VỤ");
        title.setFont(new Font("Inter", Font.BOLD, 18));
        title.setForeground(TEXT_MAIN);

        left.add(btnBack);
        left.add(sep);
        left.add(title);

        JPanel right = new JPanel(new FlowLayout(FlowLayout.RIGHT, 20, 15));
        right.setOpaque(false);

        JLabel lbUser = new JLabel(nhanVien.getHoTenNV());
        lbUser.setFont(new Font("Inter", Font.BOLD, 14));
        right.add(lbUser);

        bar.add(left, BorderLayout.WEST);
        bar.add(right, BorderLayout.EAST);
        
        JButton btnXemMenu = new JButton("XEM THỰC ĐƠN");
        btnXemMenu.setFont(new Font("Inter", Font.BOLD, 13));
        btnXemMenu.addActionListener(e -> {
            // Chỉ cần tìm vị trí tab "Thực Đơn" và nhảy đến đó
            for (int i = 0; i < tabbedPane.getTabCount(); i++) {
                if (tabbedPane.getTitleAt(i).equals("Thực Đơn")) {
                    tabbedPane.setSelectedIndex(i);
                    break;
                }
            }
        });

        left.add(btnBack);
        left.add(sep);
        left.add(title);
        left.add(btnXemMenu);
        
        return bar;
    }

    private JPanel createLeftPanel() {
        JPanel left = new JPanel(new BorderLayout());
        left.setBackground(Color.WHITE);
        left.setBorder(BorderFactory.createMatteBorder(0, 0, 0, 1, BORDER_COLOR));

        JLabel lbHeader = new JLabel("DANH SÁCH BÀN");
        lbHeader.setFont(new Font("Inter", Font.BOLD, 13));
        lbHeader.setForeground(TEXT_SECONDARY);
        lbHeader.setBorder(new EmptyBorder(20, 20, 10, 20));

        pnlDanhSachBan = new JPanel();
        pnlDanhSachBan.setBackground(Color.WHITE);
        pnlDanhSachBan.setLayout(new BoxLayout(pnlDanhSachBan, BoxLayout.Y_AXIS));

        JScrollPane scroll = new JScrollPane(pnlDanhSachBan);
        scroll.setBorder(null);
        scroll.getVerticalScrollBar().setUnitIncrement(16);

        left.add(lbHeader, BorderLayout.NORTH);
        left.add(scroll, BorderLayout.CENTER);
        
        JButton btnXemMenu = new JButton("XEM THỰC ĐƠN");
        btnXemMenu.addActionListener(e -> {
            // Kiểm tra tab tồn tại
            for (int i = 0; i < tabbedPane.getTabCount(); i++) {
                if (tabbedPane.getTitleAt(i).equals("Thực Đơn")) {
                    tabbedPane.setSelectedIndex(i);
                    return;
                }
            }
            // Mở tab mới
            FrmMenu menu = new FrmMenu(); // Đảm bảo bên FrmMenu có Constructor này
            tabbedPane.addTab("Thực Đơn", menu.getContentPane());
            tabbedPane.setSelectedIndex(tabbedPane.getTabCount() - 1);
        });
        return left;
    }

    private void veLaiDanhSachBan() {
        SwingUtilities.invokeLater(() -> {
            pnlDanhSachBan.removeAll();

            if (danhSachBan != null && !danhSachBan.isEmpty()) {
                java.util.Set<String> processedIds = new java.util.HashSet<>();
                for (BanAnModel ban : danhSachBan) {
                    if (!processedIds.contains(ban.maBan)) {
                        pnlDanhSachBan.add(taoTheBan(ban));
                        pnlDanhSachBan.add(Box.createVerticalStrut(10));
                        processedIds.add(ban.maBan);
                    } else {
                        // FIX #6: Log cảnh báo khi service trả về bàn trùng
                        System.err.println("[WARN] veLaiDanhSachBan: maBan trùng lặp = " + ban.maBan);
                    }
                }
            }

            pnlDanhSachBan.revalidate();
            pnlDanhSachBan.repaint();
        });
    }

    private JPanel taoTheBan(BanAnModel ban) {
        boolean isSelected = (banDangChon != null && ban.maBan.equals(banDangChon.maBan));

        JPanel card = new JPanel(new BorderLayout(10, 10));
        card.setBackground(isSelected ? new Color(239, 246, 255) : Color.WHITE);
        card.setBorder(BorderFactory.createCompoundBorder(
                new EmptyBorder(5, 15, 5, 15),
                BorderFactory.createLineBorder(isSelected ? PRIMARY_COLOR : BORDER_COLOR, 1, true)
        ));
        card.setMaximumSize(new Dimension(Integer.MAX_VALUE, 90));
        card.setCursor(new Cursor(Cursor.HAND_CURSOR));

        JPanel content = new JPanel(new GridLayout(2, 1, 0, 5));
        content.setOpaque(false);

        JLabel lbName = new JLabel(ban.tenBan);
        lbName.setFont(new Font("Inter", Font.BOLD, 15));
        lbName.setForeground(isSelected ? PRIMARY_COLOR : TEXT_MAIN);

        JLabel lbPrice = new JLabel(formatTien(ban.tamTinh) + " đ");
        lbPrice.setFont(new Font("Inter", Font.PLAIN, 13));
        lbPrice.setForeground(DANGER_COLOR);

        content.add(lbName);
        content.add(lbPrice);
        card.add(content, BorderLayout.CENTER);

        JPanel indicator = new JPanel();
        indicator.setPreferredSize(new Dimension(4, 0));
        indicator.setBackground(isSelected ? PRIMARY_COLOR : new Color(209, 213, 219));
        card.add(indicator, BorderLayout.WEST);

        card.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                banDangChon = ban;
                veLaiDanhSachBan();
                hienThiChiTietBan(ban);
            }
        });

        return card;
    }

    private JPanel createRightPanel() {
        pnlChiTiet = new JPanel(new BorderLayout());
        pnlChiTiet.setBackground(BG_LIGHT);
        hienThiGoiChonBan();
        return pnlChiTiet;
    }

    private void hienThiGoiChonBan() {
        pnlChiTiet.removeAll();
        JLabel lb = new JLabel("Chọn một bàn để xem chi tiết.");
        lb.setHorizontalAlignment(SwingConstants.CENTER);
        pnlChiTiet.add(lb, BorderLayout.CENTER);
        pnlChiTiet.revalidate();
        pnlChiTiet.repaint();
    }

    private void hienThiChiTietBan(BanAnModel ban) {
        pnlChiTiet.removeAll();

        JPanel mainContent = new JPanel(new BorderLayout(0, 20));
        mainContent.setOpaque(false);
        mainContent.setBorder(new EmptyBorder(25, 30, 25, 30));

        // Header
        JPanel header = new JPanel(new BorderLayout());
        header.setOpaque(false);

        JLabel title = new JLabel(ban.tenBan.toUpperCase());
        title.setFont(new Font("Inter", Font.BOLD, 24));

        JLabel subTitle = new JLabel("Mã hóa đơn: " + (ban.maHD != null ? ban.maHD : "N/A"));
        subTitle.setForeground(TEXT_SECONDARY);

        JPanel titleGrp = new JPanel(new GridLayout(2, 1, 0, 5));
        titleGrp.setOpaque(false);
        titleGrp.add(title);
        titleGrp.add(subTitle);
        header.add(titleGrp, BorderLayout.WEST);

        // Bảng món
        tblModel = new DefaultTableModel(
                new String[]{"ID", "Mã món", "Tên món", "SL", "Đơn giá", "Thành tiền", "Trạng thái"}, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return c == 6; }
        };
        
        trangThaiListener = e -> {
            if (e.getType() == TableModelEvent.UPDATE && e.getColumn() == 6) {
                int row = e.getFirstRow();
                Object idObj = tblModel.getValueAt(row, 0);
                Object ttObj = tblModel.getValueAt(row, 6);
                if (idObj != null && ttObj != null) {
                    int idCTHD = (int) idObj;
                    String trangThaiMoi = ttObj.toString();
                    phucVuService.capNhatTrangThaiMon(idCTHD, trangThaiMoi);
                }
            }
        };
        tblModel.addTableModelListener(trangThaiListener);

        tblMon = new JTable(tblModel);
        setupTableStyle(tblMon);

        JComboBox<String> cboStatus = new JComboBox<>(new String[]{"Chưa lên", "Đã lên", "Mang về", "Hủy"});
        tblMon.getColumnModel().getColumn(6).setCellEditor(new DefaultCellEditor(cboStatus));

        JScrollPane scroll = new JScrollPane(tblMon);
        scroll.setBorder(new LineBorder(BORDER_COLOR, 1));
        scroll.getViewport().setBackground(Color.WHITE);

        JPanel footer = new JPanel(new FlowLayout(FlowLayout.RIGHT, 15, 0));
        footer.setOpaque(false);

        boolean choThanhToan = "Chờ thanh toán".equalsIgnoreCase(ban.trangThai);

        btnThemMon  = createStyledButton("Thêm món mới", Color.WHITE, TEXT_MAIN, false);
        btnYeuCauTT = createStyledButton("YÊU CẦU THANH TOÁN", PRIMARY_COLOR, Color.WHITE, true);

        btnThemMon.setEnabled(!choThanhToan);
        // FIX #4: Chưa enable btnYeuCauTT ở đây – sẽ enable SAU khi napBangMonTuHoaDon() xong
        btnYeuCauTT.setEnabled(false);

        btnThemMon.addActionListener(e -> {
            if (moHopThoaiThemNhieuMon(ban)) {
                taiDanhSachBan();
                hienThiChiTietBan(ban);
            }
        });
        btnYeuCauTT.addActionListener(e -> xuLyThanhToan(ban));

        footer.add(btnThemMon);
        footer.add(btnYeuCauTT);

        mainContent.add(header, BorderLayout.NORTH);
        mainContent.add(scroll, BorderLayout.CENTER);
        mainContent.add(footer, BorderLayout.SOUTH);

        pnlChiTiet.add(mainContent, BorderLayout.CENTER);

        napBangMonTuHoaDon();
        btnYeuCauTT.setEnabled(!choThanhToan && tblModel.getRowCount() > 0);

        pnlChiTiet.revalidate();
        pnlChiTiet.repaint();
    }

    private void setupTableStyle(JTable table) {
        table.setRowHeight(45);
        table.setIntercellSpacing(new Dimension(0, 0));
        table.setSelectionBackground(new Color(243, 244, 246));
        table.setSelectionForeground(TEXT_MAIN);
        table.setFont(new Font("Inter", Font.PLAIN, 14));
        table.setShowVerticalLines(false);
        table.setGridColor(BORDER_COLOR);

        JTableHeader header = table.getTableHeader();
        header.setBackground(new Color(249, 250, 251));
        header.setFont(new Font("Inter", Font.BOLD, 13));
        header.setPreferredSize(new Dimension(0, 40));
        header.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, BORDER_COLOR));

        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        table.getColumnModel().getColumn(3).setCellRenderer(centerRenderer);

        // Ẩn cột ID và Mã món
        table.getColumnModel().getColumn(0).setMinWidth(0);
        table.getColumnModel().getColumn(0).setMaxWidth(0);
        table.getColumnModel().getColumn(1).setMinWidth(0);
        table.getColumnModel().getColumn(1).setMaxWidth(0);
    }

    private JButton createStyledButton(String text, Color bg, Color fg, boolean isPrimary) {
        JButton btn = new JButton(text) {
            @Override
            protected void paintComponent(Graphics g) {
                if (!isEnabled()) {
                    setBackground(new Color(229, 231, 235));
                    setForeground(new Color(156, 163, 175));
                } else {
                    setBackground(bg);
                    setForeground(fg);
                }
                super.paintComponent(g);
            }
        };
        btn.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btn.setFocusPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setPreferredSize(new Dimension(200, 45));
        btn.setBackground(bg);
        btn.setForeground(fg);
        btn.setOpaque(true);

        if (!isPrimary) {
            btn.setBorder(BorderFactory.createLineBorder(BORDER_COLOR));
        } else {
            btn.setBorder(BorderFactory.createEmptyBorder());
        }

        btn.addMouseListener(new MouseAdapter() {
            public void mouseEntered(MouseEvent evt) {
                if (btn.isEnabled()) {
                    btn.setBackground(isPrimary ? bg.darker() : new Color(243, 244, 246));
                }
            }
            public void mouseExited(MouseEvent evt) {
                if (btn.isEnabled()) {
                    btn.setBackground(bg);
                }
            }
        });

        return btn;
    }

    private void napBangMonTuHoaDon() {
        // Ngắt listener trước khi nạp
        tblModel.removeTableModelListener(trangThaiListener);
        tblModel.setRowCount(0);

        String trangThai = banDangChon.trangThai;
        List<MonAnModel> ds = phucVuService.getMonAnTheoBan(banDangChon.maBan, trangThai);

        for (MonAnModel m : ds) {
            tblModel.addRow(new Object[]{
                m.id_cthd, m.maMonAn, m.tenMonAn,
                m.soLuong, formatTien(m.giaBan),
                formatTien(m.thanhTien), m.trangThaiPhucVu
            });
        }

        // Gắn lại listener sau khi nạp xong
        tblModel.addTableModelListener(trangThaiListener);
    }

    private boolean moHopThoaiThemNhieuMon(BanAnModel ban) {
        if (ban.maHD == null || ban.maHD.trim().isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Bàn " + ban.tenBan + " chưa có hóa đơn.\n"
                    + "Vui lòng liên hệ Lễ Tân Check-in để có Mã HD trước khi thêm món!",
                    "Không tìm thấy Hóa Đơn", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if ("Chờ thanh toán".equalsIgnoreCase(ban.trangThai)) {
            JOptionPane.showMessageDialog(this,
                    "Bàn này đã yêu cầu thanh toán, không thể thêm món nữa.",
                    "Không thể thêm món", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        List<MonAn> dsMon = phucVuService.getMonAnDangPhucVu();

        // Build UI thêm món
        JList<MonAn> listMon       = buildMonList(dsMon);
        DefaultTableModel modelTam = buildOrderTableModel();
        JTable tblTam              = buildOrderTable(modelTam);
        JSpinner spSoLuong         = new JSpinner(new SpinnerNumberModel(1, 1, 100, 1));
        JTextField txtGhiChu       = new JTextField();

        JButton btnThemVaoDS = new JButton("Thêm vào danh sách");
        btnThemVaoDS.addActionListener(e -> themMonVaoDanhSach(listMon, modelTam, spSoLuong, txtGhiChu));

        JButton btnXoaDong = new JButton("Xóa món đã chọn");
        btnXoaDong.addActionListener(e -> {
            int row = tblTam.getSelectedRow();
            if (row >= 0) modelTam.removeRow(row);
        });

        JSplitPane split = buildThemMonSplitPane(listMon, tblTam, spSoLuong, txtGhiChu, btnThemVaoDS, btnXoaDong);

        JPanel panel = new JPanel(new BorderLayout());
        panel.setPreferredSize(new Dimension(820, 420));
        panel.add(split, BorderLayout.CENTER);

        int result = JOptionPane.showConfirmDialog(this, panel,
                "Thêm món cho " + ban.tenBan, JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

        if (result != JOptionPane.OK_OPTION) return false;

        if (modelTam.getRowCount() == 0) {
            JOptionPane.showMessageDialog(this, "Bạn chưa thêm món nào.");
            return false;
        }

        return submitOrderItems(ban.maHD, modelTam);
    }

    private JList<MonAn> buildMonList(List<MonAn> dsMon) {
        DefaultListModel<MonAn> listModel = new DefaultListModel<>();
        dsMon.forEach(listModel::addElement);

        JList<MonAn> listMon = new JList<>(listModel);
        listMon.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        listMon.setCellRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value,
                    int index, boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                if (value instanceof MonAn m) {
                    setText(m.getTenMon() + " - " + formatTien((long) m.getGiaMon()) + " đ");
                }
                return this;
            }
        });
        return listMon;
    }

    private DefaultTableModel buildOrderTableModel() {
        return new DefaultTableModel(
                new String[]{"Mã món", "Tên món", "SL", "Đơn giá", "Ghi chú"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return column == 2 || column == 4;
            }
        };
    }

    private JTable buildOrderTable(DefaultTableModel modelTam) {
        JTable tblTam = new JTable(modelTam);
        tblTam.setRowHeight(28);
        tblTam.getColumnModel().getColumn(0).setMinWidth(0);
        tblTam.getColumnModel().getColumn(0).setMaxWidth(0);
        tblTam.getColumnModel().getColumn(0).setWidth(0);
        return tblTam;
    }

    private JSplitPane buildThemMonSplitPane(JList<MonAn> listMon, JTable tblTam,
            JSpinner spSoLuong, JTextField txtGhiChu,
            JButton btnThemVaoDS, JButton btnXoaDong) {

        JPanel leftPanel = new JPanel(new BorderLayout(0, 8));
        leftPanel.add(new JLabel("Danh sách món"), BorderLayout.NORTH);
        leftPanel.add(new JScrollPane(listMon), BorderLayout.CENTER);

        JPanel addBox = new JPanel(new GridLayout(0, 1, 6, 6));
        addBox.add(new JLabel("Số lượng:"));
        addBox.add(spSoLuong);
        addBox.add(new JLabel("Ghi chú:"));
        addBox.add(txtGhiChu);
        addBox.add(btnThemVaoDS);
        leftPanel.add(addBox, BorderLayout.SOUTH);

        JPanel rightPanel = new JPanel(new BorderLayout(0, 8));
        rightPanel.add(new JLabel("Món sẽ thêm vào bàn"), BorderLayout.NORTH);
        rightPanel.add(new JScrollPane(tblTam), BorderLayout.CENTER);
        rightPanel.add(btnXoaDong, BorderLayout.SOUTH);

        JSplitPane split = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, leftPanel, rightPanel);
        split.setDividerLocation(320);
        split.setResizeWeight(0.45);
        return split;
    }

    private void themMonVaoDanhSach(JList<MonAn> listMon, DefaultTableModel modelTam,
            JSpinner spSoLuong, JTextField txtGhiChu) {
        MonAn mon = listMon.getSelectedValue();
        if (mon == null) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn món.");
            return;
        }

        int soLuong = (int) spSoLuong.getValue();
        String ghiChu = txtGhiChu.getText().trim();

        for (int i = 0; i < modelTam.getRowCount(); i++) {
            String maMon   = modelTam.getValueAt(i, 0).toString();
            String ghiCuCu = modelTam.getValueAt(i, 4) == null ? "" : modelTam.getValueAt(i, 4).toString();

            if (maMon.equals(mon.getMaMonAn()) && ghiCuCu.equals(ghiChu)) {
                int slCu = Integer.parseInt(modelTam.getValueAt(i, 2).toString());
                modelTam.setValueAt(slCu + soLuong, i, 2);
                spSoLuong.setValue(1);
                txtGhiChu.setText("");
                return;
            }
        }

        modelTam.addRow(new Object[]{mon.getMaMonAn(), mon.getTenMon(), soLuong, (long) mon.getGiaMon(), ghiChu});
        spSoLuong.setValue(1);
        txtGhiChu.setText("");
    }

    private boolean submitOrderItems(String maHD, DefaultTableModel modelTam) {
        for (int i = 0; i < modelTam.getRowCount(); i++) {
            String maMonAn = modelTam.getValueAt(i, 0).toString();
            int soLuong    = Integer.parseInt(modelTam.getValueAt(i, 2).toString());
            String ghiChu  = modelTam.getValueAt(i, 4) == null ? "" : modelTam.getValueAt(i, 4).toString();

            boolean ok = phucVuService.themHoacTangMon(maHD, maMonAn, soLuong, ghiChu);
            if (!ok) {
                JOptionPane.showMessageDialog(this, "Có lỗi khi thêm món vào hóa đơn!");
                return false;
            }
        }
        return true;
    }

    private void xuLyThanhToan(BanAnModel ban) {
        int confirm = JOptionPane.showConfirmDialog(this,
                "Xác nhận gửi yêu cầu thanh toán cho " + ban.tenBan + "?",
                "Xác nhận", JOptionPane.YES_NO_OPTION);

        if (confirm == JOptionPane.YES_OPTION) {
            boolean thanhCong = phucVuService.yeuCauThanhToan(ban.maHD, ban.maBan);
            if (thanhCong) {
                JOptionPane.showMessageDialog(this, "Đã gửi yêu cầu thanh toán!");
                taiDanhSachBan();             
                SwingUtilities.invokeLater(() -> {
                    if (banDangChon != null) {
                        hienThiChiTietBan(banDangChon);
                    }
                });
            }
        }
    }

    private static String formatTien(long so) {
        return NumberFormat.getInstance(new Locale("vi", "VN")).format(so);
    }

 
}