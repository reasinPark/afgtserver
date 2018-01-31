package com.wingsinus.ep;

//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
import java.sql.*;


//DB연결을 담당하는 클래스입니다.
public class ConnectionProvider {
	
	public static Connection getConnection(String dbname) throws SQLException {
		 try {
             Class.forName("com.mysql.jdbc.Driver");
             System.out.println("드라이버 로딩");
	     } catch(ClassNotFoundException e) {
	         System.out.println("드라이버 로딩 실패!");
	     }
		
		Connection conn = null;		

		String DB_URL = "jdbc:mysql://localhost:3306/"+dbname;
		//이곳에서 바꾸면 됩니다.
//		String DB_URL = "jdbc:mysql://localhost:3306/textIsland?" +
//					"useUnicode=true&characterEncoding=utf8";
		//String dbUser = "wings00";
		//String dbPass = "wingstudio00";	
		String dbUser = "wings";
		String dbPass = "WingS00!";
		conn = DriverManager.getConnection(DB_URL, dbUser, dbPass);
			
		return conn;
	    
	}
}
