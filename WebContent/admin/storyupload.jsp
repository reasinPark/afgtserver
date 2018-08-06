<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
   
<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스토리 파일 업로드</H2>
		 
<form action="storyupload_update.jsp" method="post" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 업로드 파일 </td>
			<td><input type="file" name="fileName1" /></td>
		</tr>
		<tr>
			<td colspan = "2" align="center">
			<input type="submit" value="전송" /> </td>
		</tr>
	</table>
</form>