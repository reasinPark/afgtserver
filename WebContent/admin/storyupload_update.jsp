<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%	
	// configuration
	int maxSize = 1024 * 1024 * 10; // ���� �뷮�� 10M ���� ����.
	
	long fileSize = 0;				// ���� ������
	String fileType = "";			// ���� Ÿ��
	
	MultipartRequest mr = null;
	
	try {
		// test
		if(ConnectionProvider.afgt_build_ver == 0) {
			mr = new MultipartRequest(request, "/usr/share/tomcat6/webapps/story/", maxSize, "utf-8");
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			mr = new MultipartRequest(request, "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/story/", maxSize, "utf-8");
		}
		
		Enumeration files = mr.getFileNames();

		out.println("file size : " + request.getContentLength() + "<br>");
		
		while(files.hasMoreElements()) {
			String file1 = (String)files.nextElement();
			String systemName = mr.getFilesystemName(file1);
			fileSize = file1.length();
			fileType = mr.getContentType(file1);
		}
		
		
		
	} catch(Exception e) {
		%>
		�����Ͱ� �߸� �Ǿ����ϴ�. �ٽ� Ȯ���� �ּ���. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>
	