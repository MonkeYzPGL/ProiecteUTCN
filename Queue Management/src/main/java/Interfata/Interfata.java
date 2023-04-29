package Interfata;
import BusinessLogic.SimulationManager;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class Interfata{
    JFrame frame = new JFrame("Gestionarea coziilor");
    JPanel panel = new JPanel();

    //labels
    JLabel titlu = new JLabel();
    JLabel people = new JLabel();
    JLabel queues = new JLabel();
    JLabel time = new JLabel();
    JLabel minArrival = new JLabel();
    JLabel maxArrival = new JLabel();
    JLabel minService = new JLabel();
    JLabel maxService = new JLabel();
    JLabel textOne = new JLabel();
    JLabel textTwo = new JLabel();
    JLabel nume = new JLabel();
    JLabel grupa = new JLabel();

    //textFields
    JTextField one = new JTextField(); //clienti
    JTextField two = new JTextField(); //queues
    JTextField three = new JTextField(); //simulation time
    JTextField four = new JTextField(); //minim arrival time
    JTextField five = new JTextField(); //maxim arrival time
    JTextField six = new JTextField(); //minim service time
    JTextField seven = new JTextField(); //maxim service time

    //butoane
    JButton close = new JButton(); //buton de reset
    JButton run = new JButton(); //buton de rulare a programului

    //text areas
    JTextArea output = new JTextArea(); //zona pentru output
    JTextArea input = new JTextArea(); //zona pentru input
    public void labels(){
        titlu.setBounds(225,25,410,80);
        titlu.setText("Gestionarea coziilor");
        titlu.setBackground(new Color(233,116,81));
        titlu.setFont(new Font("times new roman", Font.ITALIC,40));

        people.setBounds(50,120,150,25);
        people.setText("Customers:");
        people.setFont(new Font("times new roman",Font.ITALIC,25));

        queues.setBounds(50,150,100,25);
        queues.setText("Queues:");
        queues.setFont(new Font("times new roman",Font.ITALIC,25));

        time.setBounds(50,180,220,25);
        time.setText("Simulation time:");
        time.setFont(new Font("times new roman", Font.ITALIC,25));

        minArrival.setBounds(450,120,150,25);
        minArrival.setText("Min arrival:");
        minArrival.setFont(new Font("times new roman",Font.ITALIC,25));

        maxArrival.setBounds(450,150,150,25);
        maxArrival.setText("Max arrival:");
        maxArrival.setFont(new Font("times new roman", Font.ITALIC,25));

        minService.setBounds(450,180,150,25);
        minService.setText("Min service:");
        minService.setFont(new Font("times new roman", Font.ITALIC,25));

        maxService.setBounds(450,210,150,25);
        maxService.setText("Max service:");
        maxService.setFont(new Font("times new roman", Font.ITALIC,25));

        /*textOne.setBounds(50,290,150,25);
        textOne.setText("Output:");
        textOne.setFont(new Font("times new roman", Font.ITALIC,25));

        textTwo.setBounds(450,290,150,25);
        textTwo.setText("Your input:");
        textTwo.setFont(new Font("times new roman", Font.ITALIC,25));*/

        nume.setBounds(600,700,200,30);
        nume.setText("Elecfi Sergiu-Andrei");
        nume.setFont(new Font("times new roman", Font.ITALIC,20));

        grupa.setBounds(600,730,200,30);
        grupa.setText("Grupa 30223");
        grupa.setFont(new Font("times new roman", Font.ITALIC,20));

        panel.add(maxArrival);
        panel.add(maxService);
        panel.add(minArrival);
        panel.add(minService);
        panel.add(time);
        panel.add(people);
        panel.add(queues);
        panel.add(titlu);
        panel.add(textOne);
        panel.add(textTwo);
        panel.add(nume);
        panel.add(grupa);
    }

    public void textFields(){
        one.setBounds(167,120,150,25);
        one.setBackground(new Color(173, 216, 230, 255));
        one.setFont(new Font("times new roman",Font.ITALIC,20));

        two.setBounds(135,150,150,25);
        two.setBackground(new Color(173, 216, 230, 255));
        two.setFont(new Font("times new roman",Font.ITALIC,20));

        three.setBounds(218,180,150,25);
        three.setBackground(new Color(173, 216, 230, 255));
        three.setFont(new Font("times new roman",Font.ITALIC,20));

        four.setBounds(576,120,150,25);
        four.setBackground(new Color(173, 216, 230, 255));
        four.setFont(new Font("times new roman",Font.ITALIC,20));

        five.setBounds(580,150,150,25);
        five.setBackground(new Color(173, 216, 230, 255));
        five.setFont(new Font("times new roman",Font.ITALIC,20));

        six.setBounds(576,180,150,25);
        six.setBackground(new Color(173, 216, 230, 255));
        six.setFont(new Font("times new roman",Font.ITALIC,20));

        seven.setBounds(580,210,150,25);
        seven.setBackground(new Color(173, 216, 230, 255));
        seven.setFont(new Font("times new roman",Font.ITALIC,20));

        panel.add(one);
        panel.add(two);
        panel.add(three);
        panel.add(four);
        panel.add(five);
        panel.add(six);
        panel.add(seven);
    }

    public void buttons(){
        run.setBounds(300,250,80,25);
        run.setText("run");
        run.setFont(new Font("times new roman",Font.ITALIC,20));
        run.addActionListener(e -> {
            frame.dispose();
            int clienti = Integer.parseInt(one.getText());
            int cozi = Integer.parseInt(two.getText());
            int simulationTime = Integer.parseInt(three.getText());
            int minArrival = Integer.parseInt(four.getText());
            int maxArrival = Integer.parseInt((five.getText()));
            int minService = Integer.parseInt(six.getText());
            int maxService = Integer.parseInt(seven.getText());
            SimulationManager gen = new SimulationManager(simulationTime,maxService,minService,clienti,cozi,minArrival,maxArrival);
            Thread t = new Thread(gen);
            t.start();
        });

       /* reset.setBounds(390,250,80,25);
        reset.setText("reset");
        reset.setFont(new Font("times new roman",Font.ITALIC,20));
        reset.addActionListener(e -> {
            frame.dispose();
            new Interfata();
        });*/

        close.setText("exit");
        close.setFont(new Font("times new roman",Font.ITALIC,20));
        close.setBackground(Color.RED);
        close.setForeground(Color.WHITE);
        close.setBounds(50,730,80,25);
        close.addActionListener(e ->{
            System.exit(0);
        });

        panel.add(close);
        panel.add(run);
        //panel.add(reset);
    }

    public void textAreas(){
        output.setBounds(50,330,350,300);
        output.setBackground(Color.WHITE);
        output.setText("Aici va aparea outputul problemei");
        output.setFont(new Font("calibri",Font.ITALIC,20));

        input.setBounds(450,330,200,300);
        input.setBackground(Color.WHITE);
        input.setText("Acesta este inputul dat: \n");
        input.setFont(new Font("calibri",Font.ITALIC,20));

        panel.add(output);
        panel.add(input);
    }

    public Interfata(){
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800,800);

        frame.getContentPane().add(panel,BorderLayout.CENTER);
        panel.setBackground(new Color(233,116,81));
        panel.setLayout(null);

        labels();
        textFields();
        buttons();
        //textAreas();
        frame.add(panel);
        frame.setResizable(false);
        frame.setVisible(true);
    }


}
