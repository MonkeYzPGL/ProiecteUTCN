package Model;
/**
 *This class represents a row from the table products, an object;
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class Product {
    private int id;
    private String name;
    private int stock;
    private int price;

    public Product(int id, String name, int stock, int price){
        this.id = id;
        this.name = name;
        this.stock = stock;
        this.price = price;
    }
    public Product() {
        // constructor implicit, fără parametri
    }
    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getStock() {
        return stock;
    }

    public int getPrice() {
        return price;
    }

    public String toString(){
        return this.getId() + "   |" + this.getName() + "  |" + this.getStock() + "  |" + this.getPrice() + "   ";
    }
}
