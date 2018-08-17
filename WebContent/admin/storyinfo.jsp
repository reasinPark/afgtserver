<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminStory" %>
<%@ page import="com.wingsinus.ep.AdminCostume" %>
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
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이야기 데이터 보기</H2>
		
		<form action="storyinfo.jsp">
			<label for = "type">보고 싶은 데이터를 선택해주세요.</label><br>
			<input type = "radio" name = "type" value = "storyreadcount"> 이야기별 읽은 수 <br>
			<input type = "radio" name = "type" value = "skincount"> 패션상품별 아이템 구매 횟수 <br>
			<input type = "radio" name = "type" value = "storyskincount"> 이야기별 패션 아이템 구매 횟수 <br>
			<input type = "radio" name = "type" value = "bothreading"> 이야기별 같이 읽은 이야기 카운트 <br>
			<input type = "radio" name = "type" value = "payerbuystory"> 이야기별 유료패션 구매자가 같이 유료패션 구매한 이야기 유니크 카운트 <br>
			<input type = "radio" name = "type" value = "payerreadstory"> 이야기별 유료 패션 구매자가 동일 스토리를 반복 감상한 회차 <br>
			<input type = "radio" name = "type" value = "storylastread"> 이야기별 최종 읽은 라인 <br>
			<input type = "radio" name = "type" value = "averagelastread"> 전체 유저 이야기별 화별 최종 읽은 라인 <br>
			<input type = "submit" value ="선택 완료">
		</form>
		<br>
		
		<%if(isselected) {
			if(type.equals("storyreadcount")) {
				%>
				<tr>
					<td> 이야기별 읽은 수 </td>
				</tr>
				
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="storyreadcount">
					<input type ="submit" value ="다운로드">
				</form>
				<br>
				<%
				filename = "storyreadcount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				ArrayList<AdminStory> list = new ArrayList<AdminStory>();
				pstmt = conn.prepareStatement("select Story_id, title from story");
				rs = pstmt.executeQuery();
				while(rs.next()) {
					
					AdminStory data = new AdminStory();
					data.Story_id = rs.getString(1);
					data.title = rs.getString(2);
					
					list.add(data);
				}
				
				fw.append("스토리 아이디");
				fw.append(',');
				fw.append("제목");
				fw.append(',');
				fw.append("조회 수");
				fw.append('\n');
				
				%>
					<table border="1" style="border-style:solid;">
						<tr>
							<td>스토리 아이디</td>
							<td>제목</td>
							<td>조회 수</td>
						</tr>
				<%
				for(int i=0;i<list.size();i++) {
					pstmt = conn.prepareStatement("select sum(readcount) from episoderead where Story_id = ?");
					pstmt.setString(1, list.get(i).Story_id);
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						fw.append(list.get(i).Story_id);
						fw.append(',');
						fw.append(list.get(i).title);
						fw.append(',');
						fw.append(String.valueOf(rs.getInt(1)));
						fw.append('\n');
						%> 
							<tr>
								<td><%=list.get(i).Story_id%></td>
								<td><%=list.get(i).title%></td>
								<td><%=String.valueOf(rs.getInt(1)) %></td>
							</tr>
						<%
					}
					else {
						fw.append(list.get(i).Story_id);
						fw.append(',');
						fw.append(list.get(i).title);
						fw.append(',');
						fw.append("0");
						fw.append('\n');
						%>
							<tr>
								<td><%=list.get(i).Story_id%></td>
								<td><%=list.get(i).title%></td>
								<td><%=0%></td>
							</tr>
						<%
					}
				}
				%>
				</table>
		<%	}
			else if(type.equals("skincount")) {
			%>
				<tr>
					<td> 패션상품별 아이템 구매 횟수 </td>
				</tr>
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="skincount">
					<input type ="submit" value ="다운로드">
				</form>
				<br>
			<% 
				filename = "skincount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				ArrayList<AdminCostume> list = new ArrayList<AdminCostume>();
				pstmt = conn.prepareStatement("select CostumeId, name, storyid from CostumeData");
				rs = pstmt.executeQuery();
				while(rs.next()) {
					AdminCostume data = new AdminCostume();
					data.CostumeId = rs.getInt(1);
					data.name = rs.getString(2);
					data.Story_id = rs.getString(3);
					
					list.add(data);
				}
				
				fw.append("상품 아이디");
				fw.append(',');
				fw.append("상품 명");
				fw.append(',');
				fw.append("출현 스토리 아이디");
				fw.append(',');
				fw.append("구매 횟수");
				fw.append('\n');
				
				%>
				<table border="1" style="border-style:solid;">
					<tr>
						<td>상품 아이디</td>
						<td>상품 명</td>
						<td>출현 스토리 아이디</td>
						<td>구매 횟수</td>
					</tr>
				<%
				conn = ConnectionProvider.getConnection("logdb");
				
				for(int i=0;i<list.size();i++) {
					pstmt = conn.prepareStatement("select count(item) from log_action where action_type = 'success' and action_name = 'buyskin' and item = ?");
					pstmt.setString(1, String.valueOf(list.get(i).CostumeId));
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						fw.append(String.valueOf(list.get(i).CostumeId));
						fw.append(',');
						fw.append(list.get(i).name);
						fw.append(',');
						fw.append(list.get(i).Story_id);
						fw.append(',');
						fw.append(String.valueOf(rs.getInt(1)));
						fw.append('\n');
						
						%> 
						<tr>
							<td><%=list.get(i).CostumeId%></td>
							<td><%=list.get(i).name%></td>
							<td><%=list.get(i).Story_id%></td>
							<td><%=String.valueOf(rs.getInt(1))%></td>
						</tr>
						<%
					}
					else {
						fw.append(String.valueOf(list.get(i).CostumeId));
						fw.append(',');
						fw.append(list.get(i).name);
						fw.append(',');
						fw.append(list.get(i).Story_id);
						fw.append(',');
						fw.append("0");
						fw.append('\n');
						%>
						<tr>
							<td><%=list.get(i).CostumeId%></td>
							<td><%=list.get(i).name%></td>
							<td><%=list.get(i).Story_id%></td>
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
			else if(type.equals("storyskincount")) {
			%>	
				<tr>
					<td> 이야기별 패션 아이템 구매횟수 </td>
				</tr>
				<form action="csvfiledownload.jsp" method="post">
					<input type="hidden" name="filename" value="storyskincount">
					<input type ="submit" value ="다운로드">
				</form>
				<br>
			<% 
				filename = "storyskincount.csv";
				fw = new FileWriter(filepath+filename);
				
				conn = ConnectionProvider.getConnection("afgt");
				ArrayList<String> list = new ArrayList<String>();
				pstmt = conn.prepareStatement("select Story_id from story");
				rs = pstmt.executeQuery();
				while(rs.next()) {
					list.add(rs.getString(1));
				}
				
				fw.append("스토리 아이디");
				fw.append(',');
				fw.append("구매 횟수");
				fw.append('\n');
				
				%>
				<table border="1" style="border-style:solid;">
					<tr>
						<td>스토리 아이디</td>
						<td>구매 횟수</td>
					</tr>
				<%
				conn = ConnectionProvider.getConnection("logdb");
				
				for(int i=0;i<list.size();i++) {
					pstmt = conn.prepareStatement("select count(item) from log_action where action_type = 'success' and action_name = 'buyskin' and point = ?");
					pstmt.setString(1, list.get(i));
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						fw.append(list.get(i));
						fw.append(',');
						fw.append(String.valueOf(rs.getInt(1)));
						fw.append('\n');
						
						%> 
						<tr>
							<td><%=list.get(i)%></td>
							<td><%=String.valueOf(rs.getInt(1))%></td>
						</tr>
						<%
					}
					else {

						fw.append(list.get(i));
						fw.append(',');
						fw.append("0");
						fw.append('\n');
						
						%>
						<tr>
							<td><%=list.get(i)%></td>
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
			else if(type.equals("bothreading")) {
			%>
				<td> 이야기별 같이 읽은 이야기 카운트 </td>
				<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
			%>
			
		<%	}
			else if(type.equals("payerbuystory")) {
			%>
				<td> 이야기별 유료패션구매자가 같이 유료패션 구매한 이야기 유니크카운트 </td>
				<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
			%>
			
		<%	}
			else if(type.equals("payerreadstory")) {
			%>
				<td> 이야기별 유료 패션 구매자가 동일 스토리를 반복 감상한 회차 </td>
				<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
			%>
			
		<%	} 
			else if(type.equals("storylastread")) {
			%>
				<td> 이야기별 최종 읽은 라인 </td>
				<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
			%>
			
		<%	} 
			else if(type.equals("averagelastread")) {
			%>
				<td> 전체 유저 이야기별 화별 최종 읽은 라인 </td>
				<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
			%>
			
		<%	} 
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