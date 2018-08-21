<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CC 관리자 메뉴</title>
</head>
<body>
<form target="content" method="post" name="search_form" action="main.jsp">
	<input type="hidden" name="command">
</form>
<table>
	<tr>
		<td style="font-size: 20px; font-weight: bold;">메뉴</td>
	</tr>
	<tr>
		<td>
			<a href="user.jsp" target="content">유저 정보 수정</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="tutorial.jsp" target="content">튜토리얼 작품 수정</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="storyupload.jsp" target="content">스토리 파일 업로드</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="userinfo.jsp" target="content">유저 기본데이터 보기</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="storyinfo.jsp" target="content">이야기 데이터 보기</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="cashinfo.jsp" target="content">재화 데이터 보기</a>
		</td>
	</tr>
	<tr>
		<td style="font-size: 15px; font-weight: bold;">csv 파일 적용</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_banner.jsp" target="content">배너 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_story.jsp" target="content">스토리 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_episode.jsp" target="content">에피소드 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_categorylist.jsp" target="content">카테고리 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_costumedata.jsp" target="content">코스튬 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_selectitem.jsp" target="content">선택지 데이터 적용</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="csvupload_shopitem.jsp" target="content">상점 데이터 적용</a>
		</td>
	</tr>
</table>
</body>
</html>