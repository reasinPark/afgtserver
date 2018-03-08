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
		JSONArray cdlist = new JSONArray();
		JSONArray cllist = new JSONArray();
		JSONArray olist = new JSONArray();
		JSONArray slist = new JSONArray();
		
		pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");		
		
		String uuid = UUID.randomUUID().toString().replaceAll("-", "");
		
		pstmt.setString(1, uuid);
		int r = pstmt.executeUpdate();
		
		// csv Test parameter by Hong-Min
		String csvserver = request.getParameter("csvserver");
		
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
							data.put("ticket", tmpE.ticket);
							data.put("gem", tmpE.gem);
							data.put("purchaseinfo", tmpE.purchaseinfo);
							data.put("rewardgem", tmpE.reward_gem);
							data.put("rewardticket", tmpE.reward_ticket);
							data.put("rewardinfo", tmpE.rewardinfo);
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
							data.put("type",tmpB.type);
							data.put("callid",tmpB.callid);
							blist.add(data);
						}
						
						// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
						if (csvserver.equals("on")){
							
							ArrayList<ChdataManager> chdmp = ChdataManager.getDataAll();
							for(int i=0;i<chdmp.size();i++){
								ChdataManager tmpCh = chdmp.get(i);
								JSONObject data = new JSONObject();
								data.put("id", tmpCh.id);
								data.put("type", tmpCh.type);
								data.put("spinename", tmpCh.spinename);
								data.put("skinname", tmpCh.skinname);
								data.put("describe", tmpCh.describe);
								cdlist.add(data);
							}
							
							ArrayList<ChlistManager> chlmp = ChlistManager.getDataAll();
							for(int i=0;i<chlmp.size();i++){
								ChlistManager tmpCl = chlmp.get(i);
								JSONObject data = new JSONObject();
								data.put("id", tmpCl.id);
								data.put("name", tmpCl.name);
								data.put("hid", tmpCl.hid);
								data.put("bid", tmpCl.bid);
								data.put("oid", tmpCl.oid);
								data.put("portrait", tmpCl.portrait);
								cllist.add(data);
							}
							
							ArrayList<ObdataManager> omp = ObdataManager.getDataAll();
							for(int i=0;i<omp.size();i++){
								ObdataManager tmpO = omp.get(i);
								JSONObject data = new JSONObject();
								data.put("id", tmpO.id);
								data.put("type", tmpO.type);
								data.put("name", tmpO.name);
								data.put("texture", tmpO.texture);
								data.put("image", tmpO.image);
								olist.add(data);
							}
							
							ArrayList<SoundtableManager> stmp = SoundtableManager.getDataAll();
							for(int i=0;i<stmp.size();i++){
								SoundtableManager tmpS = stmp.get(i);
								JSONObject data = new JSONObject();
								data.put("soundid", tmpS.soundid);
								data.put("timer", tmpS.timer);
								slist.add(data);
							}
	
							ret.put("chdatalist", cdlist);
							ret.put("chlistlist", cllist);
							ret.put("obdatalist", olist);
							ret.put("soundtablelist", slist);
						}// end of csvserver.equal("on")
						
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
		String service = "";
		JSONArray jlist = new JSONArray();
		JSONArray elist = new JSONArray();
		JSONArray blist = new JSONArray();
		JSONArray clist = new JSONArray();
		JSONArray cdlist = new JSONArray();
		JSONArray cllist = new JSONArray();
		JSONArray olist = new JSONArray();
		JSONArray slist = new JSONArray();
		
		rs = pstmt.executeQuery();
		System.out.println("rs count "+userid);
		
		// csv Test parameter by Hong-Min
		String csvserver = request.getParameter("csvserver");
		
		if(rs.next()){
			System.out.print("rs count ");
			freeticket = rs.getInt("freeticket");
			gentime = rs.getTimestamp("ticketgentime").getTime()/1000;
			cashticket = rs.getInt("cashticket");
			freegem = rs.getInt("freegem");
			cashgem = rs.getInt("cashgem");
			ticket = freeticket + cashticket;
			gem = freegem + cashgem;
			service = rs.getString("service");
			
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
				data.put("ticket", tmpE.ticket);
				data.put("gem", tmpE.gem);
				data.put("purchaseinfo", tmpE.purchaseinfo);
				data.put("rewardgem", tmpE.reward_gem);
				data.put("rewardticket", tmpE.reward_ticket);
				data.put("rewardinfo", tmpE.rewardinfo);
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
				data.put("type",tmpB.type);
				data.put("callid",tmpB.callid);
				blist.add(data);
			}
			
			// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
			if (csvserver.equals("on")){
				System.out.println("get csv from server!!");
				
				ArrayList<ChdataManager> chdmp = ChdataManager.getDataAll();
				for(int i=0;i<chdmp.size();i++){
					ChdataManager tmpCh = chdmp.get(i);
					JSONObject data = new JSONObject();
					data.put("id", tmpCh.id);
					data.put("type", tmpCh.type);
					data.put("spinename", tmpCh.spinename);
					data.put("skinname", tmpCh.skinname);
					data.put("describe", tmpCh.describe);
					System.out.println("id is : "+tmpCh.id+", type is : "+tmpCh.type+", spinename is : "+tmpCh.spinename+", skinename is : "+tmpCh.skinname+"describe is : "+tmpCh.describe);
					cdlist.add(data);
				}
				
				ArrayList<ChlistManager> chlmp = ChlistManager.getDataAll();
				for(int i=0;i<chlmp.size();i++){
					ChlistManager tmpCl = chlmp.get(i);
					JSONObject data = new JSONObject();
					data.put("id", tmpCl.id);
					data.put("name", tmpCl.name);
					data.put("hid", tmpCl.hid);
					data.put("bid", tmpCl.bid);
					data.put("oid", tmpCl.oid);
					data.put("portrait", tmpCl.portrait);
					cllist.add(data);
				}
				
				ArrayList<ObdataManager> omp = ObdataManager.getDataAll();
				for(int i=0;i<omp.size();i++){
					ObdataManager tmpO = omp.get(i);
					JSONObject data = new JSONObject();
					data.put("id", tmpO.id);
					data.put("type", tmpO.type);
					data.put("name", tmpO.name);
					data.put("texture", tmpO.texture);
					data.put("image", tmpO.image);
					olist.add(data);
				}
				
				ArrayList<SoundtableManager> stmp = SoundtableManager.getDataAll();
				for(int i=0;i<stmp.size();i++){
					SoundtableManager tmpS = stmp.get(i);
					JSONObject data = new JSONObject();
					data.put("soundid", tmpS.soundid);
					data.put("timer", tmpS.timer);
					slist.add(data);
				}
			}// end of csvserver.equal("on")
			
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
		pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num from user_story where UID = ?");
		pstmt.setString(1,userid);
		JSONArray storylist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("StoryID",rs.getString(1));
			data.put("EpisodeNum",rs.getInt(2));
			data.put("LatelyNum",rs.getInt(3));
			data.put("BuyNum",rs.getInt(4));
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
		
		// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
		if (csvserver.equals("on")){
			System.out.println("csvserver : " + csvserver);
			ret.put("chdatalist", cdlist);
			ret.put("chlistlist", cllist);
			ret.put("obdatalist", olist);
			ret.put("soundtablelist", slist);
		}// end of csvserver.equals("on")
		
		ret.put("namelist",namelist);
		ret.put("userstorylist",storylist);
		ret.put("userskinlist",skinlist);
		ret.put("costumelist",clist);
		ret.put("bannerlist", blist);
		ret.put("episodelist",elist);
		ret.put("categorylist",jlist);
		ret.put("ticket", ticket);
		ret.put("ticketgentime",gentime);
		ret.put("gem",gem);
		ret.put("nowtime",now);
		ret.put("service", service);
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
	else if(cmd.equals("cashrefresh")){
		pstmt = conn.prepareStatement("select freeticket,cashticket,freegem,cashgem from user where uid = ?");
		pstmt.setString(1,userid);
		rs = pstmt.executeQuery();
		if(rs.next()){
			ret.put("gem",(rs.getInt(3)+rs.getInt(4)));
			ret.put("ticket",(rs.getInt(1)+rs.getInt(2)));
			ret.put("success",1);
		}else{
			ret.put("success",0);
		}		
	}
	else if(cmd.equals("episodestart")){
		String Storyid = request.getParameter("StoryId");
		int episodenum = Integer.valueOf(request.getParameter("episodenum"));
		pstmt = conn.prepareStatement("select buy_num from user_story where uid = ? and story_id = ?");
		pstmt.setString(1, userid);
		pstmt.setString(2, Storyid);
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			int buynum = rs.getInt(1);
			
			// 처음 구매해서 buy_num 값 갱신 
			if(buynum < episodenum) {
				pstmt = conn.prepareStatement("update user_story set lately_num = ?, buy_num = ? where UID = ? and Story_id = ?");
				pstmt.setInt(1,episodenum);
				pstmt.setInt(2,episodenum);
				pstmt.setString(3, userid);
				pstmt.setString(4, Storyid);
				if(pstmt.executeUpdate()==1) {
					ret.put("success", 1);
					LogManager.writeNorLog(userid, "sucess_buyepi", cmd, "null","null", 0);	
				}
				else {
					ret.put("success", 0);
					LogManager.writeNorLog(userid, "fail_buyepi", cmd, "null","null", 0);
				}
			}
			// 이미 구매해서 lately_num 값만 갱신
			else {
				pstmt = conn.prepareStatement("update user_story set lately_num = ? where UID = ? and Story_id = ?");
				pstmt.setInt(1,episodenum);
				pstmt.setString(2, userid);
				pstmt.setString(3, Storyid);
				if(pstmt.executeUpdate()==1) {
					ret.put("success", 1);
					LogManager.writeNorLog(userid, "sucess_lately", cmd, "null","null", 0);	
				}
				else {
					ret.put("success", 0);
					LogManager.writeNorLog(userid, "fail_lately", cmd, "null","null", 0);
				}
			}
		}else{
			//lately insert
			pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,view_date,lately_num,buy_num) values(?,?,0,0,now(),?,?)");
			pstmt.setString(1, userid);
			pstmt.setString(2, Storyid);
			pstmt.setInt(3, episodenum);
			pstmt.setInt(4, episodenum);
			if(pstmt.executeUpdate()==1) {
				ret.put("success", 1);
				LogManager.writeNorLog(userid, "sucess_lately", cmd, "null","null", 0);	
			}
			else {
				ret.put("success", 0);
				LogManager.writeNorLog(userid, "fail_lately", cmd, "null","null", 0);
			}
		}
		
		// 유저 이야기 읽은 정보 로드
		pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num from user_story where UID = ?");
		pstmt.setString(1,userid);
		JSONArray storylist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("StoryID",rs.getString(1));
			data.put("EpisodeNum",rs.getInt(2));
			data.put("LatelyNum",rs.getInt(3));
			data.put("BuyNum",rs.getInt(4));
			storylist.add(data);
		}
				
		ret.put("userstorylist",storylist);
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
				int checker = pstmt.executeUpdate();
				System.out.println("upd ate checker is :"+checker+ "uid is :"+userid);
				if(checker==1){
					System.out.println("step 1");
					EpisodeList data = EpisodeList.getData(episodenum);
					System.out.println("reward ticket is :"+data.reward_ticket+", gem is :"+data.reward_gem);
					pstmt = conn.prepareStatement("update user set freeticket = freeticket + ?, freegem = freegem + ? where uid = ?");
					pstmt.setInt(1, data.reward_ticket);
					pstmt.setInt(2, data.reward_gem);
					pstmt.setString(3, userid);
					if(pstmt.executeUpdate()==1){
						if (data.reward_ticket > 0) {
							ret.put("getticket", 1);
						}
						ret.put("success", 1);
						ret.put("reward", 1);
						System.out.println("success update");
						LogManager.writeNorLog(userid, "sucess_reward", cmd, "null","null", 0);	
					}else{
						System.out.println("success fail");
						ret.put("success", 0);
						LogManager.writeNorLog(userid, "fail_reward", cmd, "null","null", 0);
					}
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
			pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,view_date,lately_num) values(?,?,?,0,now(),?)");
			pstmt.setString(1, userid);
			pstmt.setString(2, Storyid);
			pstmt.setInt(3, episodenum);
			pstmt.setInt(4, episodenum);
			int checker = pstmt.executeUpdate();
			System.out.println("checker is :"+checker+ "uid is :"+userid);
			if(checker==1){
				EpisodeList data = EpisodeList.getData(episodenum);
				pstmt = conn.prepareStatement("update user set freeticket = freeticket + ?, freegem = freegem + ? where uid = ?");
				pstmt.setInt(1, data.reward_ticket);
				pstmt.setInt(2, data.reward_gem);
				pstmt.setString(3, userid);
				checker = pstmt.executeUpdate();
				System.out.println("input another checker : "+checker);
				if(checker==1){
					if (data.reward_ticket > 0) {
						ret.put("getticket", 1);
					}
					ret.put("success", 1);
					ret.put("reward", 1);
					LogManager.writeNorLog(userid, "sucess_reward", cmd, "null","null", 0);	
				}else{
					ret.put("success", 0);
					LogManager.writeNorLog(userid, "fail_reward", cmd, "null","null", 0);
				}
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
			}
		}
		
		// 유저 이야기 읽은 정보 로드
		pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num from user_story where UID = ?");
		pstmt.setString(1,userid);
		JSONArray storylist = new JSONArray();
		rs = pstmt.executeQuery();
		while(rs.next()){
			JSONObject data = new JSONObject();
			data.put("StoryID",rs.getString(1));
			data.put("EpisodeNum",rs.getInt(2));
			data.put("LatelyNum",rs.getInt(3));
			data.put("BuyNum",rs.getInt(4));
			storylist.add(data);
		}
		
		ret.put("userstorylist",storylist);
	}
	else if(cmd.equals("buyepisode")){
		String Storyid = request.getParameter("StoryId");
		int episodenum = Integer.valueOf(request.getParameter("episodenum"));
		int ticketValue = Integer.valueOf(request.getParameter("ticket"));
		long ticketGenTime = 0;
		pstmt = conn.prepareStatement("update user set cashticket = cashticket - ? where uid = ?");
		pstmt.setInt(1, ticketValue);
		pstmt.setString(2, userid);
		
		if(pstmt.executeUpdate()==1){
			ret.put("success",1);

			LogManager.writeNorLog(userid, "sucess", cmd, "null","null", 0);
			
			pstmt = conn.prepareStatement("select freeticket, cashticket from user where uid = ?");
			pstmt.setString(1,userid);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				if (rs.getInt(1)+rs.getInt(2) == 0) {
					pstmt = conn.prepareStatement("update user set ticketgentime = date_add(now(), interval 2 day) where uid = ?");
					pstmt.setString(1, userid);
					
					if(pstmt.executeUpdate()==1){
						LogManager.writeNorLog(userid, "sucess_set_gentime", cmd, "null","null", 0);
						
						pstmt = conn.prepareStatement("select ticketgentime,now() from user where uid = ?");
						pstmt.setString(1,userid);
						
						rs = pstmt.executeQuery();
						
						if(rs.next()){
							ticketGenTime = rs.getTimestamp(1).getTime()/1000;
							now = rs.getTimestamp(2).getTime()/1000;
							ret.put("ticketgentime", ticketGenTime);
							ret.put("nowtime", now);
							ret.put("timecheck", 1);
						}
					}
					else {
						LogManager.writeNorLog(userid, "fail_set_gentime", cmd, "null","null", 0);
					}
				}
				else {
					ret.put("timecheck", 0);
				}
			}
			
		}else{
			ret.put("success",0);
			LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
		}
	}
	else if(cmd.equals("ticketcharge")) {
		pstmt = conn.prepareStatement("update user set freeticket = freeticket + 1 where uid = ?");
		pstmt.setString(1, userid);
		
		if(pstmt.executeUpdate()>0){
			LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			ret.put("success", 1);
		}
		else {
			LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
			ret.put("success", 0);
		}
	}
	
	out.print(ret.toString());
	
	JdbcUtil.close(pstmt);
	JdbcUtil.close(stmt);
	JdbcUtil.close(rs);
	JdbcUtil.close(conn);
%>