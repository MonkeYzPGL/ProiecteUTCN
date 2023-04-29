package Model;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.atomic.AtomicInteger;

public class Server implements Runnable{

    private BlockingQueue<Client> clienti;
    private AtomicInteger waitingPeriod;
    public Server(){
        //initializare coada si timpul de asteptare
        clienti = new LinkedBlockingDeque<Client>();
        waitingPeriod = new AtomicInteger(0);

    }
    public void addClient(Client newClient){
        //adaugare client la coada
        clienti.add(newClient);
        //se incrementeaza timpul de asteptare
        waitingPeriod.getAndAdd(newClient.getServiceTime());
    }
    //DONE
    @Override
    public void run() {
        while(true){
            try {
                Client client = null;
                //se ia urm. client din coada
                if (!clienti.isEmpty()) {
                    client = clienti.peek();
                    //se pune thread-ul pe sleep pentru a simula procesarea clientului
                    Thread.sleep(1000);
                    //se decrementeaza perioada de asteptare a serverului
                    waitingPeriod.getAndAdd(-client.getServiceTime());
                    client.setServiceTime(client.getServiceTime() - 1);
                    if(client.getServiceTime() == 0){
                        clienti.remove(client);
                    }
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    public int getWaitingPeriod(){
        return this.waitingPeriod.intValue();
    }
    public String toString(){
        String x = "";
        for(Client aux : clienti){
            x += aux.toString() + " ";
        }
        return x;
    }
    public BlockingQueue<Client> getClienti(){
        return clienti;
    }
    public Integer getQueueSize(){
        return this.clienti.size();
    }
}

