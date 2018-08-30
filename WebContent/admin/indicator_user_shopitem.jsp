<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.shopManager" %>
<%@ page import="com.wingsinus.ep.AdminShopItem" %>


<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;상품별 구매 카운트</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;티켓/젬 상품 코드별 유저 구매 카운트</H3>
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

	<form action="indicator_user_shopitem.jsp" method="post">
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
		<input type="hidden" name="type" value="shopitem">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_shopitem">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminShopItem> list = new ArrayList<AdminShopItem>();
			ArrayList<shopManager> shopitemlist = shopManager.getDataAll();
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_shopitem.csv";
			fw = new FileWriter(filepath+filename);
			
			pstmt = conn.prepareStatement("select * from (select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date from "+
										  "(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, " +
										  "(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, " +
										  "(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, " +
										  "(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, " +
										  "(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v " +
										  "where selected_date between ? and ?");
			
			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				for (int i=0;i<shopitemlist.size();i++) {
					AdminShopItem asi = new AdminShopItem();
					asi.date = String.valueOf(rs.getString(1));
					asi.title = shopitemlist.get(i).title;
					asi.pid = shopitemlist.get(i).PID_android;
					asi.count = "0";
					list.add(asi);
				}
			}

			conn = ConnectionProvider.getConnection("logdb");
			pstmt = conn.prepareStatement("select date_format(regdate,'%Y-%m-%d') m ,item, count(item) as cnt from log_action where action_type = 'success_increase' " +
										  "and action_name = 'buyitem' and regdate between ? and ? group by item, m order by m");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("날짜");
			fw.append(',');
			fw.append("상품명");
			fw.append(',');
			fw.append("PID");
			fw.append(',');
			fw.append("구매 횟수");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>날짜</td>
					<td>상품명</td>
					<td>PID</td>
					<td>구매 횟수</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = rs.getString(1);
				String item = rs.getString(2);
				String count = String.valueOf(rs.getInt(3));
				
				for(int i = 0; i<list.size();i++) {
					if(list.get(i).date.equals(date) && list.get(i).pid.equals(item)) {
						list.get(i).count = count;
						break;
					}
				}
			}
			
			for(int j = 0; j<list.size();j++) {

				fw.append(list.get(j).date);
				fw.append(',');
				fw.append(list.get(j).title);
				fw.append(',');
				fw.append(list.get(j).pid);
				fw.append(',');
				fw.append(list.get(j).count);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=list.get(j).date%></td>
					<td><%=list.get(j).title%></td>
					<td><%=list.get(j).pid%></td>
					<td><%=list.get(j).count%></td>
				</tr>
				<%
			}
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