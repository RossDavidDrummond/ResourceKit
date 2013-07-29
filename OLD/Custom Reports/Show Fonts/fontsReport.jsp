<%
		/* 
			JSP:  Transform the results of a computer inventory search into a font perspective.
			Written by:  Erin Johnson
			For:  Casper Suite Resource Kit
			Version 2
			Date:  Sept 25, 2008
			Updated: March 16, 2010
		*/
%>
<%@page import="java.lang.Comparable" import="java.util.ArrayList" import="java.text.*" import="com.jamfsoftware.*" import="java.util.Iterator" import="java.util.SortedMap" import="java.util.TreeMap" import="java.util.TreeSet" import="java.util.SortedSet"%>
<%
String searchTime="";
if(request.getAttribute("searchTime")!=null){
	searchTime = "(" + request.getAttribute("searchTime").toString() + ")";
}
ArrayList displayItems = (ArrayList) session.getAttribute("displayItems");
ArrayList computers = (ArrayList) session.getAttribute("computers");
ReconField rf;

ArrayList partitions;
int cnt, i;
Computer c;
ComputerDetails details;
User user;
PurchasingInfo pi;
Partition part;
TreeMap <FontData, TreeSet<ComputerData>> fontList = new TreeMap();
%>	
<%!
	class FontData implements Comparable {
	private String name;
	private String version;
	private boolean suppressed= false;
	private String fontClass;
	
	public FontData(String name, String version, boolean suppressed, String fontClass){
		this.name = name;
		this.version = version;
		this.suppressed = suppressed;
		this.fontClass =fontClass;
	}
	
	public String getFontClass(){
		return fontClass;
	}
	public String getName(){
		return name;
	}
	public String getVersion(){
		return version;
	}
	public boolean isSuppressed(){
		return suppressed;
	}
	
	public int compareTo(Object anotherFont){
		int returnVal = this.name.compareTo(((FontData)anotherFont).name);
		if(returnVal == 0){
			returnVal = this.version.compareTo(((FontData)anotherFont).version);
		}
		
		return returnVal;
		}
	}
 
	

 class ComputerData  implements Comparable {
		String cName;
		int cID;
		
	public ComputerData(String cName, int cID){
			this.cID = cID;
			this.cName = cName;
		}
		public String getName(){
			return cName;
		}
		public int getID(){
			return cID;
		}

		public int compareTo(Object anotherComputer){
			return this.cName.compareTo(((ComputerData)anotherComputer).cName);
		}
	}
	
	public TreeMap AddFonts(TreeMap <FontData, TreeSet<ComputerData>> fontList, String cName, int cID, ArrayList <Font> fonts ){ 
	TreeSet <ComputerData> ts = new TreeSet();
	ComputerData cd = new ComputerData(cName, cID);
	ComputerData cd2;
	FontData fd;
	Iterator <ComputerData> itr;
	Font f;
	boolean found= false;
	//iterate through fonts, see if a font is in fontList. 
	for(int j=0; j<fonts.size(); j++){
		f= fonts.get(j);
		fd = new FontData(f.getName(), f.getVersion(), f.isHidden(), f.getFontClass());
		if(fontList.containsKey(fd)){
			//Font is found, so add the computer name to the font's list
			ts = fontList.get(fd);
			ts.add(cd);
			fontList.put(fd, ts);
		}else{
			//font not found, so add the font, and the computer name to the list
			ts = new TreeSet();
			ts.add(cd);
			fontList.put(fd, ts);
		}
	}
	return fontList;
 }
 
%> 

<html>
	<head>
		<title> Font Distribution Report </title>
		<LINK href="../theme/Master.css" rel="stylesheet">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF8">


	</head>
	<body>
		<%
			TreeSet ts;
			LookupComputerInfo lci = new LookupComputerInfo();
			String fontName;
			//cycle through computers
			for(i=0;i<computers.size();i++){
				c=(Computer)computers.get(i); 
				c=lci.LookupComputerInfo(request, response, c.getID(), true, true, true);
				//grab the font list for computer "c"
				details = c.getComputerDetails();
				
				//add to fonts list
				ArrayList <Font> fonts = (ArrayList) details.getFonts();
				fontList = AddFonts(fontList, c.getName(), c.getID(), fonts);
			}
		
		%>
		
		<center><H1>Font Distribution Report</H1></center>
		<center><H2><%=fontList.size()%> found <%=searchTime%></H2></center>
		

		<table bgcolor="#cccccc" cellspacing="1" cellpadding="1" align="center"> 
			
			<tr valign="bottom">
				<td nowrap align="center"  background="../images/column_header.gif">
					Font Name
				</td>
				<td nowrap align="center"  background="../images/column_header.gif">
					Version
				</td>
				<td nowrap align="center"  background="../images/column_header.gif">
					Suppressed
				</td>
				<td nowrap align="center"  background="../images/column_header.gif">
					Copies
				</td>
				<td nowrap align="center"  background="../images/column_header.gif">
				
				</td>
			</tr>
			
			
			
		<% 
			// this bit pulls the list of font names from the map, then cycle through the list
			//and pull out their font lists.  print said font lists.
			Iterator <FontData> fontNames; 
			Iterator <ComputerData> computerNames;
			boolean done = false;
			FontData fd;
			ComputerData cd;
			String [] rowColour = {"#FFFFFF", "#EEEEEE"};
			int rowNumber =0;
			//going through the fonts
			for(fontNames= fontList.keySet().iterator(); fontNames.hasNext();){
				fd = fontNames.next();
				ts= fontList.get(fd);
				computerNames =  ts.iterator();
				
					%>
					<tr  bgcolor=<%=rowColour[rowNumber%2]%> >
						<td nowrap  >
							<font class="<%=fd.getFontClass()%>"><%=fd.getName()%>  </font>
						</td>
						<td nowrap align="center">
							<font class="<%=fd.getFontClass()%>"><%=fd.getVersion()%></font>
						</td>
							<td nowrap align="center">
							<% if(fd.isSuppressed()){
							%>
								*
							<%}%>
						</td>

						<td nowrap align="center">
							<%=ts.size()%>
						</td>
						<td nowrap align="center">
							<a href="#<%=rowNumber%>"><font size=-2>View Distribution...</font></a>
						</td>
					</tr>
					<%
				rowNumber++;
			}
		%>
		
    </table>
	
	
	<table align="center">
	<tr>
		<td>
		<BR>
		<BR>
		<hr>
		</td>
	</tr>		
	
			<% 
					done = false;
					rowNumber=0;
					ArrayList <String> paths;
					//going through the fonts
					for(fontNames= fontList.keySet().iterator(); fontNames.hasNext();){
					
						fd = fontNames.next();
						ts= fontList.get(fd);
						computerNames =  ts.iterator();
							%>
							<tr>
								<td>
							<a name="<%=rowNumber%>"></a><BR><BR>
							<b>&nbsp;&nbsp;<%=fd.getName()%>
								- 
								<%if(fd.isSuppressed()){ %>
									<font color="red"> Suppressed </font> -
									
								<%}%>
								
								<%
								if(ts.size()==1){
										%>1 Match <%
								}else{%>
									<%=ts.size()%> Matches 
								<%}%>
							|
							</b> 
							<a href="#top"><font size="-2">Back to top</font></a><BR>
							&nbsp;&nbsp;
							<BR>
							<center><table bgcolor="#cccccc" cellspacing="1	" cellpadding="0">
								<tr valign="top">	
									<jamf:tableHeader><font size="-2" color="black">Computer Name</font></jamf:tableHeader>
									<jamf:tableHeader></jamf:tableHeader>
								</tr>
	
							<%
							//going through the list of computers and printing their names
							while(computerNames.hasNext()){
								i=0;
								cd = computerNames.next();
								%>
									<tr  bgcolor=<%=rowColour[i%2]%> >
										<td><center> <%=cd.getName()%> </center></td>
									<td> <a name="<%=cd.getID()%>"></a><a href="../viewComputer.html?computer_id=<%=cd.getID()%>"><font size=-2> Details </font></a> </td>
								</tr>
								<%
								
								
								i++;
							}
						%>
						</table></center><%
					rowNumber++;
				}%>
		</table><
	</body>
</html>
