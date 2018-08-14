<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		if(type.equals("storyreadcount")) {
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
				%> <%=regidate %> 에 가입한 유저는 총 <%=count %>명 입니다. <%
			}
			else {
				%>
				<script type="text/javascript">alert("쿼리에 문제가 있습니다. 확인해주세요.");</script>
				<%
			}
		}
		else if(type.equals("skincount")) {
			
		}
		else if(type.equals("storyskincount")) {
			
		}
		else if(type.equals("bothreading")) {
			
		}
		else if(type.equals("payerbuystory")) {
			
		}
		else if(type.equals("payerreadstory")) {
			
		}
	}
	catch(Exception e) {
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>