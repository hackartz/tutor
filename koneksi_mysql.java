/*
* To change this template, choose Tools | Templates
* and open the template in the editor.
*/
package koneksi;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
/**
*
* @author phantom
*/
public class Koneksi {
 
  /**
  * @param args the command line arguments
  */
  public static void main(String[] args) throws ClassNotFoundException {
  // TODO code application logic here
    Connection conn = null;
    String driver = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/db_koneksi"; // sesuaikan dengan nama database anda
    String user = "root"; // user mysql anda
    String pass = ""; // passowrd mysql
    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url,user,pass);
        System.out.println("Koneksi Berhasil");
    } catch (SQLException e) {
      System.out.println("SQLException: "+e.getMessage());
      System.out.println("SQLState: "+e.getSQLState());
      System.out.println("VendorError: "+e.getErrorCode());
    }
  }
}
