<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.Module" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;출석 보상 데이터</H3>
</section>

<form target="result_frame" action="csvupload_attendevent_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 attendevent.csv 파일 </td>
			<td><input type="file" name="attendevent" /></td>
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

<%
	try {
		Module module = new Module();
		Connection conn = ConnectionProvider.getConnection("afgt");
		PreparedStatement pstmt = conn.prepareStatement("select eventName, onoff, DATE_FORMAT(startDate,'%Y-%m-%d %H:%i:%s'), DATE_FORMAT(endDate,'%Y-%m-%d %H:%i:%s'), " +
														"d1itemId_1, d1itemId_2, d1itemId_3, d2itemId_1, d2itemId_2, d2itemId_3," +
														"d3itemId_1, d3itemId_2, d3itemId_3, d4itemId_1, d4itemId_2, d4itemId_3," +
														"d5itemId_1, d5itemId_2, d5itemId_3, d6itemId_1, d6itemId_2, d6itemId_3," +
														"d7itemId_1, d7itemId_2, d7itemId_3, d1count_1, d1count_2, d1count_3," +
														"d2count_1, d2count_2, d2count_3, d3count_1, d3count_2, d3count_3," +
														"d4count_1, d4count_2, d4count_3, d5count_1, d5count_2, d5count_3," +
														"d6count_1, d6count_2, d6count_3, d7count_1, d7count_2, d7count_3 from attendEvent");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>이벤트 명</td>
				<td>이벤트 여부 (시작1,종료0)</td>
				<td>이벤트 시작일</td>
				<td>이벤트 종료일</td>
			</tr>
		<%
		while(rs.next()) {
		%>
			<tr>
				<td><%=String.valueOf(rs.getString(1))%></td>
				<td><%=String.valueOf(rs.getInt(2))%></td>
				<td><%=String.valueOf(rs.getString(3))%></td>
				<td><%=String.valueOf(rs.getString(4))%></td>
			</tr>
		</table>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>회차</td>
				<td colspan = "3">1회</td>
				<td colspan = "3">2회</td>
				<td colspan = "3">3회</td>
				<td colspan = "3">4회</td>
				<td colspan = "3">5회</td>
				<td colspan = "3">6회</td>
				<td colspan = "3">7회</td>
			</tr>
			<tr>
				<td>아이템</td>
			<%
			
			%>
				<td><%=module.itemNameCheck(rs.getInt(5))%></td>
				<td><%=module.itemNameCheck(rs.getInt(6))%></td>
				<td><%=module.itemNameCheck(rs.getInt(7))%></td>
				<td><%=module.itemNameCheck(rs.getInt(8))%></td>
				<td><%=module.itemNameCheck(rs.getInt(9))%></td>
				<td><%=module.itemNameCheck(rs.getInt(10))%></td>
				<td><%=module.itemNameCheck(rs.getInt(11))%></td>
				<td><%=module.itemNameCheck(rs.getInt(12))%></td>
				<td><%=module.itemNameCheck(rs.getInt(13))%></td>
				<td><%=module.itemNameCheck(rs.getInt(14))%></td>
				<td><%=module.itemNameCheck(rs.getInt(15))%></td>
				<td><%=module.itemNameCheck(rs.getInt(16))%></td>
				<td><%=module.itemNameCheck(rs.getInt(17))%></td>
				<td><%=module.itemNameCheck(rs.getInt(18))%></td>
				<td><%=module.itemNameCheck(rs.getInt(19))%></td>
				<td><%=module.itemNameCheck(rs.getInt(20))%></td>
				<td><%=module.itemNameCheck(rs.getInt(21))%></td>
				<td><%=module.itemNameCheck(rs.getInt(22))%></td>
				<td><%=module.itemNameCheck(rs.getInt(23))%></td>
				<td><%=module.itemNameCheck(rs.getInt(24))%></td>
				<td><%=module.itemNameCheck(rs.getInt(25))%></td>
			<%
			%>
			</tr>
			<tr>
				<td>지급수량</td>
				<td><%=String.valueOf(rs.getInt(26))%></td>
				<td><%=String.valueOf(rs.getInt(27))%></td>
				<td><%=String.valueOf(rs.getInt(28))%></td>
				<td><%=String.valueOf(rs.getInt(29))%></td>
				<td><%=String.valueOf(rs.getInt(30))%></td>
				<td><%=String.valueOf(rs.getInt(31))%></td>
				<td><%=String.valueOf(rs.getInt(32))%></td>
				<td><%=String.valueOf(rs.getInt(33))%></td>
				<td><%=String.valueOf(rs.getInt(34))%></td>
				<td><%=String.valueOf(rs.getInt(35))%></td>
				<td><%=String.valueOf(rs.getInt(36))%></td>
				<td><%=String.valueOf(rs.getInt(37))%></td>
				<td><%=String.valueOf(rs.getInt(38))%></td>
				<td><%=String.valueOf(rs.getInt(39))%></td>
				<td><%=String.valueOf(rs.getInt(40))%></td>
				<td><%=String.valueOf(rs.getInt(41))%></td>
				<td><%=String.valueOf(rs.getInt(42))%></td>
				<td><%=String.valueOf(rs.getInt(43))%></td>
				<td><%=String.valueOf(rs.getInt(44))%></td>
				<td><%=String.valueOf(rs.getInt(45))%></td>
				<td><%=String.valueOf(rs.getInt(46))%></td>
			</tr>
		<%
		}
		%>
		</table>
		<%
	} catch(Exception e) {
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