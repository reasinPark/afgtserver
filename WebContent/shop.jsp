	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.cashtester" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%@ page import="com.wingsinus.ep.shopManager" %>
<%
	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	long now = 0;
	
	stmt = conn.createStatement(); 
	
	rs = stmt.executeQuery("select now()");
	
	if(rs.next()){
		now = rs.getTimestamp(1).getTime()/1000;
	}
	
	String userid = request.getParameter("uid");
	
	JSONObject ret = new JSONObject();
	
	String cmd = request.getParameter("cmd");
	
	if (cmd.equals("loadshop")){
		JSONArray slist = new JSONArray();
		ArrayList<shopManager> smp = shopManager.getDataAll();
		for(int i=0;i<smp.size();i++){
			shopManager smpD = smp.get(i);
			JSONObject data = new JSONObject();
			data.put("shopid", smpD.shop_id);
			data.put("type", smpD.type);
			data.put("title", smpD.title);
			data.put("price",smpD.price);
			data.put("gem",smpD.gem);
			data.put("ticket", smpD.ticket);
			slist.add(data);
		}
		ret.put("shopdata", slist);
		pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		System.out.println("update query and return checker");
		if(rs.next()){
			int gemsum = rs.getInt(1)+rs.getInt(2);
			int ticketsum = rs.getInt(3)+rs.getInt(4);
			System.out.println("gem is :"+gemsum+", ticket is :"+ticketsum);
			ret.put("ticket",ticketsum);
			ret.put("gem",gemsum);
		}
		LogManager.writeNorLog(userid, "success", cmd, "null", "null", 0);
	}
	else if(cmd.equals("buyitem")){
		int shopid = Integer.valueOf(request.getParameter("shopid"));
		
		shopManager data = shopManager.getData(shopid);
		int getgem = data.gem;
		int getticket = data.ticket;
		
		//결재 성공여부 확인(따로 확인안함) 
		
		// 유저 아이템 증가
		pstmt = conn.prepareStatement("update user set cashticket = cashticket + ?, cashgem = cashgem + ? where uid = ?");
		pstmt.setInt(1, getticket);
		pstmt.setInt(2, getgem);
		pstmt.setString(3, userid);
		if(pstmt.executeUpdate()>0){
			pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				int gemsum = rs.getInt(1)+rs.getInt(2);
				int ticketsum = rs.getInt(3)+rs.getInt(4);
				ret.put("ticket",ticketsum);
				ret.put("gem",gemsum);
				ret.put("addticket",getticket);
				ret.put("addgem",getgem);
			}
			ret.put("success", 1);
		}else{
			ret.put("success", 0);
		}		
	}		
	out.print(ret.toString());
	
	JdbcUtil.close(pstmt);
	JdbcUtil.close(stmt);
	JdbcUtil.close(rs);
	JdbcUtil.close(conn);
%>