<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="gov.nih.nci.caBIOApp.report.*"%>
<jsp:useBean id="fetchValuesForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.FetchValuesForm"/>
<jsp:useBean id="designQueryForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.DesignQueryForm"/>
<% Table table = fetchValuesForm.getTable(); %>
<% int numCols = table.getColumnCount(); %>
<% String objName = designQueryForm.getSelectedCriterion().getObjectLabel(); %>
<% String propName = designQueryForm.getSelectedCriterion().getPropertyLabel(); %>
<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link href="styles/common.css" rel="stylesheet" type="text/css">
<script language="javascript">
  function cancel(){
    var form = document.fetchValuesForm;
    form.columnNumber.selectedIndex = -1;
    form.submit();
  }
  function selectColumn(){
    var form = document.fetchValuesForm;
    if( form.columnNumber.selectedIndex == -1 ){
      alert( "No column number has been selected" );
    }else{
      form.submit();
    }
  }
  function getNumPops(){
    return "5";
  }
</script>
</head>
<body class="boxTopLight">
<html:form action="/fetchValues" method="post">
<table width="100%">
  <tr>
    <th class="headerLargeLight" colspan="2">
      Selected Spreadsheet: <%= fetchValuesForm.getTable().getName() %>
    </th>
   </tr>
   <tr>
    <td>
<div class="textMediumDark">
The spreadsheet that you selected has <%= numCols %> columns.
Select the column containing values that should be mapped to
<em><%= objName %> - <%= propName %></em>.
</div>
    </td>
  </tr>
</table>
<table cellspacing="20">
  <tr>
    <td align="right">
      <html:select property="columnNumber" size="5">
      <% for( int i = 0; i < numCols; i++ ){ %>
    <option value="<%= Integer.toString( i ) %>">
      <%= Integer.toString( i + 1 ) + " - " + (String)table.getColumnName( i ) %>
      </option>
      <% } %>
      </html:select>
    </td>
    <td align="left" valign="top">
      <a href="javascript:selectColumn()" border="0"><img src="images/btnSelect.gif" border="0"/></a><br/>
      <a href="javascript:cancel()" border="0"><img src="images/btnCancel.gif" border="0"/></a>
      <input type="hidden" name="lastStep" value="displayColumnSelection"/>
      <input type="hidden" name="nextStep" value="finish"/>
    </td>
  </tr>
</table>
</html:form>
<script language="javascript">
window.top.activePanel = window.top.topPanel;
</script>
</body>
</html>

