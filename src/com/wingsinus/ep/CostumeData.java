package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class CostumeData {
	public int CostumeId;
	public String CallId;
	public String ChId;
	public String Skinname;
	public String filename;
	public String thumnailname;
	public String selectani;
	public String buyani;
	public String description;
	public int price;
	public String name;
	public int episodeId;
	public String StroyId;
	
	private static ArrayList<CostumeData> list = null;
	
	private static HashMap<Integer,CostumeData> hash = null;
	
	public CostumeData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select CostumeId,CallId,ChId,Skinname,filename,thumnailname,selectani,buyani,description,cash,name,episodeid,storyid from CostumeData");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				CostumeData data = new CostumeData();
				data.CostumeId = rs.getInt(idx++);
				data.CallId = rs.getString(idx++);
				data.ChId = rs.getString(idx++);
				data.Skinname = rs.getString(idx++);
				data.filename = rs.getString(idx++);
				data.thumnailname = rs.getString(idx++);
				data.selectani = rs.getString(idx++);
				data.buyani = rs.getString(idx++);
				data.description = rs.getString(idx++);
				data.price = rs.getInt(idx++);
				data.name = rs.getString(idx++);
				data.episodeId = rs.getInt(idx++);
				data.StroyId = rs.getString(idx++);
				list.add(data);
				hash.put(data.CostumeId,data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<CostumeData>();
			hash = new HashMap<Integer,CostumeData>();
			initData();
		}
	}
	
	public static void CostumeDataReset(){
		list = null;
		hash = null;
	}
	
	public static CostumeData getData(int CostumeId) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(CostumeId);
	}
	
	public static ArrayList<CostumeData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
	
	
}
