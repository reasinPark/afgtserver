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
<%@ page import="com.wingsinus.ep.SelectItemData" %>
<%@ page import="com.wingsinus.ep.TutorialList" %>
<%

	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	try{
			
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
			JSONArray sellist = new JSONArray();
			
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
				String uid = null;
				while(rs.next()){
					check++;
					uid = String.valueOf(rs.getInt("UID"));
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
								data.put("viewingame",cmpD.viewingame);
								data.put("BFilename",cmpD.BFilename);
								data.put("BSkinname",cmpD.BSkinname);
								data.put("FFilename",cmpD.FFilename);
								data.put("FSkinname",cmpD.FSkinname);
								data.put("HFilename",cmpD.HFilename);
								data.put("HSkinname",cmpD.HSkinname);
								data.put("AFilename",cmpD.AFilename);
								data.put("ASkinname",cmpD.ASkinname);
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
								data.put("writer", tmpE.writer);
								data.put("director", tmpE.director);
								data.put("imgname", tmpE.imgname);
								data.put("likecount", tmpE.likecount);
								data.put("summary", tmpE.summary);
								data.put("subtitle", tmpE.subtitle);
								elist.add(data);
							}
							System.out.println("start banner manager");
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
							System.out.println("start SelectItemData");
							ArrayList<SelectItemData> selmp = SelectItemData.getDataAll();
							for(int i=0;i<selmp.size();i++){
								SelectItemData selmpS = selmp.get(i);
								JSONObject data = new JSONObject();
								data.put("selectid",selmpS.SelectId);
								data.put("price",selmpS.Price);
								data.put("storyid",selmpS.StoryId);
								data.put("epinum",selmpS.Epinum);
								sellist.add(data);
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
							ret.put("selectitemlist",sellist);
							LogManager.writeNorLog(uid, "success_make_uid", cmd, "null","null", 0);
						}else{
							ret.put("error",2);
							LogManager.writeNorLog(uid, "fail_make_uid", cmd, "null","null", 0);
							System.out.println("--insert error -- ");
						}
					}
				}
				LogManager.writeNorLog(uid, "regist_success", cmd, "null","null", 0);
				System.out.println("-----Regi Success-----");
			}else{
				LogManager.writeNorLog("null", "regist_fail", cmd, "null","null", 0);
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
			String token = "";
			JSONArray jlist = new JSONArray();
			JSONArray elist = new JSONArray();
			JSONArray blist = new JSONArray();
			JSONArray clist = new JSONArray();
			JSONArray cdlist = new JSONArray();
			JSONArray cllist = new JSONArray();
			JSONArray olist = new JSONArray();
			JSONArray slist = new JSONArray();
			JSONArray sellist = new JSONArray();
			
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
				token = rs.getString("token");
				
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
					data.put("viewingame",cmpD.viewingame);
					data.put("BFilename",cmpD.BFilename);
					data.put("BSkinname",cmpD.BSkinname);
					data.put("FFilename",cmpD.FFilename);
					data.put("FSkinname",cmpD.FSkinname);
					data.put("HFilename",cmpD.HFilename);
					data.put("HSkinname",cmpD.HSkinname);
					data.put("AFilename",cmpD.AFilename);
					data.put("ASkinname",cmpD.ASkinname);
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
					data.put("writer", tmpE.writer);
					data.put("director", tmpE.director);
					data.put("imgname", tmpE.imgname);
					data.put("likecount", tmpE.likecount);
					data.put("summary", tmpE.summary);
					data.put("subtitle", tmpE.subtitle);
					elist.add(data);
				}
				System.out.println("start banner manager in login");
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
				System.out.println("start Select Manager in login");
				ArrayList<SelectItemData> selmp = SelectItemData.getDataAll();
				for(int i=0;i<selmp.size();i++){
					SelectItemData smp = selmp.get(i);
					JSONObject data = new JSONObject();
					data.put("selectid",smp.SelectId);
					data.put("price",smp.Price);
					data.put("storyid",smp.StoryId);
					data.put("epinum",smp.Epinum);
					System.out.println("data is :"+smp.SelectId+","+smp.Epinum);
					sellist.add(data);
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
			
			System.out.println("start user skin in login");
			
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
			
			System.out.println("start user story in login");
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
				storylist.add(data);
			}
			
			System.out.println("start user name in login");
			
			pstmt = conn.prepareStatement("select Story_id,likecheck from user_storylike where uid = ?");
			pstmt.setString(1, userid);
			JSONArray likelist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("likecheck", rs.getInt(2));
				likelist.add(data);
			}
			/* 
			pstmt = conn.prepareStatement("select Story_id,Episode_num,likestory from user_episodelike where uid = ?");
			pstmt.setString(1, userid);
			JSONArray likelist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId", rs.getString(1));
				data.put("EpisodeNum", rs.getInt(2));
				data.put("LikeNum", rs.getInt(3));
				likelist.add(data);
			}
			 */
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
			
			System.out.println("start user select item in login");
			
			//유저 선택지 구매 정보 로드
			pstmt = conn.prepareStatement("select selectid,storyid,epinum from user_selectitem where uid = ?");
			pstmt.setString(1,userid);
			rs = pstmt.executeQuery();
			JSONArray selectlist = new JSONArray();
			while(rs.next()){
				JSONObject sdata = new JSONObject();
				sdata.put("selectid", rs.getInt(1));
				sdata.put("storyid",rs.getString(2));
				sdata.put("epinum", rs.getInt(3));
				selectlist.add(sdata);
			}
			
			// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
			if (csvserver.equals("on")){
				System.out.println("csvserver : " + csvserver);
				ret.put("chdatalist", cdlist);
				ret.put("chlistlist", cllist);
				ret.put("obdatalist", olist);
				ret.put("soundtablelist", slist);
			}// end of csvserver.equals("on")
			
			ret.put("userstorylikelist", likelist);
			ret.put("userselectlist",selectlist);
			ret.put("namelist",namelist);
			ret.put("userstorylist",storylist);
			ret.put("userskinlist",skinlist);
			ret.put("costumelist",clist);
			ret.put("bannerlist", blist);
			ret.put("episodelist",elist);
			ret.put("categorylist",jlist);
			ret.put("selectitemlist",sellist);
			ret.put("ticket", ticket);
			ret.put("ticketgentime",gentime);
			ret.put("gem",gem);
			ret.put("nowtime",now);
			ret.put("service", service);
			ret.put("token", token);
		}else if(cmd.equals("buyskin")){
			//user skin buy logaction
			
			//int cmd = request.getParameter("cmd");
			int costumeid = Integer.valueOf(request.getParameter("costumeid"));
			//int usercash = Integer.valueOf(request.getParameter("cash"));
			// check user already have this costume
			
			CostumeData data = CostumeData.getData(costumeid);
			int usercash = data.price;
			
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
				int freegem = 0;
				int cashgem = 0;
				int freeticket = 0;
				int cashticket = 0;
				boolean bugFlag = false;
				boolean cashorfree = false;		// cash : true , free : false
				
				pstmt = conn.prepareStatement("select freegem, cashgem, freeticket, cashticket from user where uid = ?");
				pstmt.setString(1, userid);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					freegem = rs.getInt("freegem");
					cashgem = rs.getInt("cashgem");
					freeticket = rs.getInt("freeticket");
					cashticket = rs.getInt("cashticket");
					
					if(cashgem >= usercash) {
						pstmt = conn.prepareStatement("update user set cashgem = cashgem - ? where uid = ?");
						pstmt.setInt(1, usercash);
						pstmt.setString(2, userid);
						cashgem = cashgem - usercash;
						cashorfree = true;
					}
					else {
						if(cashgem == 0) {
							if(freegem >= usercash) {
								pstmt = conn.prepareStatement("update user set freegem = freegem - ? where uid = ?");
								pstmt.setInt(1, usercash);
								pstmt.setString(2, userid);
								freegem = freegem - usercash;
								cashorfree = false;
							}
							else {
								bugFlag = true;
								ret.put("success",0);
								LogManager.writeNorLog(userid, "error", cmd, "gem", "null", usercash);
							}
						}
						else {
							pstmt = conn.prepareStatement("update user set cashgem = cashgem - ? where uid = ?");
							pstmt.setInt(1, cashgem);
							pstmt.setString(2, userid);
							
							if(pstmt.executeUpdate()==1) {
								LogManager.writeNorLog(userid, "success_decrease", cmd, "cashgem", "null", cashgem);
								usercash = usercash - cashgem;
								cashgem = cashgem - cashgem;
								LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);
								pstmt = conn.prepareStatement("update user set freegem = freegem - ? where uid = ?");
								pstmt.setInt(1,	usercash);
								pstmt.setString(2, userid);
								freegem = freegem - usercash;
								cashorfree = false;
							}
							else {
								bugFlag = true;
								ret.put("success",0);
								LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashgem", "null", cashgem);
							}
						}
					}
				}
				
				if(!bugFlag) {					
					if(pstmt.executeUpdate()==1){
						if(cashorfree) {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "cashgem", "null", usercash);
						}
						else {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "freegem", "null", usercash);
						}
						LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);
						
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
							LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
						}	
					}
					else {
						ret.put("success",0);

						if(cashorfree) {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashgem", "null", usercash);
						}
						else {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "freegem", "null", usercash);
						}
					}
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
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
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
					LogManager.writeNorLog(userid, "sucess_buyepi", cmd, "null","null", 0);	
				}
				else {
					ret.put("success", 0);
					LogManager.writeNorLog(userid, "fail_buyepi", cmd, "null","null", 0);
				}
			}
			

			pstmt = conn.prepareStatement("select readcount from episoderead where Story_id = ? and Episode_num = ? ");
			pstmt.setString(1, Storyid);
			pstmt.setInt(2, episodenum);
			rs = pstmt.executeQuery();
			if(rs.next()){
				pstmt = conn.prepareStatement("update episoderead set readcount = readcount + 1 where Story_id = ? and Episode_num = ?");
				pstmt.setString(1, Storyid);
				pstmt.setInt(2, episodenum);
				pstmt.executeUpdate();
			}else{
				pstmt = conn.prepareStatement("insert into episoderead (Story_id,Episode_num) values(?,?)");
				pstmt.setString(1, Storyid);
				pstmt.setInt(2, episodenum);
				pstmt.executeUpdate();
			}
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
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
								LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket", "null", data.reward_ticket);
								ret.put("getticket", 1);
							}
							if (data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "success_increase", cmd, "freegem", "null", data.reward_gem);
							}
							ret.put("success", 1);
							ret.put("reward", 1);
							
							pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
							pstmt.setString(1, userid);
							rs = pstmt.executeQuery();
							if(rs.next()){
								LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
							}
							else {
								if(data.reward_ticket > 0) {
									LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket", "null", data.reward_ticket);
								}
								if(data.reward_gem > 0) {
									LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freegem", "null", data.reward_gem);
								}
							}
						}else{
							if (data.reward_ticket > 0) {
								LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "null", data.reward_ticket);
								ret.put("getticket", 1);
							}
							if (data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "fail_increase", cmd, "freegem", "null", data.reward_gem);
							}
							ret.put("success", 0);
						}
					}else{
						LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
						ret.put("success",0);
					}
				}else{
					LogManager.writeNorLog(userid, "fail_already", cmd, "null","null", 0);
					ret.put("already",1);
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
							LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket", "null", data.reward_ticket);
							ret.put("getticket", 1);
						}
						if (data.reward_gem > 0) {
							LogManager.writeNorLog(userid, "success_increase", cmd, "freegem", "null", data.reward_gem);
						}
						ret.put("success", 1);
						ret.put("reward", 1);
						
						pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
						pstmt.setString(1, userid);
						rs = pstmt.executeQuery();
						if(rs.next()){
							LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
						}
						else {
							if(data.reward_ticket > 0) {
								LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket", "null", data.reward_ticket);
							}
							if(data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freegem", "null", data.reward_gem);
							}
						}
					}else{
						if (data.reward_ticket > 0) {
							LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "null", data.reward_ticket);
							ret.put("getticket", 1);
						}
						if (data.reward_gem > 0) {
							LogManager.writeNorLog(userid, "fail_increase", cmd, "freegem", "null", data.reward_gem);
						}
						ret.put("success", 0);
					}
				}else{
					LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
					ret.put("success",0);
				}
			}
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
				storylist.add(data);
			}
			
			ret.put("userstorylist",storylist);
		}
		else if(cmd.equals("buyepisode")){
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			int ticketValue = Integer.valueOf(request.getParameter("ticket"));
			long ticketGenTime = 0;
			
			pstmt = conn.prepareStatement("select freeticket, cashticket, freegem, cashgem from user where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			
			int freeticket = 0;
			int cashticket = 0;
			int freegem = 0;
			int cashgem = 0;
			boolean bugFlag = false;
			boolean cashorfree = false;		// cash : true , free : false
			
			while(rs.next()){
				freeticket = rs.getInt(1);
				cashticket = rs.getInt(2);
				freegem = rs.getInt(3);
				cashgem = rs.getInt(4);
				
				if (cashticket >= ticketValue) {
					pstmt = conn.prepareStatement("update user set cashticket = cashticket - ? where uid = ?");
					pstmt.setInt(1, ticketValue);
					pstmt.setString(2, userid);
					cashticket = cashticket - ticketValue;
					cashorfree = true;
				}
				else {
					if(cashticket == 0) {
						if(freeticket >= ticketValue){
							pstmt = conn.prepareStatement("update user set freeticket = freeticket - ? where uid = ?");
							pstmt.setInt(1, ticketValue);
							pstmt.setString(2, userid);
							freeticket = freeticket - ticketValue;
							cashorfree = false;
						}
						else {
							bugFlag = true;
							System.out.println("ticket error!");
							LogManager.writeNorLog(userid, "error", cmd, "ticket","null", ticketValue);
						}
					}
					else {
						pstmt = conn.prepareStatement("update user set cashticket = cashticket - ? where uid = ?");
						pstmt.setInt(1, cashticket);
						pstmt.setString(2, userid);
						
						if(pstmt.executeUpdate() == 1) {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "cashticket","null", cashticket);
							ticketValue = ticketValue - cashticket;
							cashticket = cashticket - cashticket;
							LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);
							pstmt = conn.prepareStatement("update user set freeticket = freeticket - ? where uid = ?");
							pstmt.setInt(1, ticketValue);
							pstmt.setString(2, userid);
							freeticket = freeticket - ticketValue;
							cashorfree = false;
						}
						else {
							bugFlag = true;
							System.out.println("ticket error!");
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashticket","null", cashticket);
						}
					}
				}
			}
			
			if (!bugFlag) {
				if(pstmt.executeUpdate() == 1) {
					if(cashorfree) {
						LogManager.writeNorLog(userid, "success_decrease", cmd, "cashticket", "null", ticketValue);
					}
					else {
						LogManager.writeNorLog(userid, "success_decrease", cmd, "freeticket", "null", ticketValue);
					}
					
					LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);

					ret.put("success",1);
					
					pstmt = conn.prepareStatement("select freeticket, cashticket from user where uid = ?");
					pstmt.setString(1,userid);
		
					rs = pstmt.executeQuery();
					
					while(rs.next()){
						int myticket = rs.getInt(1)+rs.getInt(2);
						
						ret.put("myticket", myticket);
						
						if (myticket == 0) {
							pstmt = conn.prepareStatement("update user set ticketgentime = date_add(now(), interval 2 day) where uid = ?");
							pstmt.setString(1, userid);
							
							if(pstmt.executeUpdate()==1){
								
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
								LogManager.writeNorLog(userid, "success_set_gentime", cmd, "null","null", 0);
							}
							else {
								LogManager.writeNorLog(userid, "fail_set_gentime", cmd, "null","null", 0);
							}
						}
						else {
							ret.put("timecheck", 0);
						}
					}
				}
				else {
					ret.put("success",0);
					if(cashorfree) {
						LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashticket", "null", ticketValue);
					}
					else {
						LogManager.writeNorLog(userid, "fail_decrease", cmd, "freeticket", "null", ticketValue);
					}
				}
			}
		}
		else if(cmd.equals("writeuserchoice")){
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			int selectid = Integer.valueOf(request.getParameter("selectid"));
			
			System.out.println("input write user choice"+Storyid+","+episodenum+","+selectid);
			
			//이미 구매한 내역인지 확인한다.
			pstmt = conn.prepareStatement("select * from user_selectitem where uid = ? and selectid = ? and storyid = ? and epinum = ?");
			pstmt.setString(1, userid);
			pstmt.setInt(2, selectid);
			pstmt.setString(3, Storyid);
			pstmt.setInt(4, episodenum);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ret.put("already",1);
			}else{
	
				//먼저 구매내용을 처리한다. 
				//가격을 가져온다.
				//감소를 처리한다.
				//감소에 성공했으면 이후 처리를 시작한다.
				
				List<SelectItemData> slist = SelectItemData.getDataAll();
				SelectItemData data = new SelectItemData();
				for(int i=0;i<slist.size();i++){
					System.out.println("selid is :"+slist.get(i).SelectId+", "+selectid+","+Storyid+","+slist.get(i).StoryId+","+episodenum+","+slist.get(i).Epinum);
					if(slist.get(i).SelectId == selectid&&slist.get(i).StoryId.equals(Storyid)&&slist.get(i).Epinum == episodenum){
						data = slist.get(i);
					}
				}
				System.out.println("data is :"+data.Price+", user is :"+userid);
				if(data.Price == 0){
					System.out.println("no data");
					ret.put("result",2);
				}else{
					pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
					pstmt.setString(1, userid);
					int aftercashgem = 0;
					int afterfreegem = 0;
					int cashtype = 0;
					int beshort = 0;
					int freegem = 0;
					int cashgem = 0;
					int freeticket = 0;
					int cashticket = 0;
					System.out.println("price is :"+data.Price+", "+userid);
					rs = pstmt.executeQuery();
					if(rs.next()){
						freegem = rs.getInt(1);
						cashgem = rs.getInt(2);
						freeticket = rs.getInt(3);
						cashticket = rs.getInt(4);
						System.out.println("price is :"+data.Price+", "+freegem+","+cashgem);
						if(data.Price >freegem+cashgem){
							ret.put("result", 0);//not enough gem
							LogManager.writeNorLog(userid,"not enough gem",cmd,"null","null",0);
						}else{
							if(cashgem >data.Price){ // first use cashgem
								cashtype = 1;
								aftercashgem = cashgem - data.Price;
							}else{ // first cash after free
								beshort = data.Price - cashgem;
								cashtype = 2;
								
								afterfreegem = freegem - beshort;
							}
						}
					}
					
					System.out.println("cash is :"+afterfreegem+", "+beshort+","+aftercashgem);
					
					int upresult = 0;
					
					if(cashtype==1){
						pstmt = conn.prepareStatement("update user set cashgem = ? where uid = ?");
						pstmt.setInt(1, aftercashgem);
						pstmt.setString(2, userid);
						upresult = pstmt.executeUpdate();
					}else if(cashtype==2){
						pstmt = conn.prepareStatement("update user set freegem = ? , cashgem = 0 where uid = ?");
						pstmt.setInt(1,beshort);
						pstmt.setString(2, userid);
						upresult = pstmt.executeUpdate();
					}
					
					System.out.println("result is :"+upresult);
					
					if(upresult == 1){
						if(cashtype == 1) {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",data.Price);
							LogManager.writeCashLog(userid, freeticket, cashticket, freegem, aftercashgem);
						}
						else if(cashtype == 2) {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"success_decrease",cmd,"freegem","null",beshort);
							LogManager.writeCashLog(userid, freeticket, cashticket, afterfreegem, 0);
						}
						
						System.out.println("insert data is :"+userid+","+selectid+","+Storyid+","+episodenum);
						pstmt = conn.prepareStatement("insert into user_selectitem (uid,selectid,storyid,epinum) values(?,?,?,?)");
						pstmt.setString(1, userid);
						pstmt.setInt(2, selectid);
						pstmt.setString(3, Storyid);
						pstmt.setInt(4,episodenum);
						
						if(pstmt.executeUpdate()==1){
							//get user_selectitem
							//유저 선택지 구매 정보 로드
							pstmt = conn.prepareStatement("select selectid,storyid,epinum from user_selectitem where uid = ?");
							pstmt.setString(1,userid);
							rs = pstmt.executeQuery();
							JSONArray selectlist = new JSONArray();
							while(rs.next()){
								JSONObject sdata = new JSONObject();
								sdata.put("selectid", rs.getInt(1));
								sdata.put("storyid",rs.getString(2));
								sdata.put("epinum", rs.getInt(3));
								System.out.println("my data is :"+rs.getInt(1)+", "+rs.getString(2)+","+rs.getInt(3));
								selectlist.add(sdata);
							}
							LogManager.writeNorLog(userid,"sucess_write_userchoice",cmd,"null","null",0);
							ret.put("userselectlist",selectlist);
							ret.put("result",1);
							
						}else{
							ret.put("result",2);
							LogManager.writeNorLog(userid,"fail_buy_choice",cmd,"null","null",0);
						}
					}
					else {
						if(cashtype == 1) {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",data.Price);
						}
						else if(cashtype == 2) {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"freegem","null",beshort);
						}
					}
				}
			}
			
		}
		else if(cmd.equals("ticketcharge")) {
			
			long ticketGenTime = 0;
			
			pstmt = conn.prepareStatement("select ticketgentime,now() from user where uid = ?");
			pstmt.setString(1,userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				ticketGenTime = rs.getTimestamp(1).getTime()/1000;
				now = rs.getTimestamp(2).getTime()/1000;
				
				if(ticketGenTime < now) {
					System.out.println("charge success");
					pstmt = conn.prepareStatement("update user set freeticket = freeticket + 1 where uid = ?");
					pstmt.setString(1, userid);
					
					if(pstmt.executeUpdate()>0){
						LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket","null", 1);
						ret.put("nocharge", 1);
						ret.put("success", 1);
						
						pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
						pstmt.setString(1, userid);
						rs = pstmt.executeQuery();
						
						if(rs.next()) {
							LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
						}
						else {
							LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket","null", 1);
						}
					}
					else {
						LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket","null", 1);
						ret.put("nocharge", 1);
						ret.put("success", 0);
					}
				}
				else {
					System.out.println("need more time");
					ret.put("nocharge", 0);
					ret.put("now", now);
				}
			}
		}
		else if(cmd.equals("checkgem")) {
			int costumeid = Integer.valueOf(request.getParameter("costumeid"));
	
			CostumeData data = CostumeData.getData(costumeid);
			int price = data.price;
	
			pstmt = conn.prepareStatement("select freegem, cashgem from user where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int mygem = rs.getInt(1)+rs.getInt(2);
				
				if (mygem < price) {
					ret.put("success", 0);
				}
				else {
					ret.put("success", 1);
				}
			}
		}
		else if(cmd.equals("tutorial")) {
	
			JSONArray tlist = new JSONArray();
			
			ArrayList<TutorialList> emp = TutorialList.getDataAll();
			for(int i=0;i<emp.size();i++){
				TutorialList tmpE = emp.get(i);
				JSONObject data = new JSONObject();
				data.put("StoryID", tmpE.Story_id);
				data.put("EpisodeNum", tmpE.episode_num);
				data.put("Summary", tmpE.summary);
				tlist.add(data);
			}
			
			ret.put("tutoriallist", tlist);
		}
		else if(cmd.equals("buyadpass")){
			// check adpass count and date
			int passprice = 10;
			
			pstmt = conn.prepareStatement("select adpass,adpasscount,freegem,cashgem,freeticket,cashticket from user where uid = ?");
			pstmt.setString(1, userid);
			
			boolean passlive = false;
			long livetime = 24*31*60*60;			
			int freegem = 0;
			int cashgem = 0;
			int freeticket = 0;
			int cashticket = 0;
			
			rs = pstmt.executeQuery();
			if(rs.next()){
				long adpasstime = rs.getTimestamp(1).getTime()/1000;
				int adpasscount = rs.getInt(2);
				freegem = rs.getInt(3);
				cashgem = rs.getInt(4);
				freeticket = rs.getInt(5);
				cashticket = rs.getInt(6);
				
				if(adpasscount==1&&adpasstime+livetime>=now){
					passlive = true;
				}
				LogManager.writeNorLog(userid,"checkadpass",cmd,"null","null",0);
			}
			
			if(!passlive){
				//check user gem
				boolean cashorfree = false;			// cash : true, free : false
				if(freegem+cashgem>=passprice){
					int aftercash = 0;
					int afterfree = 0;
					if(cashgem>=passprice){
						aftercash = cashgem-passprice;
						afterfree = freegem;
						cashorfree = true;
					}else{
						aftercash = 0;
						afterfree = freegem - (passprice - cashgem);
						cashorfree = false;
					}
					pstmt = conn.prepareStatement("update user set adpass = now(), adpasscount = 1, cashgem = ?, freegem = ? where uid = ?");
					pstmt.setInt(1, aftercash);
					pstmt.setInt(2, afterfree);
					pstmt.setString(3, userid);
					if(pstmt.executeUpdate()==1){
						ret.put("result", 1);
						
						if(cashorfree) {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",passprice);
						}
						else {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"success_decrease",cmd,"freegem","null",passprice-cashgem);
						}
						
						LogManager.writeCashLog(userid, freeticket, cashticket, afterfree, aftercash);
					}
					else {
						if(cashorfree) {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",passprice);
						}
						else {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"freegem","null",passprice-cashgem);
						}
					}
				}else{
					LogManager.writeNorLog(userid,"fail_money",cmd,"null","null",0);
					ret.put("result",0);//not enough money
				}
			}else{
				LogManager.writeNorLog(userid,"fail_already",cmd,"null","null",0);
				ret.put("already", 1);
			}
			
			// update adpass and date
			// send result
		}
		else if(cmd.equals("checkadpass")){
			// check adpass count and date
			pstmt = conn.prepareStatement("select adpass,adpasscount from user where uid = ?");
			pstmt.setString(1, userid);
			
			boolean passlive = false;
			long livetime = 24*31*60*60;
			rs = pstmt.executeQuery();
			if(rs.next()){
				long adpasstime = rs.getTimestamp(1).getTime()/1000;
				int adpasscount = rs.getInt(2);
				if(adpasscount==1&&adpasstime+livetime>=now){
					passlive = true;
				}
			}
			if(passlive){
				ret.put("result",1);
			}else{
				ret.put("result",0);
			}
			// update adpass
			// send result
		}
		else if(cmd.equals("likestory")){
			String storyid = request.getParameter("storyid");
			
			pstmt = conn.prepareStatement("select likecheck from user_storylike where uid = ? and Story_id = ?");
			pstmt.setString(1, userid);
			pstmt.setString(2, storyid);
			rs = pstmt.executeQuery();
			boolean result = false;
			if(rs.next()){ //update
				int likecheck = rs.getInt(1);
				if(likecheck==0){ //update 1
					pstmt = conn.prepareStatement("update user_storylike set likecheck = 1 where uid = ? and Story_id = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2, storyid);
					if(pstmt.executeUpdate()==1){
						result = true;
					}
				}else{ //update 0
					pstmt = conn.prepareStatement("update user_storylike set likecheck = 0 where uid = ? and Story_id = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2, storyid);
					if(pstmt.executeUpdate()==1){
						result = true;
					}
				}
			}else{ //insert 1
				pstmt = conn.prepareStatement("insert into user_storylike (Story_id,uid,likecheck) values(?,?,1)");
				pstmt.setString(1, storyid);
				pstmt.setString(2, userid);
				if(pstmt.executeUpdate()==1){
					result = true;
				}
			}
			
			pstmt = conn.prepareStatement("select Story_id,likecheck from user_storylike where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();

			JSONArray Playerlikelist = new JSONArray();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("likecheck", rs.getInt(2));
				Playerlikelist.add(data);
			}
			
			pstmt = conn.prepareStatement("select Story_id,sum(likecheck) from user_storylike group by Story_id");
			rs = pstmt.executeQuery();
			
			JSONArray likelist = new JSONArray();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("LikeCount", rs.getInt(2));
				likelist.add(data);
			}
			
			ret.put("likelist",likelist);
			ret.put("Playerlikelist", Playerlikelist);
			
			if(result){
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
				ret.put("result",1);
			}else{
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
				ret.put("result", 0);
			}
			
		}
		else if(cmd.equals("getresourceversion")){
			JSONArray rlist = new JSONArray();
			
			pstmt = conn.prepareStatement("select AssetBundleName,version from AssetBundleVersion");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				JSONObject data = new JSONObject();
				System.out.println("name is :"+rs.getString(1)+", version is :"+rs.getInt(2));
				data.put("AssetBundleName",rs.getString(1));
				data.put("version",rs.getInt(2));
				rlist.add(data);
			}
			ret.put("resourceversion",rlist);
		}

		else if(cmd.equals("question")) {
			//send question
			String email = request.getParameter("email");
			String subject = request.getParameter("subject");
			String contents = request.getParameter("contents");
			
			pstmt = conn.prepareStatement("insert into question (uid,email,subject,contents,date) values(?,?,?,?,now())");
			pstmt.setString(1, userid);
			pstmt.setString(2, email);
			pstmt.setString(3, subject);
			pstmt.setString(4, contents);
			
			int checker = pstmt.executeUpdate();
			
			if(checker==1){
				ret.put("success", 1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}
			else {
				ret.put("success", 0);
				LogManager.writeNorLog(userid,"fail",cmd,"null","null",0);
			}
		}
		
		else if(cmd.equals("likerefresh")) {
			JSONArray likecountlist = new JSONArray();
			
			pstmt = conn.prepareStatement("select Story_id, sum(likecheck) from user_storylike group by Story_id");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("LikeCount", rs.getInt(2));
				likecountlist.add(data);
			}
			
			ret.put("likecountlist", likecountlist);
			
			ret.put("result", 1);//normal progress
			LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
		}
		
		out.print(ret.toString());

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
		
	}
%>