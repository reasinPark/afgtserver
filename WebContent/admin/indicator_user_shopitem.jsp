<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>

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
	
	conn = ConnectionProvider.getConnection("logdb");
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
			
			pstmt = conn.prepareStatement("select date_format(regdate,'%Y-%m-%d'), title, pid, count from user_shopitem where regdate between ? and ?");
			
			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
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
				String title = rs.getString(2);
				String pid = rs.getString(3);
				String count = String.valueOf(rs.getInt(4));
				
				fw.append(date);
				fw.append(',');
				fw.append(title);
				fw.append(',');
				fw.append(pid);
				fw.append(',');
				fw.append(count);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=date%></td>
					<td><%=title%></td>
					<td><%=pid%></td>
					<td><%=count%></td>
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