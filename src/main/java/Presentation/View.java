package Presentation;

import javax.swing.*;
import java.awt.*;
/**
 *This class is used to start the application, or to close it.
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class View {
    private JFrame frame = new JFrame("Orders Management");
    private JPanel panel = new JPanel();
    private JLabel welcome = new JLabel();
    private JLabel titlu = new JLabel();
    private JLabel nume = new JLabel();
    private JLabel grupa = new JLabel();
    private JLabel label1 = new JLabel();
    private JLabel label2 = new JLabel();
    private JButton exit = new JButton();
    private JButton next = new JButton();

    public View(){
        frame.setSize(500,500);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.getContentPane().add(panel, BorderLayout.CENTER);
        panel.setBackground(new Color(233,116,81));
        panel.setLayout(null);

        labels();
        buttons();
        frame.setVisible(true);
        frame.setResizable(false);
    }

    public void labels(){
        nume.setText("Elecfi Sergiu-Andrei");
        nume.setBounds(300,390,180,30);
        nume.setFont(new Font("Times new roman", Font.ITALIC,20));
        panel.add(nume);

        grupa.setText("Grupa:30223");
        grupa.setBounds(330,420,130,30);
        grupa.setFont(new Font("times new roman", Font.ITALIC,20));
        panel.add(grupa);

        titlu.setText("Orders Management");
        titlu.setBounds(100,30,300,40);
        titlu.setFont(new Font("times new roman", Font.ITALIC,35));
        panel.add(titlu);

        welcome.setText("WELCOME!!!");
        welcome.setBounds(130,100,300,40);
        welcome.setFont(new Font("times new roman", Font.ITALIC,35));
        panel.add(welcome);
    }

    public void buttons(){
        exit.setText("EXIT");
        exit.setBounds(30,420,80,25);
        exit.setFont(new Font("times new roman", Font.ITALIC,20));
        exit.addActionListener(e ->{
            System.exit(0);
        });
        panel.add(exit);

        next.setText("Continue");
        next.setBounds(30,260,120,25);
        next.setFont(new Font("times new roman", Font.ITALIC,20));
        next.addActionListener(e -> {
            frame.dispose();
            new MakeOrder();
        });
        panel.add(next);
    }
}
