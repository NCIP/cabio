<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<c:choose>
	<c:when test='${tab == "Simple Search"}'>
        <%@ include file="/WEB-INF/jsp/ajaxSimpleSearch.jspf" %>
	</c:when>
    <%--
    <c:when test='%{tab == "Advanced Search"}'>
        <%@ include file="/WEB-INF/jsp/advancedSearch.jspf" %>
    </c:when>
    --%>
    <c:when test='${tab == "About"}'>
        <%@ include file="/WEB-INF/jsp/about.jspf" %>
    </c:when>
	<c:otherwise>
        <%@ include file="/WEB-INF/jsp/cannedQuery.jspf" %>
	</c:otherwise>
</c:choose>
