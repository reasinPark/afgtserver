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
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� �⺻������ ����</H2>
	
	<form action="userinfo.jsp">
		<label for = "type">���� ���� �����͸� �������ּ���.</label><br>
		<input type = "radio" name = "type" value = "regist"> ������ �� <br>
		<input type = "radio" name = "type" value = "uniquelogin"> �α��� �� <br>
		<input type = "radio" name = "type" value = "playing"> ����Ƚ�� <br>
		<input type = "radio" name = "type" value = "payer"> ���� ������ �� <br>
		<input type = "radio" name = "type" value = "firstpayer"> ���� ���� ������ �� <br>
		<input type = "radio" name = "type" value = "retention"> 2,3,7���� ���ټ� <br>
		<input type = "submit" value ="���� �Ϸ�">
	</form>
	<br>
	
	<%if(isselected) {
		if(type.equals("regist")) {
		%>
		<td> ������ �� : ��¥�� ����� ��(���� ���� ����) </td>
		<form target="result_frame" action="userinfo_update.jsp" method="post">
			<table border = "1" style="border-style:solid;">
				<tr>
					<td> �˻��Ͻ� ��¥�� �������ּ���. </td>
					<td><input type="date" id="regidate" name="regidate" value="2018-09-01" /></td>
				</tr>
				<tr>
					<td colspan = "2" align="center">
					<input type="submit" value="�˻�" /> </td>
				</tr>
			</table>
			<input type="hidden" name="type" value="regist">
		</form>
	<%	}
		else if(type.equals("uniquelogin")) {
		%>
		<td> �α��� �� : ��¥�� �α��� ����ũ ī��Ʈ </td>
		<form target="result_frame" action="userinfo_update.jsp" method="post">
			<table border = "1" style="border-style:solid;">
				<tr>
					<td> �˻��Ͻ� ��¥�� �������ּ���. </td>
					<td><input type="date" id="regidate" name="regidate" value="2018-09-01" /></td>
				</tr>
				<tr>
					<td colspan = "2" align="center">
					<input type="submit" value="�˻�" /> </td>
				</tr>
			</table>
			<input type="hidden" name="type" value="uniquelogin">
		</form>
	<%	}
		else if(type.equals("playing")) {
			out.print("���� �۾� ���Դϴ�.. ���ݸ� ��ٷ��ּ��� ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("payer")) {
		%>
		<td> ���� ������ �� : �ش� ��¥�� ���� ������ �� ����ũ�� ���� ���� </td>
		<form target="result_frame" action="userinfo_update.jsp" method="post">
			<table border = "1" style="border-style:solid;">
				<tr>
					<td> �˻��Ͻ� ��¥�� �������ּ���. </td>
					<td><input type="date" id="regidate" name="regidate" value="2018-09-01" /></td>
				</tr>
				<tr>
					<td colspan = "2" align="center">
					<input type="submit" value="�˻�" /> </td>
				</tr>
			</table>
			<input type="hidden" name="type" value="payer">
		</form>
		
	<%	}
		else if(type.equals("firstpayer")) {
			out.print("���� �۾� ���Դϴ�.. ���ݸ� ��ٷ��ּ��� ^^"); %> <br> <%
		%>
		
	<%	}
		else if(type.equals("retention")) {
			out.print("���� �۾� ���Դϴ�.. ���ݸ� ��ٷ��ּ��� ^^"); %> <br> <%
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