<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="selectTableForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.SelectTableForm"/>
<html>
 <head>
  <link href="styles/common.css" rel="stylesheet" type="text/css">
  <script language="javascript">
  var refreshSidebar = <%= request.getParameter( "dontRefreshSidebar" ) == null %>;
  function finish( form ){
    //window.top.nextLocation = null;
    window.location = "selectTable.do?lastStep=displayAvailableTables&nextStep=finish"
  }
  </script>
 </head>
 <body class="boxTopLight"/>
  <table width="100%">
   <tr>
    <td>
     <div class="textMediumDark">
      These are your currently available spreadsheets.
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="selectListStrings">
      <% if( selectTableForm.getCachedTables().size() > 0 ){ %>
       <table>
        <logic:iterate id="table" name="selectTableForm" property="cachedTables"
                       type="gov.nih.nci.caBIOApp.report.Table">
         <tr>
	  <td>
	   <% String name = table.getName(); %>
	   <a href="subSelectTable.do?lastStep=displayAvailableTables&nextStep=finish&selectedTableName=<%=java.net.URLEncoder.encode(name)%>">
	    <%= name %>
	   </a>
	  </td>
	 </tr>
	</logic:iterate>
       </table>
      <% }else{ %>NONE<% } %>    
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <form name="selectTableForm" action="subSelectTable.do" method="post">
      <input type="button" value="Cancel" onclick="finish()"/>
      <input type="hidden" name="lastStep" value="displayAvailableTables"/>
      <input type="hidden" name="nextStep" value="upload"/>
     </form>
    </td>
   </tr>
  </table>

 </body>
</html>