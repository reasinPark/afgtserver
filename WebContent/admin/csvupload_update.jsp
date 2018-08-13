<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%
	//configuration
	int maxSize = 1024 * 1024 * 10; // ���� �뷮�� 10M ���� ����.
	
	long fileSize = 0;				// ���� ������
	String fileType = "";			// ���� Ÿ��
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	
	MultipartRequest mr = null;
	
	try {
		// test
		if(ConnectionProvider.afgt_build_ver == 0) {
			mr = new MultipartRequest(request, "/usr/share/tomcat6/webapps/tempcsv/", maxSize, "euc-kr");
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			mr = new MultipartRequest(request, "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/", maxSize, "euc-kr");
		}
		
		Enumeration files = mr.getFileNames();
		
		while(files.hasMoreElements()) {
			String obj = (String)files.nextElement();
			File csv = mr.getFile(obj);
			
			BufferedReader br = new BufferedReader(new FileReader(csv));
			
			String line = "";
			
			if(obj.equals("banner")) {
				
				pstmt = conn.prepareStatement("truncate bannerdata");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into bannerdata (idx,Newmark,Title,Text,sort,imgname,type,callid) values(?,?,?,?,?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 1 || index == 2 || index == 5) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("��� ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("��� ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ��� ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("story")) {
				pstmt = conn.prepareStatement("truncate story");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into story (Story_id,csvfilename,title,writer,summary,category_id,imgname,recommend,totalcount,director) values(?,?,?,?,?,?,?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 6 || index == 8 || index == 9) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("���丮 ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("���丮 ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ���丮 ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("episode")) {
				pstmt = conn.prepareStatement("truncate episode");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into episode (Story_id,episode_num,episode_name,csvfilename,ticket,gem,purchaseinfo,reward_gem, reward_ticket, rewardinfo, writer, director, imgname, likecount, summary, subtitle) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 2 || index == 5 || index == 6 || index == 7 || index == 8 || index == 9 || index == 10 || index == 14) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("���Ǽҵ� ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("���Ǽҵ� ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ���Ǽҵ� ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("category")) {
				pstmt = conn.prepareStatement("truncate categorylist");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into categorylist (category_id,categoryname,ordernum) values(?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 1 || index == 3) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("ī�װ� ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("ī�װ� ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ī�װ� ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("costume")) {
				pstmt = conn.prepareStatement("truncate CostumeData");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into CostumeData (CostumeId,CallId,ChId,Skinname,filename,thumnailname,selectani,buyani,description,cash,name,episodeid,storyid,viewingame,BFilename,BSkinname,FFilename,FSkinname,HFilename,HSkinname,AFilename,ASkinname) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 1 || index == 10 || index == 12 || index == 14) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("�ڽ�Ƭ ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("�ڽ�Ƭ ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� �ڽ�Ƭ ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("selectiem")) {
				pstmt = conn.prepareStatement("truncate SelectItem");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into SelectItem (selectid,price,storyid,epinum) values(?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 1 || index == 2 || index == 4) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("������ ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("������ ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ������ ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			else if(obj.equals("shopitem")) {
				pstmt = conn.prepareStatement("truncate shop_item");
				int r = pstmt.executeUpdate();
				
				if(r == 0) {
					int i = 0;
					int completeCount = 1;
					
					while((line = br.readLine()) != null) {
						if(i != 0) {
							// -1 �ɼ��� ������ "," ���� �� ���鵵 �б� ���� �ɼ�
							String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
							
							int index = 1;
							
							pstmt = conn.prepareStatement("insert into shop_item (id,type,title,price,gem,ticket,PID_android,PID_ios,price_ios) values(?,?,?,?,?,?,?,?,?)");
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								// int
								if(index == 1 || index == 3) {
									pstmt.setInt(index, Integer.parseInt(output));
								}
								// string
								else {
									pstmt.setString(index, output);
								}
								index++;
							}
							
							if(pstmt.executeUpdate() == 1) {
								completeCount++;
							}
							else {
								out.print("������ ���� �� ����! Ȯ�����ּ���!!"); %> <br> <%
								break;
							}
						}
						
						i++;
					}
					
					if(completeCount == i) {
						out.print("���� ������ ���� �Ϸ�!"); %> <br> <%
					}
					else {
						out.print("���� ������ ���� ����! Ȯ�����ּ���"); %> <br> <%
					}
				}
				else {
					out.print("���� ���� ������ ���� ����! Ȯ�����ּ���!!"); %> <br> <%
				}
			}
			
			br.close();
		}
		
	} catch(Exception e) {
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
