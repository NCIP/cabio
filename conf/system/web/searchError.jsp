<HTML>
<HEAD><TITLE>FreestyleLM Error</TITLE></HEAD>
<BODY>
<font size=5><b><u>
Freestyle Lexical Mine Error:<br>
</font></b></u>

<%
if(request.getAttribute("javax.servlet.jsp.jspException") != null){
	Exception exception = (Exception)request.getAttribute("javax.servlet.jsp.jspException") ;
	String url = request.getRequestURL().toString();
	if(url.indexOf("/searchError.jsp")>-1){
		url = url.substring(0, url.indexOf("/searchError.jsp"));
	}
    %>
    <p><font color=red size=4>           
    <%=exception.getMessage()%>
    </font></p><hr><hr><br><br>
    <a href="<%=url%>/indexSearch.jsp">Back to Search Page</a>
    <%
}
%>


</BODY>
</HTML>