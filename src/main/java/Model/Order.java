package Model;
/**
 *This class represents a row from the table orders, an object;
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class Order {
    public int id;
    public int idProduct;
    public int idClient;
    public int nr;
    public int price;

    public Order(int id, int idProduct, int idClient, int nr) {
        this.id = id;
        this.idProduct = idProduct;
        this.idClient = idClient;
        this.nr = nr;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setIdProduct(int idProduct) {
        this.idProduct = idProduct;
    }

    public void setIdClient(int idClient) {
        this.idClient = idClient;
    }

    public void setNr(int nr) {
        this.nr = nr;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public int getIdProduct() {
        return idProduct;
    }

    public int getIdClient() {
        return idClient;
    }

    public int getNr() {
        return nr;
    }

    public int getPrice() {
        return price;
    }
}
