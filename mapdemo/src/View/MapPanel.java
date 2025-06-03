/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package View;

import javax.swing.*;
import java.awt.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class MapPanel extends JPanel {
    private Image backgroundImage;
    private final List<JButton> buttons = new ArrayList<>();
    private final Icon boatIcon;

    public MapPanel() {
        // Load ảnh nền
        URL bgUrl = getClass().getResource("/View/mapreal.png");
        if (bgUrl != null) {
            backgroundImage = new ImageIcon(bgUrl).getImage();
        }

        // Load icon tàu
        URL iconUrl = getClass().getResource("/View/boat24.png");
        if (iconUrl != null) {
            boatIcon = new ImageIcon(iconUrl);
        } else {
            boatIcon = UIManager.getIcon("OptionPane.errorIcon"); // fallback
        }

        // dùng layout null để định vị tuyệt đối
        setLayout(null);
    }

    public void addBoatButton(int x, int y) {
        JButton btn = new JButton();
        btn.setIcon(boatIcon);
        btn.setText(null);
        btn.setBorderPainted(false);
        btn.setContentAreaFilled(false);
        // căn giữa icon lên (x,y)
        int w = boatIcon.getIconWidth();
        int h = boatIcon.getIconHeight();
        btn.setBounds(x - w/2, y - h/2, w, h);

        btn.addActionListener(e ->
            System.out.printf("Clicked boat at (%d,%d)%n", x, y)
        );

        buttons.add(btn);
        add(btn);
        repaint();
    }

    @Override
    public Dimension getPreferredSize() {
        if (backgroundImage != null) {
            return new Dimension(
                backgroundImage.getWidth(null),
                backgroundImage.getHeight(null)
            );
        }
        return super.getPreferredSize();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        // vẽ nền
        if (backgroundImage != null) {
            g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);
        } else {
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, getWidth(), getHeight());
        }
        // nút tự vẽ, không cần vẽ thêm ở đây
    }
}

