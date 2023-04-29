package BusinessLogic;
import Model.Server;
import Model.Client;

import java.util.ArrayList;
import java.util.List;
//import Strategy.Strategy;
//import Strategy.SelectionPolicy;
//import Strategy.ConcreteStrategyTime;
//import Strategy.ConcreteStrategyQueue;
public class Scheduler {
    private List<Server> servers;
    private int maxNoServers;
    private int maxClientsPerServer;
    private Strategy strategy;

    //DONE
    public Scheduler(int maxNoServers){
        //for maxNoServers
        // - create server object
        //  - create thread with the object
        strategy = new Strategy();
        this.maxNoServers = maxNoServers;
        this.servers = new ArrayList<>();
        for(int i = 0; i < maxNoServers; i++){
            Server s = new Server();
            Thread t = new Thread(s);
            t.start();
            servers.add(s);
        }
    }

    //DONE
    public void dispatchClientToServer(Client t){
        //call the strategy addTask method
        strategy.addTask(servers,t);
    }

    //DONE
    public List<Server> getServers(){
        return servers;
    }

}

