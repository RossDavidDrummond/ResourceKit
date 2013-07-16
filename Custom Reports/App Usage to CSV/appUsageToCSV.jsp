<%@page import="java.util.*" import="java.text.*" import="com.jamfsoftware.*" %><%
ArrayList<Computer> computers = (ArrayList<Computer>)session.getAttribute("computers");
ArrayList<ReconField> displayItems = (ArrayList<ReconField>)session.getAttribute("displayItems");
Computer c;
ReconField rf;
String entry="";

int macIndex=-1;
for(int cnt=0;cnt<displayItems.size();cnt++){
	rf=(ReconField)displayItems.get(cnt);
	
	if(!rf.getAbbr().equals("")){
		entry+="\"";
		entry+=rf.getAbbr();
		entry+="\"";
		
		if(cnt!=displayItems.size()-1){
			entry+=",";
		}
	
	}
}


entry +="\n";
%><%=entry%><%

for(int cnt=0;cnt<computers.size();cnt++)
{
	c=(Computer)computers.get(cnt);
	List<ApplicationUsageLog> appUsageLogs = new LookupApplicationUsageLogs().LookupApplicationUsageLogsByComputerId(request, response, c.getID(), 30, true);
	if (appUsageLogs == null || appUsageLogs.size() > 0)
	{
		for (int ii = 0; ii < appUsageLogs.size(); ii++)
		{
			entry="";
			ApplicationUsageLog appUsage = appUsageLogs.get(ii);
			for(int j=0;j<displayItems.size();j++)
			{
				rf=(ReconField)displayItems.get(j);
				if(!rf.getName().equals("Live LDAP Lookups") && !rf.getName().equals("Info Link") )
				{
					entry+="\"";
					entry+=rf.getValue(c);
					entry+="\"";
					
					if(j!=displayItems.size()-1){
						entry+=",";
					}
				}
			}
			entry+=",\"";
			entry += appUsage.getApplicationName();
			entry+="\"";
			entry+=",\"";
			entry += appUsage.getDisplayForegroundTime();
			entry+="\"";
			entry +="\n";
			%><%=entry%><%
		}
	}
	else
	{
		entry="";
		for(int j=0;j<displayItems.size();j++)
		{
			rf=(ReconField)displayItems.get(j);
			if(!rf.getName().equals("Live LDAP Lookups") && !rf.getName().equals("Info Link") )
			{
				entry+="\"";
				entry+=rf.getValue(c);
				entry+="\"";
				
				if(j!=displayItems.size()-1){
					entry+=",";
				}
			}
		}
		entry+=",,";
		entry +="\n";
		%><%=entry%><%
	}
}%>
