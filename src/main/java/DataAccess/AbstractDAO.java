package DataAccess;
import java.lang.reflect.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.lang.reflect.Constructor;

import Connection.ConnectionFactory;
/**
 * This class is used to return every row from the table in WorkBench.
 * This class uses the reflexion method to get all elements from the table;
 *
 * @author Elecfi Sergiu - Andrei 30223
 * @date 25.05.2023
 */
public class AbstractDAO<T> {
    protected static final Logger LOGGER = Logger.getLogger(AbstractDAO.class.getName());
    private String table;
    public AbstractDAO(String table){
        this.table = table;
    }

    public List<T> getAll(){
        List<T> sir = new ArrayList<>();
        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet rs = null;
        try{
            String s = "SELECT * FROM " + table;
            conn = ConnectionFactory.getConnection();
            statement = conn.prepareStatement(s);
            rs = statement.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int col = meta.getColumnCount();
            while(rs.next()){
                T x = createInstance();
                for(int i = 1; i <= col; i++){
                    String colName = meta.getColumnName(i);
                    Object colValue = rs.getObject(i);
                    setFieldValue(x,colName,colValue);
                }
                sir.add(x);
            }
        } catch(SQLException e){
            LOGGER.severe("ERROR at executing SQL query: " + e.getMessage());
        } finally{
            ConnectionFactory.close(rs);
            ConnectionFactory.close(statement);
            ConnectionFactory.close(conn);
        }
        return sir;
    }

    private T createInstance() {
        try {
            Class<T> cl = getGenericTypeClass();
            Constructor<T> constructor = cl.getDeclaredConstructor();
            constructor.setAccessible(true);
            return constructor.newInstance();
        } catch (Exception e) {
            throw new RuntimeException("Error at creating instance of " + table, e);
        }
    }

    private void setFieldValue(T object, String fieldName, Object fieldV){
        try{
            Class<?> cl = object.getClass();
            Field field = cl.getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(object,fieldV);
        } catch (Exception e){
            throw new RuntimeException("Error at setting field value for " + fieldName, e);
        }
    }

    private Class<T> getGenericTypeClass(){
        try{
            return (Class<T>) ((java.lang.reflect.ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
        } catch (Exception e){
            throw new RuntimeException("Error at getting generic class for ", e);
        }
    }
}
