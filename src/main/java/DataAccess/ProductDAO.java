package DataAccess;
import Connection.ConnectionFactory;
import Model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
/**
 * In this class are implemented CRUD operations for the table 'products'.
 * It also extends the AbstractDAO class.
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class ProductDAO extends AbstractDAO<Product>{
    protected static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());
    public ProductDAO(){
        super("products");
    }

    public void update(Product product){
        String s = "UPDATE products SET name = ?, stock = ?, price = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet rs = null;
        try  {
            conn = ConnectionFactory.getConnection();
            statement = conn.prepareStatement(s);
            statement.setString(1, product.getName());
            statement.setInt(2,product.getStock());
            statement.setInt(3,product.getPrice());
            statement.setInt(4,product.getId());

            statement.executeUpdate();
            System.out.println("Update succesfull");
        } catch (SQLException e){
            LOGGER.severe("ERROR executing SQL query: " + e.getMessage());
        } finally{
            ConnectionFactory.close(rs);
            ConnectionFactory.close(statement);
            ConnectionFactory.close(conn);
        }
    }

    public void delete(Product product){
        String s = "DELETE FROM products WHERE id = ?";
        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet rs = null;
        try {
            conn = ConnectionFactory.getConnection();
            statement = conn.prepareStatement(s);
            statement.setInt(1,product.getId());
            statement.executeUpdate();
            System.out.println("Delete succesfull");
        } catch (SQLException e){
            LOGGER.severe("ERROR executing SQL query: " + e.getMessage());
        } finally{
            ConnectionFactory.close(rs);
            ConnectionFactory.close(statement);
            ConnectionFactory.close(conn);
        }
    }

    public void insert(Product product){
        String s = "INSERT INTO products (id,name,stock,price) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet rs = null;
        try{
            conn = ConnectionFactory.getConnection();
            statement = conn.prepareStatement(s);

            statement.setInt(1,product.getId());
            statement.setString(2,product.getName());
            statement.setInt(3,product.getStock());
            statement.setInt(4,product.getPrice());

            statement.executeUpdate();
            System.out.println("Insertion succesfull");
        } catch (SQLException e){
            LOGGER.severe("ERROR executing SQL query: " + e.getMessage());
        } finally{
            ConnectionFactory.close(rs);
            ConnectionFactory.close(statement);
            ConnectionFactory.close(conn);
        }
    }

}
