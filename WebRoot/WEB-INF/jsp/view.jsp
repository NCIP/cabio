<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
	String tabs1 = ParamUtil.getString(request, "tabs1", "Simple Search");
	
	PortletURL portletURL = renderResponse.createRenderURL();		

	//portletURL.setWindowState(WindowState.MAXIMIZED);

	portletURL.setParameter("struts_action", "/cabioportlet/view");
	portletURL.setParameter("tabs1", tabs1);
	
%>

<liferay-ui:tabs
	names="Simple Search,Canned Queries,Advanced Search"
	url="<%= portletURL.toString() %>"
/>

<c:choose>
	<c:when test='<%= tabs1.startsWith("Canned") %>'>
		<%@ include file="/WEB-INF/jsp/cannedQuery.jspf" %>
	</c:when>
	<c:when test='<%= tabs1.startsWith("Advanced") %>'>
		<%@ include file="/WEB-INF/jsp/advancedSearch.jspf" %>
	</c:when>
	<c:otherwise>
		<%@ include file="/WEB-INF/jsp/ajaxSimpleSearch.jspf" %>
	</c:otherwise>
</c:choose>
