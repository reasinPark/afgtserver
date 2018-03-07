package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LogManager {
	
	public static boolean writeNorLog(String uid,String action_type, String action_name, String itemname, String pointname, int count) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("insert into log_action (uid,action_type,action_name,item,point,count) values(?,?,?,?,?,?)");
			
			pstmt.setString(1, uid);
			pstmt.setString(2, action_type);
			pstmt.setString(3, action_name);
			pstmt.setString(4, itemname);
			pstmt.setString(5, itemname);
			pstmt.setInt(6, count);
			
			int r = pstmt.executeUpdate();
			if(r == 1){
				return true;
			}else{
				return false;
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public static boolean writeCashLog(String uid, int r_get, int f_get, int r_have,int f_have) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("insert into log_cash (uid,r_getcash,f_getcash,r_havecash,f_havecash) values(?,?,?,?,?)");
			
			pstmt.setString(1, uid);
			pstmt.setInt(2, r_get);
			pstmt.setInt(3, f_get);
			pstmt.setInt(4, r_have);
			pstmt.setInt(5, f_have);
			
			int r = pstmt.executeUpdate();
			if(r == 1){
				return true;
			}else{
				return false;
			}
			
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);			
		}
	}
}
