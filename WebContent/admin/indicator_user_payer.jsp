<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminDateCount" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유료 결제자 수</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 날짜에 유료 결제를 한 유니크한 유저 숫자</H3>
</section>
	<%
	String filepath = "";
	String filename = "";
	FileWriter fw = null;
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
	pstmt = conn.prepareStatement("select date_format(now(),'%Y-%m-%d')");
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		today = rs.getString(1);
	}
	
	if((startdate!=null) && (enddate!=null)) {
		isfirst = true;
	}
	
	%>

	<form action="indicator_user_payer.jsp" method="post">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> 시작 날짜 </td>
				<td><input type="date" id="startdate" name="startdate" value="<%=((isfirst)? startdate : "2018-01-01")%>" /></td>
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
		<input type="hidden" name="type" value="payer">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_payer">
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
			
			filename = "user_payer.csv";
			fw = new FileWriter(filepath+filename);
			
			conn = ConnectionProvider.getConnection("logdb");
			
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
				AdminDateCount adc = new AdminDateCount();
				adc.date = String.valueOf(rs.getString(1));
				adc.count = "0";
				list.add(adc);
			}
			
			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d') m, count(distinct uid) from log_action where regdate between " +
										  "? and ? and action_type = 'success_increase' and action_name = 'buyitem' group by m;");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("날짜");
			fw.append(',');
			fw.append("결제자 수");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>날짜</td>
					<td>결제자 수</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = String.valueOf(rs.getString(1));
				String count = String.valueOf(rs.getInt(2));
				
				for(int i = 0; i<list.size();i++) {
					if(date.equals(list.get(i).date)) {
						list.get(i).count = count;
						break;
					}
				}
			}
			
			for(int j = 0; j<list.size();j++) {

				fw.append(list.get(j).date);
				fw.append(',');
				fw.append(list.get(j).count);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=list.get(j).date%></td>
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