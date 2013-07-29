<%@page import ="java.util.ArrayList" import="java.text.*" import="com.jamfsoftware.*"%><%ArrayList computers = (ArrayList) session.getAttribute("computers");
int cnt, i,updateCnt,shadeCount;

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
    <title>Network Interfaces</title>
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
	     <font size=5><b>Network Interfaces</b></font><br>
     </td>
     <td align="right" width="325">
     	<img src="../../reporting_images/casperSuiteLogo.jpg" width="263" height="100" border="0">
     </td>
    </tr>
   </table>


<table bgcolor="#cccccc" cellspacing="1	" cellpadding="0" align="center">

<tr>
<td nowrap><font size="2">&nbsp;
<b>Computer Name</b>
</font>
</td>
<td nowrap><font size="2">&nbsp;
<b>Primary MAC Address</b>
</font>
</td>
<td nowrap><font size="2">&nbsp;
<b>Secondary MAC Address</b>
</font>
</td>
</tr>
<%shadeCount=0; %>
<!-- *************** Do not modify the following line of code *************** -->
<%  for(cnt=0;cnt<computers.size();cnt++){c=(Computer)computers.get(cnt); details=c.getComputerDetails(); pi=c.getPurchasingInfo(); partitions = (ArrayList)details.getPartitions();  peripherals = c.getPeripherals(); applications=(ArrayList) details.getApplications();user=c.getUser();maxApps=25;%>
		<%if(shadeCount%2==0){%>
			<tr bgcolor="#FFFFFF">
		<%}else{%>
			<tr bgcolor="#EEEEEE">
		<%}%>
			<td nowrap><font size="2">&nbsp;
				<%=c.getName()%>
			</td>
			</font>
			<td nowrap><font size="2">&nbsp;
				<%=c.getMacAddress()%>
			</font>
			</td>
			<td nowrap><font size="2">&nbsp;
				<%=c.getAltMacAddress()%>
			</font>
			</td>	
		</tr>
		<%shadeCount=shadeCount+1; %>

<!-- *************** Do not modify this line of code *************** --><%}%>
</table>



  </body>
</html>
