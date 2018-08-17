<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminShopItem" %>
<%
	boolean isselected = false;
	String type = request.getParameter("type");

	String filepath = "";
	String filename = "";
	FileWriter fw = null;
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;
	
	try {
		if(ConnectionProvider.afgt_build_ver == 0) {
			filepath = "/usr/share/tomcat6/webapps/tempcsv/";
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
		}
				
		if(type == null) {
			
		}
		else {
			isselected = true;
		}
	%>
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재화 데이터 보기</H2>
		
		<form action="cashinfo.jsp">
			<label for = "type">보고 싶은 데이터를 선택해주세요.</label><br>
			<input type = "radio" name = "type" value = "shopitemcount"> 상품별 구매 카운트(샵기준) <br>
			<input type = "radio" name = "type" value = "userticketcount"> 유저 보유 티켓 카운트 <br>
			<input type = "radio" name = "type" value = "usergemcount"> 유저 보유 젬 카운트 <br>
			<input type = "submit" value ="선택 완료">
		</form>
		<br>
		
		<%if(isselected) {
			if(type.equals("shopitemcount")) {
				%>	
				<tr>
					<td> 상품별 구매 카운트(샵기준) </td>
				</tr>
				
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="shopitemcount">
					<input type ="submit" value ="다운로드">
				</form>
				
				<%
				filename = "shopitemcount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				ArrayList<AdminShopItem> list = new ArrayList<AdminShopItem>();
				pstmt = conn.prepareStatement("select title, PID_android from shop_item");
				rs = pstmt.executeQuery();
				while(rs.next()) {
					AdminShopItem data = new AdminShopItem();
					data.title = rs.getString(1);
					data.pid = rs.getString(2);
					
					list.add(data);
				}
				
				fw.append("id");
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
						<td>id</td>
						<td>상품명</td>
						<td>PID</td>
						<td>구매 횟수</td>
					</tr>
				<%
	
				conn = ConnectionProvider.getConnection("logdb");
				for(int i=0;i<list.size();i++) {
					pstmt = conn.prepareStatement("select count(point) from log_action where action_type = 'success_increase' and action_name = 'buyitem' and point = ?");
					pstmt.setString(1, list.get(i).pid);
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						fw.append(String.valueOf(i+1));
						fw.append(',');
						fw.append(list.get(i).title);
						fw.append(',');
						fw.append(list.get(i).pid);
						fw.append(',');
						fw.append(String.valueOf(rs.getInt(1)));
						fw.append('\n');
						
						%> 
						<tr>
							<td><%=i+1%></td>
							<td><%=list.get(i).title%></td>
							<td><%=list.get(i).pid%></td>
							<td><%=String.valueOf(rs.getInt(1))%></td>
						</tr>
						<%
					}
					else {
						fw.append(String.valueOf(i+1));
						fw.append(',');
						fw.append(list.get(i).title);
						fw.append(',');
						fw.append(list.get(i).pid);
						fw.append(',');
						fw.append("0");
						fw.append('\n');
						
						%>
						<tr>
							<td><%=i+1%></td>
							<td><%=list.get(i).title%></td>
							<td><%=list.get(i).pid%></td>
							<td><%=0%></td>
						</tr>
						<%
					}
				}
				%>
				</table>
				<%
			%>
			
		<%	}
			else if(type.equals("userticketcount")) {
				%>
				<tr>
					<td> 유저 보유 티켓 카운트 </td>
				</tr>
				
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="userticketcount">
					<input type ="submit" value ="다운로드">
				</form>
				
				<% 
				filename = "userticketcount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				pstmt = conn.prepareStatement("select sum(freeticket), sum(cashticket) from user where active = 1");
				rs = pstmt.executeQuery();
				while(rs.next()) {
					
					int freeticket = rs.getInt(1);
					int cashticket = rs.getInt(2);
					
					fw.append("프리 티켓 수");
					fw.append(',');
					fw.append("캐쉬 티켓 수");
					fw.append(',');
					fw.append("총 티켓 수");
					fw.append('\n');
					
					fw.append(String.valueOf(freeticket));
					fw.append(',');
					fw.append(String.valueOf(cashticket));
					fw.append(',');
					fw.append(String.valueOf(freeticket+cashticket));
					fw.append('\n');
					
					%>
					<table border="1" style="border-style:solid;">
						<tr>
							<td>프리 티켓 수</td>
							<td>캐쉬 티켓 수</td>
							<td>총 티켓 수</td>
						</tr>
						<tr>
							<td><%=freeticket%></td>
							<td><%=cashticket%></td>
							<td><%=freeticket + cashticket%></td>
						</tr>
					</table>
					<%
				}
			%>
		<%	}
			else if(type.equals("usergemcount")) {
				%>	
				<tr>
					<td> 유저 보유 젬 카운트 </td>
				</tr>
				
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="usergemcount">
					<input type ="submit" value ="다운로드">
				</form>
				
				<% 
				filename = "usergemcount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				pstmt = conn.prepareStatement("select sum(freegem), sum(cashgem) from user where active = 1");
				rs = pstmt.executeQuery();
				while(rs.next()) {

					int freegem = rs.getInt(1);
					int cashgem = rs.getInt(2);
					
					fw.append("프리 젬 수");
					fw.append(',');
					fw.append("캐쉬 젬 수");
					fw.append(',');
					fw.append("총 젬 수");
					fw.append('\n');
					
					fw.append(String.valueOf(freegem));
					fw.append(',');
					fw.append(String.valueOf(cashgem));
					fw.append(',');
					fw.append(String.valueOf(freegem+cashgem));
					fw.append('\n');
					
					%>
					<table border="1" style="border-style:solid;">
						<tr>
							<td>프리 젬 수</td>
							<td>캐쉬 젬 수</td>
							<td>총 젬 수</td>
						</tr>
						<tr>
							<td><%=freegem%></td>
							<td><%=cashgem%></td>
							<td><%=freegem + cashgem%></td>
						</tr>
					</table>
					<%
				}
			}

			fw.flush();
			fw.close();
		}
		
	}catch(Exception e){
		
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>