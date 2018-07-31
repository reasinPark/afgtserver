<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%
	request.setCharacterEncoding("UTF-8");
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	try{
		/* select ticketgentime , DATE_FORMAT(ticketgentime,'%Y-%m-%d %H:%i:%s') from user limit 1; */
		int freeticket = 0;
		String ticektgentimeStr = "";
		long ticektgentime = 0;
		int cashticket = 0;
		int freegem = 0;
		int cashgem = 0;
		String servicename = "";
		String lastjointimeStr = "";
		long lastjointime = 0;
		int firstbuy = 0;
		int logincontinue = 0;
		String adpassStr = "";
		long adpass = 0;
		int adpasscount = 0;
		int active = 0;
		int existinguid = 0;
		
		boolean isFound = false;
		String uid = request.getParameter("uid");
		String command = request.getParameter("command");
		if(uid!=null){
			pstmt = conn.prepareStatement("select freeticket,ticketgentime,DATE_FORMAT(ticketgentime,'%Y-%m-%d %H:%i:%s')"+ 
					",cashticket,freegem,cashgem,service,lastjointime,DATE_FORMAT(lastjointime,'%Y-%m-%d %H:%i:%s')"+
					",firstbuy,logincontinue,adpass,DATE_FORMAT(adpass,'%Y-%m-%d %H:%i:%s'),adpasscount,active,existinguid from user where uid = ?");
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				freeticket = rs.getInt(1);
				ticektgentime = rs.getTimestamp(2).getTime()/1000;
				ticektgentimeStr = rs.getString(3);				
				cashticket = rs.getInt(4);
				freegem = rs.getInt(5);
				cashgem = rs.getInt(6);
				servicename = rs.getString(7);
				lastjointime = rs.getTimestamp(8).getTime()/1000;
				lastjointimeStr = rs.getString(9);
				firstbuy = rs.getInt(10);
				logincontinue = rs.getInt(11);
				adpass = rs.getTimestamp(12).getTime()/1000;
				adpassStr = rs.getString(13);
				adpasscount = rs.getInt(14);
				active = rs.getInt(15);
				existinguid = rs.getInt(16);
				isFound = true;
			}else{
				%>
				<script type="text/javascript">alert("�Է��Ͻ� ������ ��ġ�ϴ� ������ ã�� �� �����ϴ�.");</script>
				<%
			}
		}
		else if(command != null){
			%>
			<script type="text/javascript">alert("�Է��� �ٽ� Ȯ�����ּ���.");</script>
			<%
		}
		%>
		
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� ���� ����</H2>
		
		<form method="post" name="search_form" id="item_form" action="user.jsp">
			<input type="hidden" name="command" value="search">
			<table border="1" style="border-style:solid;">
			<tr height="10">
				<td colspan="3"> �Ʒ��� �������̵� �Է��� ���� �˻��� ������ �˴ϴ�.
			</tr>
			<tr height="30">
				<td><input type="text" name="uid" size="30" value="<%=((isFound)? uid : "")%>"></td>
				<td><input type="submit" value="���� �˻�"></td>
			</tr>
			</table>
		</form>
		<br>
		<%if(isFound){ %>
		<form target="result_frame" method="post" name="update_form" id="item_form" action="user_update.jsp">
			<input type="hidden" name="uid" value="<%=((isFound)? uid :"") %>">
			<table border="1" style="border-style:solid;">
				<tr>
					<td colspan="10" align="center"><%=((isFound)? "�Էµ� ������ ��ġ�ϴ� ������ ã�ҽ��ϴ�. uid["+uid+"]" : "�˻��� ���� ���ּ���.")%></td>
				</tr>
				<tr>
					<td>���� Ƽ��</td>
					<td>Ƽ�� �����ð�</td>
					<td>���� Ƽ��</td>
					<td>���� ��</td>
					<td>���� ��</td>
					<td>�÷���</td>
					<td>���� ���ӽð�</td>
					<td>���� ����</td>
					<td>���� �α��� �ϼ�</td>
					<td>���� ���Žð�</td>
					<td>���� ���ſ���</td>
					<td>Active</td>
					<td>ExistingUid</td>
				</tr>
				<tr>
					<td><input type="text" name="freeticket" size="20" value="<%=((isFound)? String.valueOf(freeticket): "") %>">
					<td><input type="text" name="tickettime" size="20" value="<%=((isFound)? String.valueOf(ticektgentimeStr): "") %>">
					<td><input type="text" name="cashticket" size="20" value="<%=((isFound)? String.valueOf(cashticket): "") %>">
					<td><input type="text" name="freegem" size="20" value="<%=((isFound)? String.valueOf(freegem): "") %>">
					<td><input type="text" name="cashgem" size="20" value="<%=((isFound)? String.valueOf(cashgem): "") %>">
					<td><input type="text" name="service" size="20" value="<%=((isFound)? String.valueOf(servicename): "") %>">
					<td><input type="text" name="lastjointime" size="20" value="<%=((isFound)? String.valueOf(lastjointimeStr): "") %>">
					<td><input type="text" name="firstbuy" size="20" value="<%=((isFound)? String.valueOf(firstbuy): "") %>">
					<td><input type="text" name="logincontinue" size="20" value="<%=((isFound)? String.valueOf(logincontinue): "") %>">
					<td><input type="text" name="adpasstime" size="20" value="<%=((isFound)? String.valueOf(adpassStr): "") %>">
					<td><input type="text" name="adpasscount" size="20" value="<%=((isFound)? String.valueOf(adpasscount): "") %>">
					<td><input type="text" name="active" size="20" value="<%=((isFound)? String.valueOf(active): "") %>">
					<td><input type="text" name="existinguid" size="20" value="<%=((isFound)? String.valueOf(existinguid): "") %>">
				</tr>
				<tr>
					<td colspan="10" align="center"><input type="submit" value="    ����    "></td>
				</tr>
			</table>
		</form>
		<%} %>
		<table border="1" style="border-style: solid;" width="90%">
		<tr>
			<td width="100%" height="200">
				<iframe name="result_frame" width="100%" height="200"></iframe>
			</td>
		</tr>
		</table>
<%
	}catch(Exception e){
		
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>