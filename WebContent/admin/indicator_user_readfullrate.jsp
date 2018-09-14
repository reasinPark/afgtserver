<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminStory" %>
<%@ page import="com.wingsinus.ep.AdminStoryReadCount" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;완독률</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스토리 별 완독률 (연재된 최종화 누적 조회수/연재된 전체 화 누적 조회수)</H3>
</section>
	<%
	String filepath = "";
	String filename = "";
	FileWriter fw = null;
	String lastweek = "";
	String today = "";
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;

	String type = request.getParameter("type");
	String startdate = request.getParameter("startdate");
	String enddate = request.getParameter("enddate");
	boolean isfirst = false;
	
	conn = ConnectionProvider.getConnection("afgt");
	pstmt = conn.prepareStatement("select date_format(date_add(now(), interval -7 day),'%Y-%m-%d'),date_format(now(),'%Y-%m-%d')");
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		lastweek = rs.getString(1);
		today = rs.getString(2);
	}
	
	if((startdate!=null) && (enddate!=null)) {
		isfirst = true;
	}
	%>

	<form action="indicator_user_readfullrate.jsp" method="post">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> 시작 날짜 </td>
				<td><input type="date" id="startdate" name="startdate" value="<%=((isfirst)? startdate : lastweek)%>" /></td>
			</tr>
			<tr>
				<td> 끝 날짜 </td>
				<td><input type="date" id="enddate" name="enddate" value="<%=((isfirst)? enddate : today)%>" /></td>
			</tr>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="검색" /> </td>
			</tr>
		</table>
		<input type="hidden" name="type" value="readfullrate">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_readfullrate">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminStoryReadCount> list = new ArrayList<AdminStoryReadCount>();
			ArrayList<AdminStory> titlelist = new ArrayList<AdminStory>();
			ArrayList<AdminStoryReadCount> totalepisodelist = new ArrayList<AdminStoryReadCount>();
			
			pstmt = conn.prepareStatement("select Story_id, title from story");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AdminStory data = new AdminStory();
				data.Story_id = rs.getString(1);
				data.title = rs.getString(2);
				
				titlelist.add(data);
			}
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_readfullrate.csv";
			fw = new FileWriter(filepath+filename);

			conn = ConnectionProvider.getConnection("logdb");
			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d'), storyid, maxepinum from info_episode where regdate between ? and ?");
			
			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String date = rs.getString(1);
				String storyid = rs.getString(2);
				int maxepinum = rs.getInt(3);
								
				for(int i=0;i<maxepinum;i++) {
					AdminStoryReadCount asrc = new AdminStoryReadCount();
					asrc.date = date;
					asrc.storyid = storyid;
					asrc.episodenum = i + 1;
					asrc.count = 0;
					list.add(asrc);
				}
			}
			
			pstmt = conn.prepareStatement("select * from info_episode where regdate between date_format(date_add(now(), interval -1 day), '%Y-%m-%d 00:00:00')" +
					  "and date_format(date_add(now(), interval -1 day), '%Y-%m-%d 23:59:59')");
			rs = pstmt.executeQuery();

			while(rs.next()) {
				String date = rs.getString(1);
				String storyid = rs.getString(2);
				int maxepinum = rs.getInt(3);
								
				for(int i=0;i<maxepinum;i++) {
					AdminStoryReadCount asrc = new AdminStoryReadCount();
					asrc.date = date;
					asrc.storyid = storyid;
					asrc.episodenum = i + 1;
					asrc.count = 0;
					totalepisodelist.add(asrc);
				}
			}

			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d'), storyid, episodenum, count from story_readcount " +
										  "where regdate between ? and ?");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("날짜");
			fw.append(',');
			fw.append("스토리명");
			fw.append(',');
			fw.append("완독률");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>날짜</td>
					<td>스토리명</td>
					<td>완독률</td>
				</tr>
			<%
			/*
			while(rs.next()) {
				String date = rs.getString(1);
				String storyid = rs.getString(2);
				int epinum = rs.getInt(3);
				int count = rs.getInt(4);
				
				for(int i = 0; i<list.size();i++) {
					if(list.get(i).date.equals(date) && list.get(i).storyid.equals(storyid) && list.get(i).episodenum == epinum) {
						list.get(i).count = count;
						break;
					}
				}
			}
			
			String currentdate = "";
			
			for(int i=0;i<list.size();i++) {
				for(int j=0;j<totalepisodelist.size();j++) {
					if(list.get(i).storyid.equals(totalepisodelist.get(j).storyid) && (list.get(i).episodenum == totalepisodelist.get(j).episodenum)) {
						totalepisodelist.get(j).count = totalepisodelist.get(j).count + list.get(i).count;
					}
				}
				
				if(i+1 ==list.size()) {
					
				}
				else {
					if(list.get(i).storyid != list.get(i+1).date) {
						
					}
				}
			}
			*/
		
			%>
			</table>
			<%
			
			fw.flush();
			fw.close();
		}
	}
	catch(Exception e) {
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>