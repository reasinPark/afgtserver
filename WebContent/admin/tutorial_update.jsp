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
		String Story_id_1 = request.getParameter("Story_id_1");
		String Story_id_2 = request.getParameter("Story_id_2");
		int episode_num_1 = Integer.parseInt(request.getParameter("episode_num_1"));
		int episode_num_2 = Integer.parseInt(request.getParameter("episode_num_2"));
		String summary_1 = request.getParameter("summary_1");
		String summary_2 = request.getParameter("summary_2");
		boolean checkFlag = false;
		
		pstmt = conn.prepareStatement("update tutorial set Story_id = ?, episode_num = ?, summary = ? where idx = ?");
		pstmt.setString(1, Story_id_1);
		pstmt.setInt(2, episode_num_1);
		pstmt.setString(3, summary_1);
		pstmt.setInt(4, 1);
		
		if(pstmt.executeUpdate() == 1){
			checkFlag = true;
		}else{
			%>ù��° �� ������Ʈ�� ���� �߽��ϴ�. �Է��� �ٽ� Ȯ���� �ּ���.<%
		}
		
		if(checkFlag) {
			pstmt = conn.prepareStatement("update tutorial set Story_id = ?, episode_num = ?, summary = ? where idx = ?");
			pstmt.setString(1, Story_id_2);
			pstmt.setInt(2, episode_num_2);
			pstmt.setString(3, summary_2);
			pstmt.setInt(4, 2);
			
			if(pstmt.executeUpdate() == 1){
				%>������Ʈ �Ǿ����ϴ�.<%
			}else{
				%>�ι�° �� ������Ʈ�� ���� �߽��ϴ�. �Է��� �ٽ� Ȯ���� �ּ���.<%
			}
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