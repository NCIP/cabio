<%@ include file="/WEB-INF/jsp/init.jsp" %>

<link href="<c:url value="/css/cabio_portlet.css"/>" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="<c:url value="/js/cabio_common.js"/>"></script>

<div id="cabio">

<a href="<bean:message key="online.help.url"/>" target="_blank">
    <img src="<c:url value="/images/questionMark.gif"/>" 
        style="float: right; margin-left: 8px;"/>
</a>

<div style="color: #444;">
<img src="<c:url value="/images/sdkLogoSmall.gif"/>" style="float: left; margin-right: 8px;"/>
The <span class="link-extenal"><a href="<bean:message key="link.cabio.portlet"/>" target="_blank">caBIO portlet</a></span>
&nbsp;is a portal user interface built on top of the caBIO APIs. 
<span class="link-extenal"><a href="<bean:message key="link.cabio.api"/>" target="_blank">caBIO</a></span> 
&nbsp;is a repository of data useful in biomedical research, compiled from multiple primary sources. 
</div>

<div style="clear: both; margin-bottom: 10px;"></div>

<%
	String tab = ParamUtil.getString(request, "tabs1");
	if ((tab == null) || "".equals(tab)) {
        tab = (String)session.getAttribute("tab");
        if ((tab == null) || "".equals(tab)) {
            tab = "Simple Search";
        }
	}
	
	PortletURL portletURL = renderResponse.createRenderURL();
	portletURL.setParameter("struts_action", "/cabioportlet/view");
	portletURL.setParameter("tabs1", tab);
	
    session.setAttribute("tab",tab);
    session.setAttribute("portletURL",portletURL);
%>

<script language="javascript">
    var PROXY_URL = "/cabioportlets/proxy";
    var GETHTML_URL = '<bean:message key="cabio.restapi.url"/>GetHTML?query=';
    var DETAILS_URL = '<c:url value="/objectDetails"/>';
</script>

<liferay-ui:tabs
	names="Simple Search,Templated Searches,About"
	url="<%= portletURL.toString() %>"
	value="<%= tab %>"
/>

<html:errors/>

<tiles:useAttribute id="formContent" 
    name="form_content" classname="java.lang.String" ignore="true" />
    
<% if (formContent != null) { %>
     
	<tiles:useAttribute id="queryName" 
	    name="query_name" classname="java.lang.String" ignore="true" />
    
    <a href="javascript:caBioCommon.toggleDropBox('.query')" id="query_link">
        <c:out value="${queryName}"/></a>
        
    <script>    
    jQuery(document).ready(function(){
        caBioCommon.createDropBox('#query_link');
        jQuery("#page").val("0");
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