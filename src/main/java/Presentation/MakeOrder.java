package Presentation;

import BLL.OrderBLL;
import Model.Order;

import javax.swing.*;
import java.awt.*;
/**
 *This class is a GUI interface, and it's used to create an order.
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class MakeOrder {
    private JFrame frame = new JFrame("Make Orders");
    private JPanel panel = new JPanel();
    private JButton exit = new JButton();
    private JButton create = new JButton();
    private JLabel label1 = new JLabel();
    private JLabel label2 = new JLabel();
    private JLabel label3 = new JLabel();
    private JLabel label4 = new JLabel();
    private JTextField textField1 = new JTextField();
    private JTextField textField2 = new JTextField();
    private JTextField textField3 = new JTextField();
    private JTextField textField4 = new JTextField();
    private ProductView PV;
    private OrderBLL OD;
    public MakeOrder(){
        PV = new ProductView();
        new ClientView();

        frame.setSize(500,500);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocation(530,200);

        frame.getContentPane().add(panel, BorderLayout.CENTER);
        panel.setBackground(new Color(233,116,81));
        panel.setLayout(null);

        labels();
        textFields();
        buttons();
        frame.setVisible(true);
        frame.setResizable(false);

        this.OD = new OrderBLL();
    }

    public void buttons(){
        exit.setText("EXIT");
        exit.setBounds(30,420,80,25);
        exit.setFont(new Font("times new roman", Font.ITALIC,20));
        exit.addActionListener(e ->{
            System.exit(0);
        });
        panel.add(exit);

        create.setText("Add order");
        create.setBounds(150,200,150,25);
        create.setFont(new Font("times new roman", Font.ITALIC,20));
        create.addActionListener(e ->{
            String s;
            s = textField1.getText();
            int id = Integer.parseInt(s);
            s = textField2.getText();
            int idProdus = Integer.parseInt(s);
            s = textField3.getText();
            int idClient = Integer.parseInt(s);
            s = textField4.getText();
            int pieces = Integer.parseInt(s);
            Order order = new Order(id,idProdus,idClient,pieces);
            OD.makeOrder(order);
            PV.modificare();
        });
        panel.add(create);
    }

    public void textFields(){
        textField1.setBounds(120,40,60,30);
        textField1.setFont(new Font("times new roman", Font.ITALIC,20));
        textField1.setBackground(new Color(211,211,211));
        panel.add(textField1);

        textField2.setBounds(120,80,60,30);
        textField2.setFont(new Font("times new roman", Font.ITALIC,20));
        textField2.setBackground(new Color(211,211,211));
        panel.add(textField2);

        textField3.setBounds(120,120,60,30);
        textField3.setFont(new Font("times new roman", Font.ITALIC,20));
        textField3.setBackground(new Color(211,211,211));
        panel.add(textField3);

        textField4.setBounds(120,160,60,30);
        textField4.setFont(new Font("times new roman", Font.ITALIC,20));
        textField4.setBackground(new Color(211,211,211));
        panel.add(textField4);
    }

    public void labels(){
        label1.setText("ID:");
        label1.setFont(new Font("times new roman", Font.ITALIC,25));
        label1.setBackground(new Color(233,116,81));
        label1.setBounds(25,40,60,30);
        panel.add(label1);

        label2.setText("Product:");
        label2.setFont(new Font("times new roman", Font.ITALIC,25));
        label2.setBackground(new Color(233,116,81));
        label2.setBounds(25,80,90,30);
        panel.add(label2);

        label3.setText("Client:");
        label3.setFont(new Font("times new roman", Font.ITALIC,25));
        label3.setBackground(new Color(233,116,81));
        label3.setBounds(25,120,90,30);
        panel.add(label3);

        label4.setText("Pieces:");
        label4.setFont(new Font("times new roman", Font.ITALIC,25));
        label4.setBackground(new Color(233,116,81));
        label4.setBounds(25,160,90,30);
        panel.add(label4);
    }
}
