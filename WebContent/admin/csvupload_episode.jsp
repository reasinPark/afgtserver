<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에피소드 데이터</H3>
</section>

<form target="result_frame" action="csvupload_episode_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 episode.csv 파일 </td>
			<td><input type="file" name="episode" /></td>
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