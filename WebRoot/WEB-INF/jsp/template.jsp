<%@ include file="/WEB-INF/jsp/init.jsp" %>

<link href="<c:url value="/css/cabio_portlet.css"/>" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="<c:url value="/js/cabio_common.js"/>"></script>

<div id="cabio">

<%
	String tabs1 = ParamUtil.getString(request, "tabs1", "Reports");
	PortletURL portletURL = renderResponse.createRenderURL();
	//portletURL.setWindowState(WindowState.MAXIMIZED);
	portletURL.setParameter("struts_action", "/cabioportlet/view");
	portletURL.setParameter("tabs1", tabs1);
%>

<liferay-ui:tabs
	names="Simple Search,Reports,Advanced Search"
	url="<%= portletURL.toString() %>"
	value="<%= tabs1 %>"
/>

<html:errors/>

<tiles:useAttribute id="formContent" 
    name="form_content" classname="java.lang.String" ignore="true" />
    
<% if (formContent != null) { %>
    
    <script>    
	jQuery(document).ready(function(){
	    caBioCommon.createDropBox('#query_link');
	});
    </script>
    <a id="query_link" href="javascript:caBioCommon.toggleDropBox('.query')">Query Form</a>

    <jsp:include page="<%= formContent %>" flush="true"/>
<% } %>
    
<tiles:useAttribute id="tilesPortletContent" 
	name="portlet_content" classname="java.lang.String" ignore="true" />

<% if (tilesPortletContent != null) { %>
    <jsp:include page="<%= tilesPortletContent %>" flush="true"/>
<% } %>

<div id="debug"></div>
</div>