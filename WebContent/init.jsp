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
	
	if (cmd.equals("registuser")){
		//regist user log
		JSONArray jlist = new JSONArray();
		JSONArray elist = new JSONArray();
		JSONArray blist = new JSONArray();
		JSONArray clist = new JSONArray();
		
		pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");		
		
		String uuid = UUID.randomUUID().toString().replaceAll("-", "");
		
		pstmt.setString(1, uuid);
		
		int r = pstmt.executeUpdate();
		
		if(r == 1){
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
					LogManager.writeNorLog(uid, "fail", cmd, "null","null", 0);
					break;
				}else{
					pstmt = conn.prepareStatement("insert into user (uid) values(?)");
					pstmt.setString(1, uid);
					r = pstmt.executeUpdate();
					if(r == 1){
						ret.put("uid", uid);
						
						ArrayList<CostumeData> cmp = CostumeData.getDataAll();
						for(int i=0;i<cmp.size();i++){
							CostumeData cmpD = cmp.get(i);
							JSONObject data = new JSONObject();
							data.put("CostumeId", cmpD.CostumeId);
							data.put("CallId",cmpD.CallId);
							data.put("ChId", cmpD.ChId);
							data.put("Skinname", cmpD.Skinname);
							data.put("filename", cmpD.filename);
							data.put("thumnailname", cmpD.thumnailname);
							data.put("selectani", cmpD.selectani);
							data.put("buyani", cmpD.buyani);
							data.put("description", cmpD.description);
							data.put("price", cmpD.price);
							data.put("name", cmpD.name);
							data.put("episodeid", cmpD.episodeId);
							data.put("storyid", cmpD.StroyId);
							clist.add(data);
						}
						
						ArrayList<CategoryList> tmp = CategoryList.getDataAll();
						System.out.println("array count is : "+tmp.size());
						for(int i=0;i<tmp.size();i++){
							CategoryList tmpD = tmp.get(i);
							JSONObject data = new JSONObject();
							data.put("categoryid", tmpD.category_id);
							data.put("categoryname",tmpD.category_name);
							data.put("ordernum", tmpD.ordernum);
							System.out.println("categoryid is : "+tmpD.category_id+", name is : "+tmpD.category_name+", num is : "+tmpD.ordernum);
							jlist.add(data);
						}
						
						ArrayList<EpisodeList> emp = EpisodeList.getDataAll();
						for(int i=0;i<emp.size();i++){
							EpisodeList tmpE = emp.get(i);
							JSONObject data = new JSONObject();
							data.put("StoryID", tmpE.Story_id);
							data.put("EpisodeNum", tmpE.Episode_num);
							data.put("EpisodeName", tmpE.Episode_name);
							data.put("filename", tmpE.csvfilename);
							elist.add(data);
						}
						
						ArrayList<BannerManager> bmp = BannerManager.getDataAll();
						for(int i=0;i<bmp.size();i++){
							BannerManager tmpB = bmp.get(i);
							JSONObject data = new JSONObject();
							data.put("newmark", tmpB.newmark);
							data.put("title", tmpB.Title);
							data.put("text", tmpB.Text);
							data.put("imgname",tmpB.Imgname);
							blist.add(data);
						}
						ret.put("costumedata",clist);
						ret.put("bannerlist", blist);
						ret.put("episodelist",elist);
						ret.put("categorylist",jlist);
						LogManager.writeNorLog(uid, "success", cmd, "null","null", 0);
					}else{
						ret.put("error",2);
						LogManager.writeNorLog(uid, "fail2", cmd, "null","null", 0);
						System.out.println("--insert error -- ");
					}
				}
			}
			
			System.out.println("-----Regi Success-----");
		}else{
			
			System.out.println("----Regi Fail----");
		}
	}else if(cmd.equals("login")){
		//login log manager
		System.out.println("input login command");
		pstmt = conn.prepareStatement("select * from user where uid = ?");
		pstmt.setString(1, userid);
		int freeticket = 0;
		long gentime = 0;
		int cashticket = 0;
		int freegem = 0;
		int cashgem = 0;
		int ticket = 0;
		int gem = 0;
		JSONArray jlist = new JSONArray();
		JSONArray elist = new JSONArray();
		JSONArray blist = new JSONArray();
		JSONArray clist = new JSONArray();
		
		rs = pstmt.executeQuery();
		System.out.println("rs count "+userid);
		if(rs.next()){
			System.out.print("rs count ");
			freeticket = rs.getInt("freeticket");
			gentime = rs.getTimestamp("ticketgentime").getTime()/1000;
			cashticket = rs.getInt("cashticket");
			freegem = rs.getInt("freegem");
			cashgem = rs.getInt("cashgem");
			ticket = freeticket + cashticket;
			gem = freegem + cashgem;
			
			ArrayList<CostumeData> cmp = CostumeData.getDataAll();
			for(int i=0;i<cmp.size();i++){
				CostumeData cmpD = cmp.get(i);
				JSONObject data = new JSONObject();
				data.put("CostumeId", cmpD.CostumeId);
				data.put("CallId",cmpD.CallId);
				data.put("ChId", cmpD.ChId);
				data.put("Skinname", cmpD.Skinname);
				data.put("filename", cmpD.filename);
				data.put("thumnailname", cmpD.thumnailname);
				data.put("selectani", cmpD.selectani);
				data.put("buyani", cmpD.buyani);
				data.put("description", cmpD.description);
				data.put("price", cmpD.price);
				data.put("name", cmpD.name);
				data.put("episodeid", cmpD.episodeId);
				data.put("storyid", cmpD.StroyId);
				clist.add(data);
			}
			
			
			ArrayList<CategoryList> tmp = CategoryList.getDataAll();
			System.out.println("array count is : "+tmp.size());
			for(int i=0;i<tmp.size();i++){
				CategoryList tmpD = tmp.get(i);
				JSONObject data = new JSONObject();
				data.put("categoryid", tmpD.category_id);
				data.put("categoryname",tmpD.category_name);
				data.put("ordernum", tmpD.ordernum);
				System.out.println("categoryid is : "+tmpD.category_id+", name is : "+tmpD.category_name+", num is : "+tmpD.ordernum);
				jlist.add(data);
			}
			
			ArrayList<EpisodeList> emp = EpisodeList.getDataAll();
			for(int i=0;i<emp.size();i++){
				EpisodeList tmpE = emp.get(i);
				JSONObject data = new JSONObject();
				data.put("StoryID", tmpE.Story_id);
				data.put("EpisodeNum", tmpE.Episode_num);
				data.put("EpisodeName", tmpE.Episode_name);
				data.put("filename", tmpE.csvfilename);
				elist.add(data);
			}
			
			ArrayList<BannerManager> bmp = BannerManager.getDataAll();
			for(int i=0;i<bmp.size();i++){
				BannerManager tmpB = bmp.get(i);
				JSONObject data = new JSONObject();
				data.put("newmark", tmpB.newmark);
				data.put("title", tmpB.Title);
				data.put("text", tmpB.Text);
				data.put("imgname",tmpB.Imgname);
				blist.add(data);
			}
			LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
		}else{
			LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
		}

		// 유저 스킨 구매 정보 로드 
		pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
		pstmt.setString(1, userid);
		JSONArray skinlist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("costumeid",rs.getString(1));
			data.put("charid",rs.getString(2));
			data.put("equip",rs.getString(3));
			skinlist.add(data);
		}
		
		
		// 유저 이야기 읽은 정보 로드
		pstmt = conn.prepareStatement("select Story_id,Episode_num from user_story where UID = ?");
		pstmt.setString(1,userid);
		JSONArray storylist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("StoryID",rs.getString(1));
			data.put("EpisodeNum",rs.getInt(2));
			storylist.add(data);
		}
		
		//유저 이름 세팅 정보 로드
		pstmt = conn.prepareStatement("select charid,name from user_chname where uid = ?");
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		JSONArray namelist = new JSONArray();
		while(rs.next()){
			JSONObject cdata = new JSONObject();
			cdata.put("id","#"+rs.getString(1));
			cdata.put("name",rs.getString(2));
			namelist.add(cdata);
		}
		
		ret.put("namelist",namelist);
		ret.put("userstorylist",storylist);
		ret.put("userskinlist",skinlist);
		ret.put("costumelist",clist);
		ret.put("bannerlist", blist);
		ret.put("episodelist",elist);
		ret.put("categorylist",jlist);
		ret.put("freeticket", ticket);
		ret.put("ticketgentime",gentime);
		ret.put("gem",gem);
		ret.put("nowtime",now);
	}else if(cmd.equals("buyskin")){
		//user skin buy logaction
		
		//int cmd = request.getParameter("cmd");
		int costumeid = Integer.valueOf(request.getParameter("costumeid"));
		//int usercash = Integer.valueOf(request.getParameter("cash"));
		// check user already have this costume
		
		CostumeData data = CostumeData.getData(costumeid);
		int usercash = data.CostumeId;
		
		pstmt = conn.prepareStatement("select CostumeId from user_skindata where uid = ? and CostumeId = ?");
		pstmt.setString(1, userid);
		pstmt.setInt(2,costumeid);
		rs = pstmt.executeQuery();
		if(rs.next()){
			ret.put("already",1);
			LogManager.writeNorLog(userid, "fail_have", cmd, "null","null", 0);
		}else{
			//input costumeid
			//check cash
			//delivery result
			pstmt = conn.prepareStatement("insert into user_skindata (CostumeId,buy_Date,use_rcash,uid,charid) values(?,now(),?,?,?)");
			pstmt.setInt(1, costumeid);
			pstmt.setInt(2, usercash);
			pstmt.setString(3, userid);
			pstmt.setString(4,data.ChId);
			
			if(pstmt.executeUpdate()==1){
				ret.put("success",1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail_updateerror", cmd, "null","null", 0);
			}	
		}

		// 유저 스킨 구매 정보 로드 
		pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
		pstmt.setString(1, userid);
		JSONArray skinlist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject cdata = new JSONObject();
			cdata.put("costumeid",rs.getString(1));
			cdata.put("charid",rs.getString(2));
			cdata.put("equip",rs.getString(3));
			skinlist.add(cdata);
		}
		ret.put("userskinlist",skinlist);
		
	}else if(cmd.equals("skinequip")){
		//skin equip log action
		int costumeid = Integer.valueOf(request.getParameter("costumeid"));
		ArrayList<CostumeData> cmp = CostumeData.getDataAll();
		for(int i=0;i<cmp.size();i++){
			CostumeData tdata = cmp.get(i);
			if(tdata.CostumeId==costumeid){
				pstmt = conn.prepareStatement("update user_skindata set equip = 0 where uid = ? and charid = ?");
				pstmt.setString(1, userid);
				pstmt.setString(2,tdata.ChId);
				pstmt.executeUpdate();
				break;
			}
		}
		pstmt = conn.prepareStatement("update user_skindata set equip = 1 where uid = ? and costumeId = ?");
		pstmt.setString(1, userid);
		pstmt.setInt(2,costumeid);
		if(pstmt.executeUpdate()>0){
			ret.put("success",1);
			LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
		}else{
			ret.put("success",0);
			LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
		}
		// 유저 스킨 구매 정보 로드 
		pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
		pstmt.setString(1, userid);
		JSONArray skinlist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject cdata = new JSONObject();
			cdata.put("costumeid",rs.getString(1));
			cdata.put("charid",rs.getString(2));
			cdata.put("equip",rs.getString(3));
			skinlist.add(cdata);
		}
		ret.put("userskinlist",skinlist);
	}else if(cmd.equals("setcustomname")){
		String charid = request.getParameter("charid");
		String name = request.getParameter("chname");
		pstmt = conn.prepareStatement("select idx from user_chname where uid = ? and charid = ?");
		pstmt.setString(1,userid);
		pstmt.setString(2, charid);
		rs = pstmt.executeQuery();
		if(rs.next()){
			//update
			pstmt = conn.prepareStatement("update user_chname set name = ? where uid = ? and charid = ?");
			pstmt.setString(1, name);
			pstmt.setString(2, userid);
			pstmt.setString(3, charid);
			if(pstmt.executeUpdate()>0){
				ret.put("success", 1);
				//update log
			}else{
				ret.put("success", 0);
				//update fail log
			}
		}else{
			//insert
			pstmt = conn.prepareStatement("insert into user_chname (uid,charid,name) values(?,?,?)");
			pstmt.setString(1, userid);
			pstmt.setString(2, charid);
			pstmt.setString(3, name);
			if(pstmt.executeUpdate()>0){
				ret.put("success",1);
				//insert log
			}else{
				ret.put("success",0);
				//insert fail log
			}
		}
		//유저 이름 세팅 정보 로드
		pstmt = conn.prepareStatement("select charid,name from user_chname where uid = ?");
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		JSONArray namelist = new JSONArray();
		while(rs.next()){
			JSONObject cdata = new JSONObject();
			cdata.put("id","#"+rs.getString(1));
			cdata.put("name",rs.getString(2));
			namelist.add(cdata);
		}
		ret.put("namelist",namelist);
	}
	else if(cmd.equals("skinunequip")){
		//skin un equip log action
		String charid = request.getParameter("charid");
		pstmt = conn.prepareStatement("update user_skindata set equip = 0 where charid = ? and uid = ?");
		pstmt.setString(1,charid);
		pstmt.setString(2, userid);
		if(pstmt.executeUpdate()>0){
			ret.put("success",1);
			LogManager.writeNorLog(userid, "sucess", cmd, "null","null", 0);
		}else{
			ret.put("success",0);
			LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
		}	
	}
	else if(cmd.equals("episodeend")){
		//episode 다 읽음 처리 log action
		//user의 해당 스토리의 해당 에피소드 다 읽음 처리
		//get user story의 lastepisode
		//if nowepisode > lastepisode
		//insert into episodenum
		String Storyid = request.getParameter("StoryId");
		int episodenum = Integer.valueOf(request.getParameter("episodenum"));
		System.out.println("Story id is :"+Storyid+", episodenum is :"+episodenum);
		pstmt = conn.prepareStatement("select Episode_num from user_story where uid = ? and story_id = ?");
		pstmt.setString(1, userid);
		pstmt.setString(2, Storyid);
		rs = pstmt.executeQuery();
		int counter = 0;
		
		if(rs.next()){
			System.out.println("flow input here");
			counter++;
			int tmpepisode = rs.getInt(1);
			if(tmpepisode<episodenum){
				//episode update
				pstmt = conn.prepareStatement("update user_story set Episode_num = ? where UID = ? and Story_id = ?");
				pstmt.setInt(1,episodenum);
				pstmt.setString(2, userid);
				pstmt.setString(3, Storyid);
				if(pstmt.executeUpdate()==1){
					ret.put("success",1);
					LogManager.writeNorLog(userid, "sucess", cmd, "null","null", 0);
				}else{
					ret.put("success",0);
					LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
				}
			}else{
				ret.put("already",1);
				LogManager.writeNorLog(userid, "fail_already", cmd, "null","null", 0);
			}
		}else{
			//episode insert
			System.out.println("rs is not here Story id is :"+Storyid+", episodenum is :"+episodenum);
			pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,view_date) values(?,?,?,0,now())");
			pstmt.setString(1, userid);
			pstmt.setString(2, Storyid);
			pstmt.setInt(3, episodenum);
			int checker = pstmt.executeUpdate();
			System.out.println("checker is :"+checker);
			if(checker==1){
				ret.put("success",1);
				LogManager.writeNorLog(userid, "sucess_insert", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
			}
		}
		
		// 유저 이야기 읽은 정보 로드
		pstmt = conn.prepareStatement("select Story_id,Episode_num from user_story where UID = ?");
		pstmt.setString(1,userid);
		JSONArray storylist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("StoryID",rs.getString(1));
			data.put("EpisodeNum",rs.getInt(2));
			storylist.add(data);
		}
		
		ret.put("userstorylist",storylist);
	}
	
	
	out.print(ret.toString());
	
	JdbcUtil.close(pstmt);
	JdbcUtil.close(stmt);
	JdbcUtil.close(rs);
	JdbcUtil.close(conn);
%>