<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   
<%
	boolean isselected = false;
	String type = request.getParameter("type");
	
	if(type == null) {
		
	}
	else {
		isselected = true;
	}
%>
   
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
	
	<form action="csvupload.jsp">
		<label for = "type">적용할 테이블을 선택해주세요.</label><br>
		<input type = "radio" name = "type" value = "banner"> 배너 데이터 <br>
		<input type = "radio" name = "type" value = "story"> 스토리 데이터 <br>
		<input type = "radio" name = "type" value = "episode"> 에피소드 데이터 <br>
		<input type = "radio" name = "type" value = "category"> 카테고리 데이터 <br>
		<input type = "radio" name = "type" value = "costume"> 코스튬 데이터 <br>
		<input type = "radio" name = "type" value = "selectitem"> 선택지 데이터 <br>
		<input type = "radio" name = "type" value = "shopitem"> 상점 데이터 <br>
		<input type = "submit" value ="선택 완료">
	</form>
	<br>
	
	<%if(isselected) { %>
	<form target="result_frame" action="csvupload_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> 적용할 <%= type%> csv 파일 </td>
				<td><input type="file" name=<%= type%> /></td>
			</tr>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="적용하기" /> </td>
			</tr>
		</table>
	</form>
	<table border="1" style="border-style: solid;" width="90%">
	<tr>
		<td width="100%" height="200">
			<iframe name="result_frame" width="100%" height="200"></iframe>
		</td>
	</tr>
	</table>
	<%} %>