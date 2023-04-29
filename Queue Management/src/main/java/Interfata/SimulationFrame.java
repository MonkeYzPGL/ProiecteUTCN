package Interfata;

import javax.swing.*;
import java.awt.*;

public class SimulationFrame {
    JFrame frameA = new JFrame("Simulation Frame");
    JTextArea textArea = new JTextArea();
    JTextArea textArea1 = new JTextArea();
    JScrollPane scrollPane = new JScrollPane(textArea);
    JScrollPane scrollPane1 = new JScrollPane(textArea1);
    JLabel label = new JLabel();
    JLabel nume = new JLabel();
    JLabel grupa = new JLabel();
    JPanel panel = new JPanel();
    JButton back = new JButton();
    JTextField coada = new JTextField();

    public SimulationFrame(){
        frameA.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frameA.setSize(800,800);

        frameA.getContentPane().add(panel, BorderLayout.CENTER);
        panel.setBackground(new Color(233,116,81));
        panel.setLayout(null);

        nume.setBounds(600,700,200,30);
        nume.setText("Elecfi Sergiu-Andrei");
        nume.setFont(new Font("times new roman", Font.ITALIC,20));

        grupa.setBounds(600,730,200,30);
        grupa.setText("Grupa 30223");
        grupa.setFont(new Font("times new roman", Font.ITALIC,20));

        panel.add(nume);
        panel.add(grupa);

        back.setText("back");
        back.setFont(new Font("times new roman",Font.ITALIC,25));
        back.setBounds(50,730,100,30);
        back.addActionListener(e ->{
            frameA.dispose();
            new Interfata();
        });
        panel.add(back);

        label.setText("Simularea bazata pe datele de intrare");
        label.setFont(new Font("times new roman", Font.ITALIC,35));
        label.setBounds(140,30,590,40);
        panel.add(label);

        scrollPane.setBounds(50,300,700,350);
        panel.add(scrollPane);

        scrollPane1.setBounds(50,100,700,190);
        panel.add(scrollPane1);

        coada.setBounds(50,660,700,40);
        panel.add(coada);

        frameA.add(panel);
        frameA.setResizable(false);
        frameA.setVisible(true);
    }

    public void setareText(String a, String b){
        coada.setText(a);
        textArea.append(b);
        if(b == "")
        {
            textArea1.setText("");
        }else{
            textArea1.setText(b);
        }
    }
}

