package BusinessLogic;
//import Strategy.SelectionPolicy;
import Model.Client;
import Interfata.SimulationFrame;
import Model.Server;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.BlockingQueue;

public class SimulationManager implements Runnable{

    public int timeLimit;
    public int maxProcessingTime;
    public int minArrivalTime;
    public int maxArrivalTime;
    public int minProcessingTime;
    public int numberOfServers;
    public int numberOfClients;
    //entity responsible with queue management and clients distribution
    private Scheduler Scheduler;
    //frane for displaying simulation
    private SimulationFrame frame;
    //pool of clients
    private ArrayList<Client> generatedClients;

    //DONE
    public SimulationManager(int timeLimit, int maxProcessingTime, int minProcessingTime, int numberOfClients, int numberOfServers, int minArrivalTime, int maxArrivalTime){
        this.timeLimit = timeLimit;
        this.maxProcessingTime = maxProcessingTime;
        this.minProcessingTime = minProcessingTime;
        this.numberOfClients = numberOfClients;
        this.numberOfServers = numberOfServers;
        this.minArrivalTime = minArrivalTime;
        this.maxArrivalTime = maxArrivalTime;

        //initialize the scheduler
        //     => create and start numberOfServers threads
        //     => initialize selection straategy => create Strategy;
        this.Scheduler = new Scheduler(numberOfServers);
        //initialize frame to display simulation
        frame = new SimulationFrame();
        //generate numberOfClients clients using generateNRandomClients and store them into generatedClients
        generatedClients = new ArrayList<Client>();
        generateNRandomClients();
    }

    //DONE
    public void generateNRandomClients(){
        //generate N random tasks
        for(int i = 1; i <= numberOfClients; i++){
            // - random processing time
            // minProcessingTime < processingTime < max ProcessingTime
            int processingTime = (int) (Math.random() * (maxProcessingTime - minProcessingTime) + minProcessingTime);
            // -random arrivalTime
            int arrivalTime = (int) (Math.random() * (maxArrivalTime - minArrivalTime) + minArrivalTime);
            Client client = new Client(i,processingTime,arrivalTime);
            generatedClients.add(client);
        }
        // sort list with respect to arrivalTime
        Collections.sort(generatedClients);
    }

    public Integer totalServiceTime(){
        int x = 0;
        for(Client aux : generatedClients){
            x = x + aux.getServiceTime();
        }
        return x;
    }

    @Override
    public void run() {
        int currentTime = 0;
        int totalServing = totalServiceTime();
        try {
            FileWriter writer = new FileWriter("teste.txt");
            while(currentTime < timeLimit){
                String beta = "";
                String delta = "";
                frame.setareText("","");
                //iterate generatedClients list and pick clients that have the arrivalTime equal with the currentTime
                List<Client> clients = new ArrayList<Client>();
                for(int i = 0; i < generatedClients.size(); i++){
                    Client client = generatedClients.get(i);
                    if(client.getArrivalTime() == currentTime){
                        clients.add(client);
                    }
                }
                //send task to queue by calling the dispatchTask method from Scheduler
                for(Client client : clients){
                    Scheduler.dispatchClientToServer(client);
                    //   -delete client from list
                    generatedClients.remove(client);
                }
                //afisarea coziilor in timp real
                delta = "Time: " + currentTime + "\n";
                writer.write("Time: " + currentTime + "\n");
                String aux1 = "";
                for(Client x : generatedClients){
                    aux1 = aux1 + x.toString();
                }
                if(aux1 != ""){
                    writer.write(aux1 + "\n");
                    beta = aux1;
                }
                for(int i = 0; i < numberOfServers; i++){
                    Server x = Scheduler.getServers().get(i);
                    int d = i+1;
                    writer.write("Queue" + d + ": ");
                    delta = delta + "Queue" + d + ": ";
                    BlockingQueue<Client> aux = x.getClienti();
                    for(Client alfa : aux){
                        writer.write(alfa.toString());
                        delta = delta + alfa.toString();
                    }
                    writer.write("\n");
                    delta = delta + "\n";
                }
                writer.write("-----------------------------------------------\n");
                delta = delta + "-----------------------------------------------\n";
                //modificare simulationFrame
                frame.setareText(beta,delta);
                beta = null;
                delta = null;
                //verificare daca mai sunt clienti
                int d = 1;
                for(int i = 0; i < numberOfServers; i++){
                    Server x = Scheduler.getServers().get(i);
                    BlockingQueue<Client> aux = x.getClienti();
                    if(!aux.isEmpty()){
                        d = 0;
                    }
                    if(!generatedClients.isEmpty()){
                        d = 0;
                    }
                }
                if(d == 1){
                    currentTime = timeLimit - 1;
                }
                currentTime++;
                //wait an interval of 1 second
                try{
                    Thread.sleep(1000);
                } catch (InterruptedException e){
                    e.printStackTrace();
                }
            }
            writer.write("Average serving time: " + totalServing / numberOfClients);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("FINISHED");
    }
}
