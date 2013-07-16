<%@page import="java.util.ArrayList" import="java.text.*" import="com.jamfsoftware.*"%>
<%ArrayList computers = (ArrayList) session.getAttribute("computers");
int cnt, i,userCnt,shadeCount;

Computer c;
ComputerDetails details;
User user;
PurchasingInfo pi;
Partition part;
ArrayList peripherals;
Peripheral p;
PackageReceipt pr;
Application app;
ArrayList applications;
ArrayList partitions;
int pageHeight= 857;
int pageWidth=700;
JSSInfo jss = (JSSInfo)session.getAttribute("jssInfo");
int maxApps;

%>
<!-- *************** Do not modify any code above this point *************** -->





<html>
  <head>
    <title>Show All Users</title>
    <LINK href="../reporting_theme/Master.css" rel="stylesheet">
  </head>
  <body>
  
  <table width="<%=pageWidth%>" height="<%=pageHeight%>">


 <tr>
  <td align="left" valign="top">
   <table width="1180" height="*%">
    <tr valign="center">
     <td align="left" width="325">
     	<img src="../../reporting_images/casperSuiteLogo.jpg" width="263" height="100" border="0">
     </td>
     <td width="*%" align="center">
	     <font size=5><b>Users Report</b></font><br>
     </td>
     <td align="right" width="325">
     	<img src="../../reporting_images/casperSuiteLogo.jpg" width="263" height="100" border="0">
     </td>
    </tr>
   </table>

<table align="center" bgcolor="#cccccc" cellspacing="1" cellpadding="0">

<tr>
<td nowrap>&nbsp;
<b>Computer Name</b>
</td>

<td nowrap>&nbsp;
<b>Username</b>
</td>
<td nowrap>&nbsp;
<b>Real Name</b>
</td>
<td nowrap>&nbsp;
<b>UID</b>
</td>
<td nowrap>&nbsp;
<b>Home Directory</b>
</td>
<td nowrap>&nbsp;
<b>Home Directory Size</b>
</td>
<td nowrap>&nbsp;
<b>Admin</b>
</td>

</tr>
<%shadeCount=0; %>
<!-- *************** Do not modify the following line of code *************** -->
<%  for(cnt=0;cnt<computers.size();cnt++){c=(Computer)computers.get(cnt); details=c.getComputerDetails(); user=c.getUser(); pi=c.getPurchasingInfo(); partitions = (ArrayList)details.getPartitions();  peripherals = c.getPeripherals(); applications=(ArrayList) details.getApplications();maxApps=25;%>
<% ArrayList users = details.getReceiptsForType("user");%>




<%for(userCnt=0;userCnt<users.size();userCnt++){pr=(PackageReceipt)users.get(userCnt);%>
<%if(shadeCount%2==0){%>
		<tr bgcolor="#FFFFFF">
<%}else{%>
		<tr bgcolor="#EEEEEE">
<%}%>

			<td nowrap>&nbsp;
				<%=c.getName()%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getName()%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getDetail1()%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getDetail2()%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getDetail3()%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getHomeSize(pr.getDetail4())%>
			</td>
			<td nowrap>&nbsp;
				<%=pr.getDetail5()%>
			</td>

		</tr>
<%shadeCount=shadeCount+1; %>
<%}%>





     </td>

   </td>
  </tr>


<%}%><!-- *************** Do not modify this line of code *************** -->

</table>









  </body>
</html>
