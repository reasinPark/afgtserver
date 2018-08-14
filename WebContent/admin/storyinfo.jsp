<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%
	boolean isselected = false;
	String type = request.getParameter("type");
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;
	
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
		<input type = "submit" value ="선택 완료">
	</form>
	<br>
	
	<%if(isselected) {
		if(type.equals("storyreadcount")) {
		%>	
			<td> 이야기별 읽은 수 </td>
			<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
	<%	}
		else if(type.equals("skincount")) {
		%>
			<td> 패션상품별 아이템 구매 횟수 </td>
			<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
	<%	}
		else if(type.equals("storyskincount")) {
		%>	
			<td> 이야기별 패션 아이템 구매횟수 </td>
			<% out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
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
	<%	} %>
		
		<table border="1" style="border-style: solid;" width="90%">
		<tr>
			<td width="100%" height="200">
				<iframe name="result_frame" width="100%" height="200"></iframe>
			</td>
		</tr>
		</table>	
	<%}%>