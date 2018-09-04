<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminDateCount" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2,7,30일자 리텐션</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전일자/6일전/29일전 로그인 유저중 해당 날짜 로그인한 유니크 유저 숫자</H3>
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

	<form action="indicator_user_retention.jsp" method="post">
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
		<input type="hidden" name="type" value="retention">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_retention">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminDateCount> list = new ArrayList<AdminDateCount>();
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_retention.csv";
			fw = new FileWriter(filepath+filename);
			
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("select date_format(date, '%Y-%m-%d'), day0, day1, day6, day29 from retention where date between " +
										  "? and ?");
			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("기준일");
			fw.append(',');
			fw.append("DAY0");
			fw.append(',');
			fw.append("DAY1");
			fw.append(',');
			fw.append("DAY6");
			fw.append(',');
			fw.append("DAY29");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>기준일</td>
					<td>DAY0</td>
					<td>DAY1</td>
					<td>DAY6</td>
					<td>DAY29</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = String.valueOf(rs.getString(1));
				String day0 = String.valueOf(rs.getInt(2));
				String day1 = String.valueOf(rs.getInt(3));
				String day6 = String.valueOf(rs.getInt(4));
				String day29 = String.valueOf(rs.getInt(5));
				
				fw.append(date);
				fw.append(',');
				fw.append(day0);
				fw.append(',');
				fw.append(day1);
				fw.append(',');
				fw.append(day6);
				fw.append(',');
				fw.append(day29);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=date%></td>
					<td><%=day0%></td>
					<td><%=day1%></td>
					<td><%=day6%></td>
					<td><%=day29%></td>
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