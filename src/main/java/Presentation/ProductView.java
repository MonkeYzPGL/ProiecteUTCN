package Presentation;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

import BLL.ProductBLL;
import Model.Client;
import Model.Product;
import DataAccess.ProductDAO;

/**
 *This class is a GUI for manipulating operations for table 'products'.
 * It also shows the table's content live.
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class ProductView {
    private JFrame frame = new JFrame("Products Management");

    private JPanel panel = new JPanel();
    private JTextField textField1 = new JTextField();
    private JTextField textField2 = new JTextField();
    private JTextField textField3 = new JTextField();
    private JTextField textField4 = new JTextField();
    private JLabel label1 = new JLabel();
    private JLabel label2 = new JLabel();
    private JLabel label3 = new JLabel();
    private JLabel label4 = new JLabel();
    private JButton buton1 = new JButton();
    private JButton buton2 = new JButton();
    private JButton buton3 = new JButton();
    private JButton buton4 = new JButton();
    private DefaultTableModel model = new DefaultTableModel();
    private JTable table = new JTable(model);
    private JScrollPane scrollPane = new JScrollPane(table);
    private List<Product> products;
    private ProductBLL PL = new ProductBLL();
    public ProductView(){
        frame.setSize(600,600);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocation(940,0);

        frame.getContentPane().add(panel, BorderLayout.CENTER);
        panel.setBackground(new Color(233,116,81));
        panel.setLayout(null);

        textFields();
        labels();
        buttons();
        table();
        frame.setVisible(true);
        frame.setResizable(false);
    }


    public void textFields(){
        textField1.setBounds(120,40,70,30);
        textField1.setFont(new Font("times new roman", Font.ITALIC,20));
        textField1.setBackground(new Color(211,211,211));
        panel.add(textField1);

        textField2.setBounds(120,80,120,30);
        textField2.setFont(new Font("times new roman", Font.ITALIC,20));
        textField2.setBackground(new Color(211,211,211));
        panel.add(textField2);

        textField3.setBounds(120,120,150,30);
        textField3.setFont(new Font("times new roman", Font.ITALIC,20));
        textField3.setBackground(new Color(211,211,211));
        panel.add(textField3);

        textField4.setBounds(120,160,70,30);
        textField4.setFont(new Font("times new roman", Font.ITALIC,20));
        textField4.setBackground(new Color(211,211,211));
        panel.add(textField4);
    }

    public void table(){
        model.addColumn("ID");
        model.addColumn("Name");
        model.addColumn("Stock");
        model.addColumn("Price");

        this.products = PL.getAll();

        for(Product x : products){
            Object[] row = {x.getId(), x.getName(), x.getStock(), x.getPrice()};
            model.addRow(row);
        }

        scrollPane.setBounds(45,200,500,300);
        panel.add(scrollPane);
    }

    public void modificare(){
        this.products = PL.getAll();
        model.setRowCount(0);

        for (Product x : products) {
            Object[] row = {x.getId(), x.getName(), x.getStock(), x.getPrice()};
            model.addRow(row);
        }
    }
    public void labels(){
        label1.setText("ID:");
        label1.setFont(new Font("times new roman", Font.ITALIC,25));
        label1.setBackground(new Color(233,116,81));
        label1.setBounds(25,40,60,30);
        panel.add(label1);

        label2.setText("NAME:");
        label2.setFont(new Font("times new roman", Font.ITALIC,25));
        label2.setBackground(new Color(233,116,81));
        label2.setBounds(25,80,90,30);
        panel.add(label2);

        label3.setText("STOCK:");
        label3.setFont(new Font("times new roman", Font.ITALIC,25));
        label3.setBackground(new Color(233,116,81));
        label3.setBounds(25,120,90,30);
        panel.add(label3);

        label4.setText("PRICE:");
        label4.setFont(new Font("times new roman", Font.ITALIC,25));
        label4.setBackground(new Color(233,116,81));
        label4.setBounds(25,160,90,30);
        panel.add(label4);
    }

    public void buttons(){

        buton2.setText("ADD product");
        buton2.setBounds(320,80,150,25);
        buton2.setFont(new Font("times new roman",Font.ITALIC,20));
        buton2.addActionListener(e -> {
            int id;
            String name;
            int stock;
            int price;
            String aux = textField1.getText();
            id = Integer.parseInt(aux);
            name = textField2.getText();
            aux = textField3.getText();
            stock = Integer.parseInt(aux);
            aux = textField4.getText();
            price = Integer.parseInt(aux);
            Product product = new Product(id,name,stock,price);
            PL.insert(product);
            modificare();
        });
        panel.add(buton2);

        buton3.setText("EDIT product");
        buton3.setBounds(320,120,150,25);
        buton3.setFont(new Font("times new roman",Font.ITALIC,20));
        buton3.addActionListener(e -> {
            int id;
            String name;
            int stock;
            int price;
            String aux = textField1.getText();
            id = Integer.parseInt(aux);
            name = textField2.getText();
            aux = textField3.getText();
            stock = Integer.parseInt(aux);
            aux = textField4.getText();
            price = Integer.parseInt(aux);
            Product product = new Product(id,name,stock,price);
            PL.update(product);
            modificare();
        });
        panel.add(buton3);

        buton4.setText("DELETE product");
        buton4.setBounds(320,160,180,25);
        buton4.setFont(new Font("times new roman",Font.ITALIC,20));
        buton4.addActionListener(e -> {
            int id;
            String name;
            int stock;
            int price;
            String aux = textField1.getText();
            id = Integer.parseInt(aux);
            name = textField2.getText();
            aux = textField3.getText();
            stock = Integer.parseInt(aux);
            aux = textField4.getText();
            price = Integer.parseInt(aux);
            Product product = new Product(id,name,stock,price);
            PL.delete(product);
            modificare();
        });
        panel.add(buton4);
    }
}

