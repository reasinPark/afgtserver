<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
   
<%
	boolean iscorrect = false;
	int countnum = 0;
	String param = request.getParameter("countnum");
	
	if(param == null) {
		
	}
	else {
		countnum = Integer.parseInt(param);
		
		if(countnum > 0 && countnum <= 10) {
			iscorrect = true;
		}
		else {
			iscorrect = false;
			%>
			<script type="text/javascript">alert("��Ȯ�� ���ڸ� �Է����ּ���.");</script>
			<%
		}
	}
%>
   
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���丮 ���� ���ε�</H2>
	
	<form method="post" name="search_form" id="item_form" action="storyupload.jsp">
		<input type="hidden" name="command" value="search">
		<table border="1" style="border-style:solid;">
		<tr height="10">
			<td colspan="3"> �Ʒ��� �߰��� ���� ������ �Է� �� Ȯ���� ������ �˴ϴ�. (�ִ� 10������)
		</tr>
		<tr height="30">
			<td><input type="text" name="countnum" size="30" value="<%=((iscorrect)? countnum : "0")%>"></td>
			<td><input type="submit" value="Ȯ��"></td>
		</tr>
		</table>
	</form>
	<br>
	<%if(iscorrect) { %>
	<form target="result_frame" action="storyupload_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
		<table border = "1" style="border-style:solid;">
		<% 
			for(int i=0;i<countnum;i++) {
				%>
				<tr>
					<td> ���ε� ���� <%=i+1%> </td>
					<td><input type="file" name="fileName<%=i%>" /></td>
				</tr>
				<%
			}
			%>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="����" /> </td>
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