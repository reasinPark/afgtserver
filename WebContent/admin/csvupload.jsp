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
   
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;csv ���� ����</H2>
	
	<form action="csvupload.jsp">
		<label for = "type">������ ���̺��� �������ּ���.</label><br>
		<input type = "radio" name = "type" value = "banner"> ��� ������ <br>
		<input type = "radio" name = "type" value = "story"> ���丮 ������ <br>
		<input type = "radio" name = "type" value = "episode"> ���Ǽҵ� ������ <br>
		<input type = "radio" name = "type" value = "category"> ī�װ� ������ <br>
		<input type = "radio" name = "type" value = "costume"> �ڽ�Ƭ ������ <br>
		<input type = "radio" name = "type" value = "selectitem"> ������ ������ <br>
		<input type = "radio" name = "type" value = "shopitem"> ���� ������ <br>
		<input type = "submit" value ="���� �Ϸ�">
	</form>
	<br>
	
	<%if(isselected) { %>
	<form target="result_frame" action="csvupload_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> ������ <%= type%> csv ���� </td>
				<td><input type="file" name=<%= type%> /></td>
			</tr>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="�����ϱ�" /> </td>
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