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
<%
	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	
	String userid = request.getParameter("uid");
	
	JSONObject ret = new JSONObject();
	
	String cmd = request.getParameter("cmd");
	
	if(cmd.equals("facebook_login")){
		System.out.println("facebook login command");
		
		String token = request.getParameter("token");
				
		pstmt = conn.prepareStatement("select uid from user where token = ? and service = 'Facebook'");
		pstmt.setString(1, token);
		rs = pstmt.executeQuery();

		if(rs.next()){
			// 이전에 facebook 연동을 한 유저라면
			String exist_uid = rs.getString(1);
			
			pstmt = conn.prepareStatement("update user set token = ?, service = 'Facebook' where uid = ?");
			pstmt.setString(1, token);
			pstmt.setString(2, exist_uid);
			
			if(pstmt.executeUpdate()>0){
				LogManager.writeNorLog(exist_uid, "link_success", cmd, "null","null", 0);
			}else{
				LogManager.writeNorLog(exist_uid, "link_fail", cmd, "null","null", 0);
			}
			
			// 기존에 uid를 가져온다.
			ret.put("uid", exist_uid);
			LogManager.writeNorLog(exist_uid, "success", "login", "null","null", 0);
		}
		else {
			// 이전에 facebook 연동을 한 적 없는 유저라면
			if(userid.equals("nil")){
				// 신규 유저 라면 
				pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");

				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				
				pstmt.setString(1, uuid);

				int r = pstmt.executeUpdate();
				if(r==1){
					pstmt = conn.prepareStatement("select * from user_regist where UUID = ?");
					pstmt.setString(1, uuid);
					rs = pstmt.executeQuery();
					int check = 0;
					while(rs.next()){
						check++;
						String uid = String.valueOf(rs.getInt("UID"));
						if(check>1){
							System.out.println("-- making uid error --");
							ret.put("error", 1);
							LogManager.writeNorLog(uid, "fbmake_fail", cmd, "null","null", 0);
							break;
						}else{
							pstmt = conn.prepareStatement("insert into user (uid,token,service) values(?,?,'Facebook')");
							pstmt.setString(1, uid);
							pstmt.setString(2, token);
							r = pstmt.executeUpdate();
							if(r == 1){
								ret.put("uid", uid);
								LogManager.writeNorLog(uid, "fbmake_success", cmd, "null","null", 0);
								LogManager.writeNorLog(uid, "success", "login", "null","null", 0);
							}else{
								ret.put("error",2);
								LogManager.writeNorLog(uid, "fbmake_fail2", cmd, "null","null", 0);
								System.out.println("--insert error -- ");
							}
						}
					}
					
				}
				
			}else{
				// 신규 유저가 아니라면 
				pstmt = conn.prepareStatement("update user set token = ?, service = 'Facebook' where uid = ?");
				pstmt.setString(1, token);
				pstmt.setString(2, userid);
				
				if(pstmt.executeUpdate()>0){
					LogManager.writeNorLog(userid, "fblogin_success", cmd, "null","null", 0);
					LogManager.writeNorLog(userid, "success", "login", "null","null", 0);
				}else{
					LogManager.writeNorLog(userid, "fblogin_fail", cmd, "null","null", 0);
				}
			}
		}
	}
	else if(cmd.equals("email_check")){
		System.out.println("email check command");
		
		pstmt = conn.prepareStatement("select uid from user where token = ? and service = 'Facebook'");
		
		String email = request.getParameter("email");
		
		pstmt = conn.prepareStatement("select uid from user where email = ? and service = 'Email'");
		pstmt.setString(1, email);
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			ret.put("exist", 1);
		}
		else {
			ret.put("exist", 0);
		}
	}
	else if(cmd.equals("email_login")) {
		System.out.println("email login command");

		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		pstmt = conn.prepareStatement("select service from user where uid = ?");
		
		pstmt.setString(1, userid);
		
		rs = pstmt.executeQuery();

		// 이전에 게스트로 가입한 유저라면
		if(rs.next()){
			pstmt = conn.prepareStatement("update user set service = 'Email', email = ?, password = ? where uid = ?");
			pstmt.setString(1, email);
			pstmt.setString(2, password);
			pstmt.setString(3, userid);
			
			if(pstmt.executeUpdate()>0){
				LogManager.writeNorLog(userid, "link_success", cmd, "null","null", 0);
			}else{
				LogManager.writeNorLog(userid, "link_fail", cmd, "null","null", 0);
			}

			ret.put("uid", userid);
		}
		// 처음 가입하는 유저
		else {
			pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");

			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			
			pstmt.setString(1, uuid);
			
			int r = pstmt.executeUpdate();
			if(r==1){
				pstmt = conn.prepareStatement("select * from user_regist where UUID = ?");
				pstmt.setString(1, uuid);
				rs = pstmt.executeQuery();
				int check = 0;
				while(rs.next()){
					check++;
					String uid = String.valueOf(rs.getInt("UID"));
					if(check>1){
						System.out.println("-- making uid error --");
						ret.put("error", 1);
						LogManager.writeNorLog(uid, "emmake_fail", cmd, "null","null", 0);
						break;
					}else{
						pstmt = conn.prepareStatement("insert into user (uid,email,password,service) values(?,?,?,'Email')");
						pstmt.setString(1, uid);
						pstmt.setString(2, email);
						pstmt.setString(3, password);
						r = pstmt.executeUpdate();
						if(r == 1){
							ret.put("uid", uid);
							LogManager.writeNorLog(uid, "emmake_success", cmd, "null","null", 0);
							LogManager.writeNorLog(uid, "success", "login", "null","null", 0);
						}else{
							ret.put("error",2);
							LogManager.writeNorLog(uid, "emmake_fail2", cmd, "null","null", 0);
							System.out.println("--insert error -- ");
						}
					}
				}
				
			}
		}
	}
	
	out.print(ret.toString());
	
	JdbcUtil.close(pstmt);
	JdbcUtil.close(rs);
	JdbcUtil.close(conn);
%>