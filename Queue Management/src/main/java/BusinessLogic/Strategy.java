package BusinessLogic;

import Model.Client;
import Model.Server;

import java.util.List;

public class Strategy {

    //DONE
    public void addTask(List<Server> servers, Client t){
        Server aux = null;
        int shortest = 99999;

        //Parcurg lista de servere si caut serverul cu timpul mediu de asteptare minim
        for(Server x : servers) {
            int queueLength = x.getQueueSize();
            if(queueLength < shortest) {
                aux = x;
                shortest= queueLength;
            }
        }
        if(aux != null){
            //adaug clientul in coada respectiv
            aux.addClient(t);
        }
    }
}
