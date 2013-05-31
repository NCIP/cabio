<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

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
