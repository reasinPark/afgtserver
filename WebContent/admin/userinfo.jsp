<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
<%
	boolean isselected = false;
	String type = request.getParameter("type");
	
	if(type == null) {
		
	}
	else {
		isselected = true;
	}
%>
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유저 기본데이터 보기</H2>
	
	<form action="userinfo.jsp">
		<label for = "type">보고 싶은 데이터를 선택해주세요.</label><br>
		<input type = "radio" name = "type" value = "regist"> 가입자 수 <br>
		<input type = "radio" name = "type" value = "login"> 로그인 수 <br>
		<input type = "radio" name = "type" value = "playing"> 실행횟수 <br>
		<input type = "radio" name = "type" value = "payer"> 유료 결제자 수 <br>
		<input type = "radio" name = "type" value = "firstpayer"> 최초 유료 결제자 수 <br>
		<input type = "radio" name = "type" value = "retention"> 2,3,7일자 리텐션 <br>
		<input type = "submit" value ="선택 완료">
	</form>
	<br>
	
	<%if(isselected) {
		if(type.equals("regist")) {
		%>
	<form target="result_frame" action="userinfo_update.jsp" method="post">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> 검색하실 날짜를 선택해주세요. </td>
				<td><input type="date" id="regidate" name="regidate" value="2018-09-01" /></td>
			</tr>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="검색" /> </td>
			</tr>
		</table>
		<input type="hidden" name="type" value="regist">
	</form>
	<%	}
		else if(type.equals("login")) {
			out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("playing")) {
			out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("payer")) {
			out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("firstpayer")) {
			out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("retention")) {
			out.print("아직 작업 중입니다.. 조금만 기다려주세요 ^^"); %> <br> <%
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