<%@ page import="java.util.*" %>
<% String actionPath = request.getParameter( "nextActionName" ); %>
<%
   StringBuffer sb = new StringBuffer();
   for( Enumeration paramNames = request.getParameterNames(); paramNames.hasMoreElements(); ){
      String paramName = (String)paramNames.nextElement();
      String[] paramValues = request.getParameterValues( paramName );
      if( paramValues != null ){
         for( int j = 0; j < paramValues.length; j++ ){
	   sb.append( paramName + "=" + paramValues[j] );
	   if( j < paramValues.length - 1 ){
	      sb.append( "&" );
	   }
	 }
      }
      if( paramNames.hasMoreElements() && sb.length() > 0 ){
         sb.append( "&" );
      }
   }
   String newURL = request.getContextPath()+ "/" + actionPath + "?" + sb.toString();
%>
<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
</head>
 <body>
<script language="javascript">
 //document.write( "Working..." );
 var mainWindow = window.top;
 if( window.opener != null ){
  mainWindow = opener.top;
 }
 mainWindow.watchWindow =
   window.open( 'watchWindow.html', 'watchWindow', 'width=200,height=200,screenX=100,screenY=100' );
 location = '<%= newURL %>';
</script>
 </body>
</html>

