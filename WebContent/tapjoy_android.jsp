<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC_KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.security.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.cashtester" %>
<%@ page import="com.wingsinus.ep.StoryManager" %>
<%@ page import="com.wingsinus.ep.CategoryList" %>
<%@ page import="com.wingsinus.ep.EpisodeList" %>
<%@ page import="com.wingsinus.ep.CostumeData" %>
<%@ page import="com.wingsinus.ep.BannerManager" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%@ page import="com.wingsinus.ep.ChdataManager" %>
<%@ page import="com.wingsinus.ep.ChlistManager" %>
<%@ page import="com.wingsinus.ep.ObdataManager" %>
<%@ page import="com.wingsinus.ep.SoundtableManager" %>
<%@ page import="com.wingsinus.ep.SelectItemData" %>
<%@ page import="com.wingsinus.ep.TutorialList" %>
<%
	request.setCharacterEncoding("UTF-8");
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	
	try {
		String secretkey = "rvkagCq77xmVe6W47F7T";
		String id = request.getParameter("id");
		String snuid = request.getParameter("snuid");
		String currency = request.getParameter("currency");
		String verifier = request.getParameter("verifier");
				
		MessageDigest md = MessageDigest.getInstance("MD5");
		String key = id + ":" + snuid + ":" + currency + ":" + secretkey;
		
		md.update(key.getBytes());
		byte messageDigest[] = md.digest();
		
		StringBuffer hexString = new StringBuffer();
		for(int i =0; i< messageDigest.length; i++) {
			String h = Integer.toHexString(0XFF & messageDigest[i]);
			while(h.length() < 2)
				h = "0" + h;
			hexString.append(h);
		}
		
		if(verifier.equals(hexString.toString())) {
			pstmt = conn.prepareStatement("update user set freegem = freegem + ? where uid = ?");
			pstmt.setInt(1, Integer.valueOf(currency));
			pstmt.setString(2, snuid);
			
			if(pstmt.executeUpdate()>0){
				System.out.println("success reward gem .. id: " + snuid + " / currency: " + currency + " in Android");
				LogManager.writeNorLog(snuid, "offerwall_success", "tapjoy_android", "gem","null", Integer.valueOf(currency));
				
				pstmt = conn.prepareStatement("select freeticket, cashticket, freegem, cashgem from user where uid = ?");
				
				pstmt.setString(1, snuid);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					LogManager.writeCashLog(snuid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
				}
				else {
					LogManager.writeNorLog(snuid, "cashlog_fail", "tapjoy_android", "gem","null", Integer.valueOf(currency));
				}
			}
			else {
				System.out.println("failed reward gem .. id: " + snuid + " / currency: " + currency + " in Android");
				LogManager.writeNorLog(snuid, "offerwall_fail", "tapjoy_android", "gem","null", Integer.valueOf(currency));
			}			
		}
		else {
			System.out.println("verifier error.. id : " + snuid + " in Android");
			LogManager.writeNorLog(snuid, "verifier_error", "tapjoy_android", "gem","null", Integer.valueOf(currency));
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>