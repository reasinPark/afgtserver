<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.shopManager" %>
<%@ page import="com.wingsinus.ep.AdminUserCash" %>


<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유저 보유 재화 카운트</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유저들이 소비하지 않고 들고 있는 티켓/젬의 총합 (매일 04:00 에 기록됩니다.)</H3>
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

	<form action="indicator_user_cash.jsp" method="post">
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
		<input type="hidden" name="type" value="user_cash">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_cash">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminUserCash> list = new ArrayList<AdminUserCash>();
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_cash.csv";
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
				AdminUserCash auc = new AdminUserCash();
				auc.date = String.valueOf(rs.getString(1));
				auc.freeticket = "0";
				auc.cashticket = "0";
				auc.totalticket = "0";
				auc.freegem = "0";
				auc.cashgem = "0";
				auc.totalgem = "0";
				list.add(auc);
			}

			conn = ConnectionProvider.getConnection("logdb");
			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d'), freeticket, cashticket, totalticket, freegem, cashgem, totalgem from cash_status where regdate between ? and ?");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("날짜");
			fw.append(',');
			fw.append("전체 무료 티켓");
			fw.append(',');
			fw.append("전체 유료 티켓");
			fw.append(',');
			fw.append("총 티켓");
			fw.append(',');
			fw.append("전체 무료 젬");
			fw.append(',');
			fw.append("전체 유료 젬");
			fw.append(',');
			fw.append("총 젬");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>날짜</td>
					<td>전체 무료 티켓</td>
					<td>전체 유료 티켓</td>
					<td>총 티켓</td>
					<td>전체 무료 젬</td>
					<td>전체 유료 젬</td>
					<td>총 젬</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = rs.getString(1);
				String freeticket = String.valueOf(rs.getInt(2));
				String cashticket = String.valueOf(rs.getInt(3));
				String totalticket = String.valueOf(rs.getInt(4));
				String freegem = String.valueOf(rs.getInt(5));
				String cashgem = String.valueOf(rs.getInt(6));
				String totalgem = String.valueOf(rs.getInt(7));
				
				for(int i = 0; i<list.size();i++) {
					if(list.get(i).date.equals(date)) {
						list.get(i).freeticket = freeticket;
						list.get(i).cashticket = cashticket;
						list.get(i).totalticket = totalticket;
						list.get(i).freegem = freegem;
						list.get(i).cashgem = cashgem;
						list.get(i).totalgem = totalgem;
						break;
					}
				}
			}
			
			for(int j = 0; j<list.size();j++) {

				fw.append(list.get(j).date);
				fw.append(',');
				fw.append(list.get(j).freeticket);
				fw.append(',');
				fw.append(list.get(j).cashticket);
				fw.append(',');
				fw.append(list.get(j).totalticket);
				fw.append(',');
				fw.append(list.get(j).freegem);
				fw.append(',');
				fw.append(list.get(j).cashgem);
				fw.append(',');
				fw.append(list.get(j).totalgem);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=list.get(j).date%></td>
					<td><%=list.get(j).freeticket%></td>
					<td><%=list.get(j).cashticket%></td>
					<td><%=list.get(j).totalticket%></td>
					<td><%=list.get(j).freegem%></td>
					<td><%=list.get(j).cashgem%></td>
					<td><%=list.get(j).totalgem%></td>
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