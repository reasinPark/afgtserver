<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;
	
	String type = request.getParameter("type");
	
	try {
		if(type.equals("regist")) {
			conn = ConnectionProvider.getConnection("afgt");
			String regidate = request.getParameter("regidate");
			Timestamp start = Timestamp.valueOf(regidate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(regidate + " 23:59:59");
			
			pstmt = conn.prepareStatement("select count(*) from user_regist where regidate between ? and ?");
			
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				%> <%=regidate %> �� ������ ������ �� <%=count %>�� �Դϴ�. <%
			}
			else {
				%>
				<script type="text/javascript">alert("������ ������ �ֽ��ϴ�. Ȯ�����ּ���.");</script>
				<%
			}
		}
		else if(type.equals("uniquelogin")) {
			conn = ConnectionProvider.getConnection("logdb");
			String regidate = request.getParameter("regidate");
			Timestamp start = Timestamp.valueOf(regidate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(regidate + " 23:59:59");
			
			pstmt = conn.prepareStatement("select count(distinct uid) from log_action where regdate between ? and ?");
			
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				%> <%=regidate %> �� �α��� �� ������ �� <%=count %>�� �Դϴ�. <%
			}
			else {
				%>
				<script type="text/javascript">alert("������ ������ �ֽ��ϴ�. Ȯ�����ּ���.");</script>
				<%
			}
		}
		else if(type.equals("playing")) {
			
		}
		else if(type.equals("payer")) {
			conn = ConnectionProvider.getConnection("logdb");
			String regidate = request.getParameter("regidate");
			Timestamp start = Timestamp.valueOf(regidate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(regidate + " 23:59:59");
			
			pstmt = conn.prepareStatement("select count(distinct uid) from log_action where (regdate between ? and ?) and (action_type = 'success_increase') and (action_name = 'buyitem')");
			
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				%> <%=regidate %> �� ���� ������ �� ������ �� <%=count %>�� �Դϴ�. <%
			}
			else {
				%>
				<script type="text/javascript">alert("������ ������ �ֽ��ϴ�. Ȯ�����ּ���.");</script>
				<%
			}
		}
		else if(type.equals("firstpayer")) {
			
		}
		else if(type.equals("retention")) {
			
		}
	}
	catch(Exception e) {
		%>
		�ٽ� Ȯ���� �ּ���. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>