package BLL;

import DataAccess.OrderDAO;
import Model.Order;
/**
 * This class is used for calling the methods from DataAcess classes(OrderDAO).
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class OrderBLL {
    private OrderDAO OD;
    public OrderBLL(){
        OD = new OrderDAO();
    }

    public void makeOrder(Order order){
        OD.makeOrder(order);
    }
}
