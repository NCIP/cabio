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
   String newURL = request.getContextPath() + actionPath + ".do?" + sb.toString();
%>
<script language="javascript">
 //alert( '<%= newURL %>' );
 window.top.location = '<%= newURL %>';
</script>
