<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

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
<!-- end of logo --> 

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
	System.out.println("searchString: "+ searchString);

%>

<HR COLOR=BLUE>
<form method=post action="searchService.jsp" name=form1>
<table width="100%">
	<tr valign="top" align="center">
		<td>
 			<img src="images/largesearchlogo.jpg" name="caCORE Search API" border="0" align=middle>
 		</td>
 		</tr>
 		
 				
 		<tr>
 		<td align=center>
 			<INPUT TYPE=TEXT SIZE=60 id="freestyleLM" name="searchString" value="<%=searchString%>">					
			<INPUT TYPE=SUBMIT NAME="search" VALUE="Search">
 		</td>
 		<tr>
 		</table>
	    <script type="text/javascript">
	    jQuery(function() {
	        jQuery("#freestyleLM").suggest("suggest",{minchars:1});
	    });
	    </script>
 		<table align=center>
		<tr>
		 		<td> <INPUT TYPE=RADIO VALUE=WITH_ALL NAME=WORDS> match all words<br>
		 		     <INPUT TYPE=RADIO VALUE=WITH_ANY NAME=WORDS CHECKED> match any of the words<br>
		 		     <INPUT TYPE=RADIO VALUE=EXCLUDE NAME=EXCLUDE CHECKED> exclude word
		 		     <INPUT TYPE=TEXT name="EXCLUDE_TEXT" value="" >
		 		</td>
		 		</tr>
 		<tr>
 		<td>
 			<INPUT TYPE=CHECKBOX NAME="FULL_TEXT_SEARCH" VALUE="FULL_TEXT_SEARCH" CHECKED/>Full Text Search
 		</td>
 		</tr>
  		<tr>
  		<td >
  			<INPUT TYPE=CHECKBOX NAME="FUZZY_SEARCH" VALUE="YES"/>Fuzzy Search
  		</td>
 		</tr>
 		<tr>
  		<td>
  			Number of records per page <SELECT NAME="PAGE_SIZE">
  			<OPTION>10</OPTION>
  			<OPTION>20</OPTION>
  			<OPTION>25</OPTION>
  			<OPTION>50</OPTION>
  			<OPTION>75</OPTION>
  			<OPTION>100</OPTION>
  			<OPTION>500</OPTION>
  			<OPTION Selected>1000</OPTION>
  			</SELECT>
  		</td>
 		</tr> 	
</table>
	
</form>
<HR COLOR=BLUE>

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
