package Connection;

import java.sql.*;
import java.util.logging.Logger;

/**
 * This class is for making connection with the database in WorkBench
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class ConnectionFactory {
    private static final Logger LOGGER = Logger.getLogger(ConnectionFactory.class.getName());
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DBURL = "jdbc:mysql://localhost/tema3pt";
    private static final String USER = "root";
    private static final String PASS = "sergiu19A@";

    private static ConnectionFactory singleInstance = new ConnectionFactory();

    private ConnectionFactory(){
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection createConnection(){
            Connection connection = null;
            try{
                connection = DriverManager.getConnection(DBURL, USER, PASS);
            } catch (SQLException e) {
               LOGGER.severe("Error al creating connection to database" + e.getMessage());
            }
            return connection;
    }

    public static Connection getConnection(){
            return singleInstance.createConnection();
    }

    public static void close(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.severe("Error at closing connection to database " + e.getMessage());
            }
        }
    }
    public static void close(Statement statement){
            if(statement != null){
                try{
                    statement.close();
                } catch(SQLException e){
                    LOGGER.severe("Error at closing statement" + e.getMessage());
                }
            }
    }

    public static void close(ResultSet resultSet){
            if(resultSet != null){
                try{
                    resultSet.close();
                } catch(SQLException e){
                    LOGGER.severe("Error at closing the result" + e.getMessage());
                }
            }
    }
}
