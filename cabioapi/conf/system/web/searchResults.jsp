<%@page contentType="text/html"%>
<HTML>
<HEAD>
<title>SearchIndex</title>
<link href="styleSheet_flm.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.suggest.css" />
<script src="js/jquery-1.2.3.min.js" type="text/javascript"></script>
<script src="js/jquery.bgiframe.js" type="text/javascript"></script>
<script src="js/jquery.dimensions.min.js" type="text/javascript"></script>
<script src="js/jquery.suggest.js" type="text/javascript"></script>
</HEAD>
<BODY>

<!-- nci hdr begins -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="hdrBG">
        <tr>
          <td width="283" height="37" align="left">
          <a href="http://www.cancer.gov"><img alt="National Cancer Institute" src="images/logotype.gif" width="283" height="37" border="0"/></a>
          </td>          
          <td width="295" height="37" align="right">
          <a href="http://www.cancer.gov"><img alt="U.S. National Institutes of Health | www.cancer.gov" src="images/tagline.gif" width="295" height="37" border="0"/></a>
          </td>
        </tr>
      </table>
  
  <!-- nci hdr ends -->
<!-- end of logo --> 

<%@ page import="gov.nih.nci.search.*,
		 gov.nih.nci.system.web.util.*,
		 java.util.*" %>
<%
	IndexSearchUtils searchUtils = (IndexSearchUtils)session.getAttribute("indexSearchUtils");
	List results = searchUtils.getDisplayResults();
	String searchString = searchUtils.getSearchQuery().getKeyword();
	int pageSize = searchUtils.getPageSize();
	String recordNumber = request.getParameter("recordNumber")!= null?request.getParameter("recordNumber"):null;
	
	String startIndex = request.getParameter("startIndex")!=null?request.getParameter("startIndex"):null;
	
%>
<form method=post action="searchService.jsp" name=form1>
<table width="100%">
	<tr valign="top" align="left">
	<%
	String adrs = request.getContextPath()+"/indexSearch.jsp";
	%>
		<td><a href="<%=adrs%>">
 			<img src="images/smallsearchlogo.jpg" name="caCORE Search API" border="0" align=middle>
 			</a>
 		</td>
 		
 		<td align=left valign=top>
                <table>
                  <tr><td>
 			<INPUT TYPE=TEXT SIZE=60 id="freestyleLM" name="searchString" value="<%=searchString%>">
 			<a href="https://wiki.nci.nih.gov/display/ICR/Apache+Lucene+Query+Syntax+for+FreestyleLM+Search"><img src="images/help.png" alt="Lucene Query Syntax" name="Lucene Query Syntax" border="0" align=middle></a>					
			<INPUT TYPE=SUBMIT NAME="submit" VALUE="Search">
			<INPUT TYPE=HIDDEN NAME="FULL_TEXT_SEARCH" value="FULL_TEXT_SEARCH">
                  </td></tr>
                </table>
 		</td>
 	</tr>
    <script type="text/javascript">
    jQuery(function() {
        jQuery("#freestyleLM").suggest("suggest",{minchars:1});
    });
    </script>
<tr bgColor="#FAF8CC"><td align=left width=25%><%=searchUtils.getResultCounter()%> records found</td><td align=right>
<%
if(startIndex != null){
	searchUtils.setStartIndex(Integer.parseInt(startIndex));
	results = searchUtils.getDisplayResults();
}

if(searchUtils.getResultCounter() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex()>= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%><a href="searchService.jsp?startIndex=<%=preStartIndex%>"> previous </a><%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCounter()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %><a href="searchService.jsp?startIndex=<%=nextStartIndex%>"> next </a><%
	}
}

%></td><tr>
</table>
</form>

<table>
<%

String queryUrl = request.getContextPath()+"/GetHTML?query=";
int recordCounter = 0;
if(recordNumber != null){
	recordCounter = Integer.parseInt(recordNumber);
}
if(searchUtils.getSearchQuery().getQueryType().equals("FULL_TEXT_SEARCH")){
String preClassName = "";

	for(int i=0; i<results.size(); i++){	
		SearchResult result = (SearchResult)results.get(i);	
		String className = result.getClassName();
		Integer hit = result.getHit();
		String id = result.getId()!=null?result.getId():null;
		String queryString = queryUrl + className +"[id="+id+"]";		
		String[] propString = new String[result.getProperties().size()];
		if(preClassName.equals("") || !preClassName.equals(className)){	
		
			%><table><tr><td><br><div class="formTitle">Class: <%=className%></div></td></tr></table><%
				//display heading
				%><table border=1 style="word-break:break-all;table-layout:fixed"><%
				%><tr><th bgcolor="#FAF8CC" width="325" cellpadding=2><div class="para"><i><b>Class</b></i></div></th><%
				int propCount = result.getProperties().size();				
				int pCount = 0;
				for(Iterator it=result.getProperties().keySet().iterator();it.hasNext();){
					String key = (String) it.next();					
					if(!key.equalsIgnoreCase("_hibernate_class")){
						%>						
						<th bgcolor="#FAF8CC" width="325" cellpadding=2 ><div class="para"><i><b><%=key%></b></i></div></th>						
						<%
						propString[pCount] = new String(key);
						pCount++;
					}
				}
				session.setAttribute("keyProperties",propString);
				%></tr><%
			
		
		}
		%><tr><%			
		//display data
		%>
		<td><font color=blue><a href="<%=queryString%> target='_BLANK'"><div class="heading"><%=hit%>.<%=className%></div></a></font></td>			
		<%
		propString = (String[])session.getAttribute("keyProperties");
		for(int x=0; x<propString.length; x++){
			String key = propString[x];
			String value = " - ";
			if(result.getProperties().get(key)!=null){
				value = (String)result.getProperties().get(key);
			}		
			
			
				%>
				<td cellpadding=2><div class="para"><%=value%></div></td>						
				<%
			
		}
		%></tr><%		
		preClassName = className;
	}
%></table><%		
}
if(searchUtils.getResultCounter() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex()>= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%><a href="searchService.jsp?startIndex=<%=preStartIndex%>"> previous </a><%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCounter()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %><a href="searchService.jsp?startIndex=<%=nextStartIndex%>"> next </a><%
	}
}
	%>
</table>


<br>
<hr>
<br>
<!-- footer begins -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ftrTable">
        <tr>
          <td valign="top">
            <div align="center">
              <a href="http://www.cancer.gov/"><img src="images/footer_nci.gif" width="63" height="31" alt="National Cancer Institute" border="0"/></a>
              <a href="http://www.dhhs.gov/"><img src="images/footer_hhs.gif" width="39" height="31" alt="Department of Health and Human Services" border="0"/></a>
              <a href="http://www.nih.gov/"><img src="images/footer_nih.gif" width="46" height="31" alt="National Institutes of Health" border="0"/></a>
              <a href="http://www.firstgov.gov/"><img src="images/footer_firstgov.gif" width="91" height="31" alt="FirstGov.gov" border="0"/></a>
            </div>
          </td>
        </tr>
      </table>
  <!-- footer ends -->

</BODY>
</HTML>