<%@page contentType="text/html"%>
<%@ page import="gov.nih.nci.search.SearchResult,
         gov.nih.nci.system.web.util.IndexSearchUtils,
         gov.nih.nci.system.util.FormatUtils,
         java.util.*" %>
<html>
<head>
<title>FreestyleLM Results</title>

<link href="styleSheet_flm.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.suggest.css" />

<script src="js/jquery-1.2.3.min.js" type="text/javascript"></script>
<script src="js/jquery.bgiframe.js" type="text/javascript"></script>
<script src="js/jquery.dimensions.min.js" type="text/javascript"></script>
<script src="js/jquery.suggest.js" type="text/javascript"></script>
<script src="js/dropdowntabs.js" type="text/javascript"></script>

<style>

div.results {
    margin-left: 20px; 
    margin-right: 20px;
}

table.fsResults {
    border-collapse: collapse;
}

table.fsResults th {
    border: 1px solid #AAAAAA;
    background-color: #FAF8CC;
    padding: 2px;
    vertical-align: top;
    font: bold 0.8em Verdana, sans-serif;
}

table.fsResults td {
    border: 1px solid #AAAAAA;
    padding: 4px;
    vertical-align: top;
    font: 0.9em Verdana, sans-serif;
    /*word-break: break-all;*/
}

table.fsResults td a {
    color: #04346C;
}

table.fsResults td a:visited {
    color: #274E7D;
}

div.topPager {
    float: right;
    font: 0.8em Verdana, sans-serif;
}

div.bottomPager {
    width: 100%;
    text-align: left;
    margin-top: 10px;
    font: 0.8em Verdana, sans-serif;
}

div.classHeader {
    margin-top: 15px;
    margin-bottom: 10px;
    font: bold 0.8em Verdana, sans-serif;
}

/* Tabbed Menu */

#foldertab {
    border-bottom: 1px solid #274e7d; /* Main background color */
    font: bold 11px Verdana, sans-serif;
    margin-left: 0;
    margin-top: 20px;
    padding: 3px 0 3px 8px;
    white-space: nowrap;
}

#foldertab li {
    list-style: none;
    margin: 0;
    display: inline;
}

#foldertab li a  {
    padding: 3px 0.5em;
    margin-left: 3px;
    border: 1px solid #274e7d; /* Main background color */
    border-bottom: none;
    text-decoration: none;
    background-color: #274e7d; /* Main background color */
    color: white;
}

#foldertab li a.current {
    background: white;
    border-bottom: 1px solid white;
    color: black;
}

#foldertab li a.current:link, #foldertab li a.current:visited {
    color: black;
}
#foldertab li a.current:hover {
    background: white;
    border-bottom: 1px solid white;
    color: black;
}
#foldertab li a:hover {
    background: #04346C; /* Hover background color */
    color: white;
}

/* Drop Down Menu */

.dropmenu {
    position:absolute;
    top: 0;
    border: 1px solid #042B59; /* Hover background color */
    border-width: 0 1px;
    line-height:18px;
    z-index:100;
    background-color: #274e7d; /* Main background color */
    width: 200px;
    visibility: hidden;
}

.dropmenu a, .dropmenu a:visited {
    font: bold 11px Verdana, sans-serif;
    width: auto;
    display: block;
    text-indent: 5px;
    border: 0 solid #042B59; /* Hover background color */
    border-bottom-width: 1px;
    padding: 4px 0;
    text-decoration: none;
    color: white;
}

.dropmenu a:hover { 
    background-color: #042B59; /* Hover background color */
    color: white;
}

* html .dropmenu a { /* IE only hack */
    width: 100%;
}

</style>

</head>
<body>

<!-- NIH header begins -->
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
<!-- NIH header ends -->

<%
	IndexSearchUtils searchUtils = (IndexSearchUtils)session.getAttribute("indexSearchUtils");
	List results = searchUtils.getDisplayResults();
	String searchString = request.getParameter("searchString");
    String targetClass = searchUtils.getTargetClass();
	int pageSize = searchUtils.getPageSize();
	String searchURL = searchUtils.getSearchURL();
	
%>
<table width="100%">
<tr>
	<td valign="top" width="200">
	   <a href="indexSearch.jsp">
	       <img src="images/smallsearchlogo.jpg" name="FreestyleLM Search" border="0" align=middle>
	   </a>
	</td>
		
	<td valign="middle">
        <form method="GET" action="IndexService">
		<input type="TEXT" size="60" id="freestyleLM" name="searchString" value="<%=searchString%>">
		<a href="https://wiki.nci.nih.gov/display/ICR/Apache+Lucene+Query+Syntax+for+FreestyleLM+Search" target="_BLANK"><img src="images/help.png" alt="Lucene Query Syntax" name="Lucene Query Syntax" border="0" align="middle"></a>					
		<input type="submit" name="submit" value="Search">
		</form>
	</td>
</tr>
</table>
 
<div id="bluemenu">
<ul id="foldertab">
<%
	String allCssClass = "".equals(targetClass) ? "current":"";
	%>
	<li><a href="<%=searchURL%>&startIndex=0" class="<%=allCssClass%>">All (<%=searchUtils.getTotalResultCount()%>)</a></li>
	<%
	// Maximum number of items to display as tabs, 
	// not including the "All" and "More..." tabs
	final int MAX_TABS = 4; 
	
	Map counts = searchUtils.getCounts();
	List classes = searchUtils.getClasses();
	List tabClasses = new ArrayList();
	List menuClasses = new ArrayList();
	for(int i=0; i<classes.size(); i++) {
	    String className = (String)classes.get(i);
	    if (i<MAX_TABS || className.equals(targetClass)) {
	        tabClasses.add(className);
	    }
	    else {
	        menuClasses.add(className);
	    }
	}
	
	if (menuClasses.size() < 3) {
	    // If there is only one class in the menu then there is no point in having it.
	    // If there are two classes then the menu will disappear when one of those 
	    // classes is selected, so it's less confusing to not have a menu at all.
	    menuClasses.clear();
	    tabClasses = classes;
	}
	
	// Print the tabs 
	
	for(int i=0; i<tabClasses.size(); i++) {
	    String className = (String)tabClasses.get(i);
	    Integer count = (Integer)counts.get(className);
	    String classDisplayName = FormatUtils.formatCamelCaseAsLabel(className.substring(className.lastIndexOf(".")+1));
	    String cssClass = className.equals(targetClass) ? "current" : "";
	    
	    %><li><nobr><a href="<%=searchURL%>&targetClass=<%=className%>&startIndex=0" class="<%=cssClass%>"><%=classDisplayName%> (<%=count%>)</a></nobr></li>
	    <%
	}
	
	// Print a "More..." tab if necessary
	
	if (!menuClasses.isEmpty()) {
	    %><li><a rel="dropmenu1">More...</a></li><%
	}
%>
</ul>
</div>
<%
// Print a dropdown menu if necessary

if (!menuClasses.isEmpty()) {
    %><div id="dropmenu1" class="dropmenu"><%
    for(int i=0; i<menuClasses.size(); i++) {
        String className = (String)menuClasses.get(i);
        Integer count = (Integer)counts.get(className);
        String classDisplayName = FormatUtils.formatCamelCaseAsLabel(className.substring(className.lastIndexOf(".")+1));
        
        %><nobr><a href="<%=searchURL%>&targetClass=<%=className%>&startIndex=0"><%=classDisplayName%> (<%=count%>)</a></nobr>
        <%
    }
    %></div><%
}
%>

<script type="text/javascript">
jQuery(function() {
    jQuery("#freestyleLM").suggest("suggest",{minchars:1});
});
tabdropdown.init("bluemenu", 3);
</script>

<table width="100%"><tr><td width="10"></td><td>
<div class="topPager">
<%
if(searchUtils.getResultCount() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex()>= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%> <a href="<%=searchURL%>&targetClass=<%=targetClass%>&startIndex=<%=preStartIndex%>">previous</a> <%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCount()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %> <a href="<%=searchURL%>&targetClass=<%=targetClass%>&startIndex=<%=nextStartIndex%>">next</a> <%
	}
}
%>
</div>

<%
String queryUrl = request.getContextPath()+"/GetHTML?query=";
String preClassName = "";
List props = null;

for(int i=0; i<results.size(); i++){	
	SearchResult result = (SearchResult)results.get(i);	
	String className = result.getClassName();
    String classDisplayName = className.substring(className.lastIndexOf(".")+1);
	String id = result.getId()!=null?result.getId():null;
	String queryString = queryUrl + className +"[id="+id+"]";	
	if(preClassName.equals("") || !preClassName.equals(className)){	
	  
	    if (i>0) {
	       %></table><%
	    }
	  
		%><div class="classHeader"><%=className%></div><%
        %><table class="fsResults" width="100%"><tr><%       
        %><th>Class/Id</th><%
        props = new ArrayList();
		for(Iterator it=result.getProperties().keySet().iterator();it.hasNext();){
			String key = (String) it.next();					
			if(!key.equalsIgnoreCase("_hibernate_class") && !key.equalsIgnoreCase("id")){
				%>						
				<th><%=FormatUtils.formatCamelCaseAsLabel(key)%></th>						
				<%
				props.add(key);
			}
		}
		%></tr><%
	}
	%><tr>
	<td><a href="<%=queryString%>" target="_blank"><%=classDisplayName%>#<%=id%></a></td>		
	<%
	for(int x=0; x<props.size(); x++){
		String key = (String)props.get(x);
		String value = " - ";
		if(result.getProperties().get(key)!=null) {
			value = (String)result.getProperties().get(key);
		}
		%>
		<td><%=value%></td>						
		<%
	}
	%></tr><%	
	preClassName = className;
}
%></table>

<div class="bottomPager">
<%
if(searchUtils.getResultCount() >= pageSize){
	if(searchUtils.getStartIndex() > 0 && searchUtils.getStartIndex() >= pageSize){
	    int preStartIndex = searchUtils.getStartIndex() - pageSize;
		%> <a href="<%=searchURL%>&targetClass=<%=targetClass%>&startIndex=<%=preStartIndex%>">previous</a> <%
	}
	int end = searchUtils.getStartIndex() + pageSize -1;	
	int sindex = searchUtils.getStartIndex() + 1;
	int eindex = end + 1;
	%>
	<%=sindex%> to <%=eindex%> 
	<%
	if((searchUtils.getStartIndex()+ pageSize) < searchUtils.getResultCount()){
	    int nextStartIndex = searchUtils.getStartIndex() + pageSize;
	    %> <a href="<%=searchURL%>&targetClass=<%=targetClass%>&startIndex=<%=nextStartIndex%>">next</a> <%
	}
}
	%>
</div>

</td><td width="10"></td></tr></table>

<br>
<hr>

<!-- NIH footer begins -->
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
<!-- NIH footer ends -->

</body>
</html>