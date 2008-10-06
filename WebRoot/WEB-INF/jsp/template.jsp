<%@ include file="/WEB-INF/jsp/init.jsp" %>

<link href="<c:url value="/css/cabio_portlet.css"/>" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="<c:url value="/js/cabio_common.js"/>"></script>

<div id="cabio">

<a href="<bean:message key="online.help.url"/>" target="_blank">
    <img src="<c:url value="/images/questionMark.gif"/>" 
        align="left" style="clear:all; margin-right:10px;">
</a>

<img src="<c:url value="/images/sdkLogoSmall.gif"/>" align="right">

<div style="color: #444; margin-bottom: 10px;">
The caBIO system is a repository of data useful in biomedical research. 
This portlet is an easy way to get started with caBIO.<br/>
<a href="http://cabio.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO" target="_blank"> 
Learn more</a> about caBIO and its various APIs.
</div>

<%
	String tab = ParamUtil.getString(request, "tabs1");
	if ("".equals(tab)) {
        tab = (String)session.getAttribute("tab");
        if (tab == null) {
            tab = "Simple Search";
        }
	}
	
    session.setAttribute("tab",tab);
	
	PortletURL portletURL = renderResponse.createRenderURL();
	//portletURL.setWindowState(WindowState.MAXIMIZED);
	portletURL.setParameter("struts_action", "/cabioportlet/view");
	portletURL.setParameter("tabs1", tab);
	
%>

<liferay-ui:tabs
	names="Simple Search,Reports"
	url="<%= portletURL.toString() %>"
	value="<%= tab %>"
/>

<html:errors/>

<tiles:useAttribute id="formContent" 
    name="form_content" classname="java.lang.String" ignore="true" />
    
<% if (formContent != null) { %>
     
    <a href="javascript:caBioCommon.toggleDropBox('.query')" id="query_link" >Report Query Form</a>
    <script>    
    jQuery(document).ready(function(){
        caBioCommon.createDropBox('#query_link');
    });
    </script>

    <jsp:include page="<%= formContent %>" flush="true"/>
<% } %>
    
<tiles:useAttribute id="tilesPortletContent" 
	name="portlet_content" classname="java.lang.String" ignore="true" />

<% if (tilesPortletContent != null) { %>
    <jsp:include page="<%= tilesPortletContent %>" flush="true"/>
<% } %>

<div id="debug"></div>
</div>