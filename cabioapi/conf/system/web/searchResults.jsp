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

<style>
#extraSummary {
  display: none;
}
</style>

</HEAD>
<BODY>

<script>
function showExtraSummary() {
    jQuery("#extraSummary").show();
    jQuery("#extraSummaryButton").hide();
}
</script>

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
    String targetClass = searchUtils.getTargetClass();
	int pageSize = searchUtils.getPageSize();
	
%>
<table width="100%">
<tr>
	<td valign="top" align="left">
	   <a href="indexSearch.jsp">
	       <img src="images/smallsearchlogo.jpg" name="FreestyleLM Search" border="0" align=middle>
	   </a>
	</td>
		
	<td valign="top" align="left">
        <form method="post" action="IndexService">
		<INPUT TYPE=TEXT SIZE=60 id="freestyleLM" name="searchString" value="<%=searchString%>">
		<a href="https://wiki.nci.nih.gov/display/ICR/Apache+Lucene+Query+Syntax+for+FreestyleLM+Search"><img src="images/help.png" alt="Lucene Query Syntax" name="Lucene Query Syntax" border="0" align=middle></a>					
		<INPUT TYPE=SUBMIT NAME="submit" VALUE="Search">
		<INPUT TYPE=HIDDEN NAME="FULL_TEXT_SEARCH" value="FULL_TEXT_SEARCH">
		</form>
	</td>
</tr>
</table>

<script type="text/javascript">
	jQuery(function() {
	    jQuery("#freestyleLM").suggest("suggest",{minchars:1});
	});
</script>
 
<table width="100%">
<tr bgColor="#FAF8CC">

<td>
<div class="summary">
<%=searchUtils.getTotalResultCount()%> 

<%
if ("".equals(targetClass)) {
    %>Total<%
} else {
    %><a href="IndexService?startIndex=0">Total</a><%
}

Map counts = searchUtils.getCounts();
List classes = searchUtils.getClasses();
for(int i=0; i<classes.size(); i++) {
    String className = (String)classes.get(i);
    Integer count = (Integer)counts.get(className);
    String classDisplayName = className.substring(className.lastIndexOf(".")+1);
    
    if (i == 9) {
        %><span id="extraSummaryButton">, <a href="#" onclick="showExtraSummary()">more...</a></span><span id="extraSummary"><%
    }
    
    %>, <nobr><%=count%> <%
    
    if (className.equals(targetClass)) {
        %><%=classDisplayName%></nobr><%
    } else {
        %><a href="IndexService?targetClass=<%=className%>&startIndex=0"><%=classDisplayName%></a></nobr><%
    }
}

%>
</span></div>
</td>

<td align="right" valign="top"><nobr>
<%
if(searchUtils.getResultCount() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex()>= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%><a href="IndexService?targetClass=<%=targetClass%>&startIndex=<%=preStartIndex%>"> previous </a><%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCount()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %><a href="IndexService?targetClass=<%=targetClass%>&startIndex=<%=nextStartIndex%>"> next </a><%
	}
}
%>
</nobr></td>

<tr>
</table>

<table>
<%

String queryUrl = request.getContextPath()+"/GetHTML?query=";

if(searchUtils.getSearchQuery().getQueryType().equals("FULL_TEXT_SEARCH")){
    String preClassName = "";

    List props = null;

	for(int i=0; i<results.size(); i++){	
		SearchResult result = (SearchResult)results.get(i);	
		String className = result.getClassName();
		Integer hit = result.getHit();
		String id = result.getId()!=null?result.getId():null;
		String queryString = queryUrl + className +"[id="+id+"]";	
		if(preClassName.equals("") || !preClassName.equals(className)){	
		  
			%><table><tr><td><br><div class="formTitle">Class: <%=className%></div></td></tr></table><%
				//display heading
				%><table border=1 style="word-break:break-all;table-layout:fixed"><%
				%><tr><th bgcolor="#FAF8CC" width="325" cellpadding=2><div class="para"><i><b>Class</b></i></div></th><%
                props = new ArrayList();
				for(Iterator it=result.getProperties().keySet().iterator();it.hasNext();){
					String key = (String) it.next();					
					if(!key.equalsIgnoreCase("_hibernate_class")){
						%>						
						<th bgcolor="#FAF8CC" width="325" cellpadding=2 ><div class="para"><i><b><%=key%></b></i></div></th>						
						<%
						props.add(key);
					}
				}
				%></tr><%
		}
		%><tr><%			
		//display data
		%>
		<td><font color=blue><a href="<%=queryString%> target='_BLANK'"><div class="heading"><%=hit%>.<%=className%></div></a></font></td>			
		<%
		for(int x=0; x<props.size(); x++){
			String key = (String)props.get(x);
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
if(searchUtils.getResultCount() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex()>= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%><a href="IndexService?targetClass=<%=targetClass%>&startIndex=<%=preStartIndex%>"> previous </a><%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCount()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %><a href="IndexService?targetClass=<%=targetClass%>&startIndex=<%=nextStartIndex%>"> next </a><%
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