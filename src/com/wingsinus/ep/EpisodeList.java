package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class EpisodeList {
	public String Story_id;
	public String csvfilename;
	public int Episode_num;
	public String Episode_name;

	private static ArrayList<EpisodeList> list = null;
	
	public EpisodeList(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select Story_id,episode_num,episode_name,csvfilename from episode");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				EpisodeList data = new EpisodeList();
				data.Story_id = rs.getString(idx++);
				data.Episode_num = rs.getInt(idx++);
				data.Episode_name = rs.getString(idx++);
				data.csvfilename = rs.getString(idx++);
				list.add(data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null){
			list = new ArrayList<EpisodeList>();
			initData();
		}
	}
	
	public static void EpisodeListReset(){
		list = null;
	}
	
	public static ArrayList<EpisodeList> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
