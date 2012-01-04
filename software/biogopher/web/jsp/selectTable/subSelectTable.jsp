<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="selectTableForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.SelectTableForm"/>
<html>
 <head>
  <script language="javascript">
  function finish( form ){
    //window.top.nextLocation = null;
    window.location = "subSelectTable.do?lastStep=displayAvailableTables&nextStep=finish"
  }
  function upload( form ){
   if( form.uploadedFile.value.length > 0 ){
    form.nextStep.value = "upload";
    form.submit();
   }
  }
  </script>
 </head>
 <body>


<html:errors/>

 <template:insert template="/labeledBox.jsp">
  <template:put name="width" content="0" direct="true"/>
  <template:put name="border" content="1" direct="true"/>
  <template:put name="label" content="Available Spreadsheets" direct="true"/>
  <template:put name="content" direct="true">
   <% if( selectTableForm.getCachedTables().size() > 0 ){ %>
   <table>
    <logic:iterate id="table" name="selectTableForm" property="cachedTables"
                   type="gov.nih.nci.caBIOApp.report.Table">
     <tr>
      <td>
      <% String name = table.getName(); %>
      <% if( selectTableForm.getAllowSelection() ){ %>
       <a href="subSelectTable.do?lastStep=displayAvailableTables&nextStep=finish&selectedTableName=<%=java.net.URLEncoder.encode(name)%>">
      <% } %>
       <%= name %>
      <% if( selectTableForm.getAllowSelection() ){ %>
       </a>
      <% } %>
      </td>
     </tr>
    </logic:iterate>
   </table>
   <% }else{ %>NONE<% } %>
  </template:put>
 </template:insert>
 <p>



<% if( selectTableForm.getAllowUpload() ){ %>
<form name="selectTableForm" action="subSelectTable.do" method="post" enctype="multipart/form-data">
 <template:insert template="/labeledBox.jsp">
  <template:put name="width" content="0" direct="true"/>
  <template:put name="border" content="1" direct="true"/>
  <template:put name="label" content="Select New Spreadsheet" direct="true"/>
  <template:put name="content" direct="true">
   <html:file name="selectTableForm" property="uploadedFile"/>&nbsp;
   Worksheet #:<input type="text" name="worksheetNumber" size="3" value="1"/>
  </template:put>
 </template:insert>
 <input type="button" value="Select" onclick="upload( this.form )"/>&nbsp;
<% }else{ %>
<form name="selectTableForm" action="subSelectTable.do" method="post">
<% } %>

 <input type="button" value="Cancel" onclick="finish()"/>
 <input type="hidden" name="lastStep" value="displayAvailableTables"/>
 <input type="hidden" name="nextStep" value="upload"/>
</form>

<script language="javascript">
  window.top.tabsPanel.refresh( "supplyDatasource" );
  window.top.setActivePanel( window.top.topPanel );
</script>

 </body>
</html>
