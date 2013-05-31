<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page isErrorPage="true" %>
<%@ page import="gov.nih.nci.caBIOApp.util.*,
                 java.io.*" %>
<%!
String showError( HttpServletRequest req, Throwable ex )
    throws IOException
{
    StringBuffer err = new StringBuffer();
    err.append( "Uncaught runtime error --\n" );
    err.append( "   URI: " + req.getRequestURI() + "\n" );
    err.append( "   PathInfo: " + req.getPathInfo() + "\n" );
    err.append( "   Message: " + ex.getMessage() + "\n" );
    
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    PrintWriter pw = new PrintWriter( baos, true );
    ex.printStackTrace( pw );
    err.append( "   Stack: " + baos.toString() + "\n" );
    baos.close();
    
    return err.toString();
}
%>
<%
Throwable ex = (Throwable)request.getAttribute( "gov.nih.nci.caBIO.ui.error.exception" );
if( ex == null ){ ex = exception; }
String msg = showError( request, ex );
MessageLog.printError( msg );
String errorType = (String)request.getAttribute( "gov.nih.nci.caBIO.ui.error.exception_type" );
if( "report".equals( errorType ) ){ %>
<jsp:forward page="displayError.jsp">
 <jsp:param name="gov.nih.nci.caBIO.ui.error.message" value="<%=msg%>"/>
</jsp:forward>
<% }else{ %>
<jsp:forward page="index.jsp"/>
<% } %>
