<% String msg = (String)request.getAttribute( "gov.nih.nci.caBIO.ui.error.message" ); %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<script language="javascript">
 function doReturn(){
  if( opener == null ){
   window.top.location = "index.jsp";
  }else{
   window.close();
  }
 }
</script>
</head>
 <body>
  An error occured while processing your request. Click <b><a href="javascript:doReturn()">here</a></b> to return
  to the start page.<p>
  <table>
    <tr>
      <td>
       <pre>
       Message: <%= msg %>
      </pre>
     </td>
    </tr>
  </table>
  </body>
</html>
<script language="javascript">
 if( opener != null ){
   opener.top.errorOccurred();
 }
</script>
