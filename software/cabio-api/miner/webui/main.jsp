<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gov.nih.nci.system.web.util.JSPUtils"%>
<%
	JSPUtils jspUtils= JSPUtils.getJSPUtils(config.getServletContext());
	boolean isSecurityEnabled = jspUtils.isSecurityEnabled();
%>

<html>
<head>
    <title>caBIO Home Page</title>

    <jsp:include page="/webui/ajax/commonInclude.jsp"/>
	
	<link rel="stylesheet" type="text/css" href="styleSheet.css" />
    <link rel="icon" type="image/x-ico" href="favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />		
	<script src="script.js" type="text/javascript"></script>
    
    <link rel="stylesheet" type="text/css" href="<s:url value="/struts/tabs.css"/>">
    <link rel="stylesheet" type="text/css" href="<s:url value="/struts/niftycorners/niftyCorners.css"/>">
    <link rel="stylesheet" type="text/css" href="<s:url value="/struts/niftycorners/niftyPrint.css"/>" media="print">
    <script type="text/javascript" src="<s:url value="/struts/niftycorners/nifty.js"/>"></script>
    <script type="text/javascript">
        dojo.event.connect(window, "onload", function() {
            if (!NiftyCheck())
                return;
            Rounded("li.tab_selected", "top", "white", "transparent", "border #ffffffS");
            Rounded("li.tab_unselected", "top", "white", "transparent", "border #ffffffS");
            //                Rounded("div#tab_header_main li","top","white","transparent","border #ffffffS");
            // "white" needs to be replaced with the background color
        });
    </script>
</head>

<s:url id="ajaxHome" value="AjaxHome.action" />
<s:url id="simpleSearchTab" value="SimpleSearchTab.action" />
<s:url id="advSearchTab" value="AdvSearchTab.action" />
<s:url id="ajaxTest" value="/AjaxHome.action" />


<body>
<table summary="" cellpadding="0" cellspacing="0" border="0"
	width="100%" height="100%">

	<%@ include file="include/header.inc"%>
	<%@ include file="include/applicationHeader.inc"%>
    <tr><td height="100%" align="left" valign="top">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td align="top">
                <!--// START SNIPPET: tabbedpanel-tag-->
                <s:tabbedPanel id="test2" theme="simple" cssStyle="width:100%; height:450px;" doLayout="true">
                      <s:div theme="ajax"  id="home" label="Home" href="%{ajaxHome}" />                      
                      <s:div theme="ajax"  href="%{simpleSearchTab}" id="ryh1" label="Simple Search" />
                      <s:div theme="ajax"  href="%{advSearchTab}" id="advsearch" label="Advanced Search" />                      
                      <s:div theme="ajax"  id="viewresultsTab" cssStyle="display: none" label="View Results">
                          Search Results:
                          <div id='searchresults' style="border: 1px solid yellow;display:block">&nbsp;</div>
                      </s:div>
                  </s:tabbedPanel>
                <!--// END SNIPPET: tabbedpanel-tag-->
             </td>
        </tr>
    </table>
    </td></tr>
	<tr>
		<td height="20" class="footerMenu">

			<!-- application ftr begins -->
			<%@ include file="include/applicationFooter.inc"%>
			<!-- application ftr ends -->

		</td>
	</tr>
    
	<tr><td>
		<%@ include file="include/footer.inc"%>
	</td></tr>
</table>

</body>
</html>
