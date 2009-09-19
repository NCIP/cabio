<%@page contentType="text/html"%>
<HTML>
<HEAD>
<title>FreestyleLM Search</title>
<link href="styleSheet.css" type="text/css" rel="stylesheet" />
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

<%@ page import="gov.nih.nci.search.*,
		 gov.nih.nci.common.util.*,	
		 gov.nih.nci.system.applicationservice.*,
		 java.lang.reflect.*,
		 java.util.*" %>
<%
	String searchString = "";
	if(request.getParameter("searchString")!= null){
		searchString = request.getParameter("searchString");		
	}
%>

<br>
<form method="POST" action="IndexService">
<table width="100%">
	<tr valign="top" align="center">
		<td>
 			<img src="images/largesearchlogo.png" name="caCORE Search API" border="0" align="middle">
 		</td>
	</tr>
 		
	<tr>
 		<td align=center>
 			<input type="text" size="60" id="freestyleLM" name="searchString" value="<%=searchString%>">					
			<input type="submit" name="search" value="Search">
 		</td>
 	<tr>
 	</table>
	<table align=center>
	<tr>
		<td> 
		    Match Terms: 
		    <input type="radio" value="any" name="words" checked="checked"/> any
		    <input type="radio" value="all" name="words"/> all 
		    <br>
		    Exclude: <input type="text" name="excludeText" value=""/>
		</td>
	</tr>
	<tr>
	<td>View: 
	     <input type="radio" name="viewType" value="simple" checked="checked"/> simple
	     <input type="radio" name="viewType" value="objects"/> objects
	</td>
	</tr>
		<tr>
		<td >
			<input type="checkbox" NAME="fuzzy" VALUE="1"/> Fuzzy Search
		</td>
	</tr>
	<tr>
		<td>
			Results per page: <select name="pageSize">
			<option>10</option>
			<option>20</option>
			<option>25</option>
			<option>50</option>
			<option>75</option>
			<option selected="selected">100</option>
			<option>500</option>
			<option>1000</option>
			</select>
		</td>
	</tr> 	
</table>
	
</form>

<script type="text/javascript">
jQuery(function() {
    jQuery("#freestyleLM").suggest("suggest",{minchars:1});
});
</script>
    
<br>
<hr>

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
