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
  function cancel(){
    window.location = "subSelectTable.do?lastStep=displayAvailableTables&nextStep=finish";
  }
  function getNumPops(){
    return "6";
  }
  </script>
 </head>
<body class="boxTopLight"/>
<table width="50%%">
  <tr>
    <td colspan="2">
      <div class="textMediumDark">
      Please select one of the available spreadsheets below to use in your query.
      </div>
    </td>
  </tr>
  <tr>
    <td>
      <div class="fileList">
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
    <td valign="top">
      <a href="javascript:cancel()" border="0">
       <img src="images/btnCancel.gif" border="0"/>
      </a>
    </td>
  </tr>
</table>
<form name="selectTableForm" action="subSelectTable.do" method="post">
<%-- <input type="button" value="Cancel" onclick="cancel()"/> --%>

<input type="hidden" name="lastStep" value="displayAvailableTables"/>
<input type="hidden" name="nextStep" value="upload"/>
</form>
<script language="javascript">
window.top.activePanel = window.top.topPanel;
</script>
</body>
</html>

