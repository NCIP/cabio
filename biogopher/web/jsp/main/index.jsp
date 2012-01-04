<%
String userAgent = request.getHeader( "User-Agent" );
boolean isIE = userAgent.indexOf( "MSIE" ) != -1;
//boolean isIE = true;
if( isIE ){
%>
<jsp:forward page="entryPoint.jsp"/>
<% }else{ %>
This site supports <a href="http://www.microsoft.com/windows/ie">Internet Explorer</a> only.
<% } %>
