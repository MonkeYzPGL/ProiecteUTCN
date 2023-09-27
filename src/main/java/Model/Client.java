package Model;
/**
 *This class represents a row from the table clients, an object;
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class Client {
    private int id;
    private String name;
    private String email;
    private int age;
    public Client() {}
    public Client(int id, String name, String email, int age){
        this.id = id;
        this.name = name;
        this.email = email;
        this.age = age;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public int getAge() {
        return age;
    }

    public String toString(){
        return this.id + "  |  " + this.name + "   |" +  this.email +"    |  " + this.age;
    }

}
