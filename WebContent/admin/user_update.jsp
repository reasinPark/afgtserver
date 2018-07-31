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
	String uid = request.getParameter("uid");
	try{
		if(uid != null){
			int freeticket = Integer.parseInt(request.getParameter("freeticket"));
			String tickettime = request.getParameter("tickettime");
			int cashticket = Integer.parseInt(request.getParameter("cashticket"));
			int freegem = Integer.parseInt(request.getParameter("freegem"));
			int cashgem = Integer.parseInt(request.getParameter("cashgem"));
			String service = request.getParameter("service");
			String lastjointime = request.getParameter("lastjointime");
			int firstbuy = Integer.parseInt(request.getParameter("firstbuy"));
			int logincontinue = Integer.parseInt(request.getParameter("logincontinue"));
			String adpasstime = request.getParameter("adpasstime");
			int adpasscount = Integer.parseInt(request.getParameter("adpasscount"));
			int active = Integer.parseInt(request.getParameter("active"));
			int existinguid = Integer.parseInt(request.getParameter("existinguid"));
			pstmt = conn.prepareStatement("update user set freeticket = ?, ticketgentime = ?, cashticket = ?, freegem = ?, cashgem = ?, service = ?, lastjointime = ?, firstbuy = ?, logincontinue = ?, adpass = ?"+
					", adpasscount = ?, active = ?, existinguid = ? where uid = ?");
			pstmt.setInt(1, freeticket);
			pstmt.setString(2, tickettime);
			pstmt.setInt(3, cashticket);
			pstmt.setInt(4, freegem);
			pstmt.setInt(5, cashgem);
			pstmt.setString(6, service);
			pstmt.setString(7, lastjointime);
			pstmt.setInt(8, firstbuy);
			pstmt.setInt(9, logincontinue);
			pstmt.setString(10, adpasstime);
			pstmt.setInt(11, adpasscount);
			pstmt.setInt(12, active);
			pstmt.setInt(13, existinguid);
			pstmt.setString(14, uid);
			if(pstmt.executeUpdate() == 1){
				%>������Ʈ �Ǿ����ϴ�.<%
			}else{
				%>������Ʈ�� ���� �߽��ϴ�. �Է��� �ٽ� Ȯ���� �ּ���.<%
			}
		}else {
			%>�Է��Ͻ� ������ ��ġ�ϴ� ������ ã�� �� �����ϴ�. uid[<%=uid%>]<%
		}
	}catch(Exception e){
		%>
		�����Ͱ� �߸� �Ǿ����ϴ�. �Է��� �ٽ� Ȯ���� �ּ���. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>