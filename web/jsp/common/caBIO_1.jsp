<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<html>
 <head>
  <html:base/>
  <script language="javascript">
   <template:get name="javascript"/>
  </script>
  <style type="text/css">
   <%@ include file="/caBIO_base_style.css" %>
   <template:get name="cssStyle"/>
  </style>
  <title><template:get name="title"/></title>
 </head>
 <body>

  <table>
   <tr>
    <!-- HEADER -->
    <td colspan="2">
     <%@ include file="/caBIO_base_header.html" %>
    </td>
   </tr>
   <tr>
    <td width="25%" bgcolor="CCCCEE">
     <!-- SIDEBAR -->
     <template:get name="sidebar"/>
    </td>
    <td align="left">
     <table>
      <tr>
       <!-- TOP -->
       <td>
        <template:get name="top"/>
       </td>
      </tr>
      <tr>
       <!-- MIDDLE -->
       <td><template:get name="middle"/></td>
      </tr>
      <tr>
       <!-- BOTTOM -->
       <td><template:get name="bottom"/></td>
      </tr>
     </table>
    </td>
   </tr>
   <tr>
    <td colspan="2">
     <!-- FOOTER -->
    </td>
   </tr>
  </table>

 </body>
</html>
