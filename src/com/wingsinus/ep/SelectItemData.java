package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class SelectItemData {
	public int SelectId;
	public String StoryId;
	public int Price;
	public int Epinum;
	
	private static ArrayList<SelectItemData> list = null;
	
	public SelectItemData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select selectid,price,storyid,epinum from SelectItem");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				SelectItemData data = new SelectItemData();
				data.SelectId = rs.getInt(idx++);
				data.StoryId = rs.getString(idx++);
				data.Price = rs.getInt(idx++);
				data.Epinum = rs.getInt(idx++);
				list.add(data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null){
			list = new ArrayList<SelectItemData>();
			initData();
		}
	}
	
	public static ArrayList<SelectItemData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() <1)
			return null;
		return list;
	}
}
