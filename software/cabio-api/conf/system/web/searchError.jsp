<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<HTML>
<HEAD><TITLE>FreestyleLM Error</TITLE></HEAD>
<BODY>
<font size=5><b><u>
Freestyle Lexical Mine Error:<br>
</u></b></font>

<%
if(request.getAttribute("javax.servlet.jsp.jspException") != null){
	Exception exception = (Exception)request.getAttribute("javax.servlet.jsp.jspException") ;
	String message=exception.getMessage();
	pageContext.setAttribute("message", message);
	String url = request.getRequestURL().toString();
	if(url.indexOf("/searchError.jsp")>-1){
		url = url.substring(0, url.indexOf("/searchError.jsp"));
	}
    %>
    <p><font color=red size=4> 
    <c:out value="${message}"/>
    </font></p><hr><hr><br><br>
    <a href="<%=url%>/indexSearch.jsp">Back to Search Page</a>
    <%
}
%>


</BODY>
</HTML>