<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
	pageContext.setAttribute("tab", 
		ParamUtil.getString(request, "tabs1", "Reports"));
%>

<c:choose>
	<c:when test='${tab == "Reports"}'>
		<%@ include file="/WEB-INF/jsp/cannedQuery.jspf" %>
	</c:when>
	<c:when test='%{tab == "Advanced Search"}'>
		<%@ include file="/WEB-INF/jsp/advancedSearch.jspf" %>
	</c:when>
	<c:otherwise>
		<%@ include file="/WEB-INF/jsp/ajaxSimpleSearch.jspf" %>
	</c:otherwise>
</c:choose>
