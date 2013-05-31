<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="gov.nih.nci.caBIOApp.ui.*,
	         gov.nih.nci.caBIOApp.util.*" %>
<jsp:useBean id="designReportForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.DesignReportForm"/>
<bean:define id="colSpecs" name="designReportForm" property="reportDesign.columnSpecifications"/>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

  <title><bean:message key="designReportForm.editPanel.editScreen.title"/></title>
  <script language="javascript">
   function selectColumn( id ){
    var form = document.designReportForm;
    form.nextStep.value = "selectColumn";
    form.selectedColumnId.value = id;
    form.submit();
   }
   function finish(){
    var form = document.designReportForm;
    form.nextStep.value ="finish";
    form.submit();
   }
   function updateColumn( operation ){
    var form = document.designReportForm;
    if( form.columnId.selectedIndex != -1 ){
     form.nextStep.value = "updateReport";
     form.updateOperationName.value = operation;
     form.submit();
    }
   }
   function renameColumn(){
    var form = document.designReportForm;
    form.newColumnName.value = prompt( "Please enter the new column name.", "NAME" );
    if( form.newColumnName.value != null &&
        form.newColumnName.value != "" &&
	form.newColumnName.value != "NAME" ){
     updateColumn( "rename" );
    }
   }
  </script>
 </head>
 <body>
  <% if( designReportForm.isSummaryToBeRefreshed() ){ %>
   <script language="javascript">
    window.top.middlePanel.refresh();
   </script>
  <% } %>
  <h3><bean:message key="designReportForm.editPanel.editScreen.title"/></h3>
  <html:form action="/designReport" method="post">
   <table>
    <tr>
     <td valign="top">
      <html:select property="columnId" size="5">
       <html:options collection="colSpecs" property="id" labelProperty="newColumnTitle"/>
      </html:select>
     </td>
     <td valign="top">
      <table cellpadding="0" cellspacing="0" border="0">
       <tr>
        <td>
         <a href="javascript:updateColumn( 'moveLeft' )"/>
          <bean:message key="designReportForm.editPanel.button.moveLeft"/>
         </a>
	</td>
       </tr>
       <tr>
        <td>
         <a href="javascript:updateColumn( 'moveRight' )"/>
          <bean:message key="designReportForm.editPanel.button.moveRight"/>
         </a>
	</td>
       </tr>
       <tr>
        <td>
         <a href="javascript:renameColumn()"/>
          <bean:message key="designReportForm.editPanel.button.rename"/>
         </a>
	</td>
       </tr>
       <tr>
        <td>
         <a href="javascript:updateColumn( 'remove' )"/>
          <bean:message key="designReportForm.editPanel.button.remove"/>
         </a>
	</td>
       </tr>
       <tr>
	<td>
	 <div name="generateReportControl" id="generateReportControl" style="visibility:hidden">
	  <img src="<%=request.getContextPath()%>/generateReport.jpg"
	       onclick="window.top.tabsPanel.perform( 'generateReport' )"
	       border="0" width="80" height="30"/>
	 </div>
	</td>
       </tr>
      </table>
     </td>
    </tr>
   </table>
   <input type="hidden" name="lastStep" value="displayEditScreen"/>
   <input type="hidden" name="nextStep" value=""/>
   <input type="hidden" name="updateOperationName" value=""/>
   <input type="hidden" name="selectedColumnId" value=""/>
   <input type="hidden" name="newColumnName" value=""/>
  </html:form>

 <script language="javascript">
  if( document.designReportForm.columnId.length > 0 ){
   window.top.topPanel.generateReportControl.style.visibility = "visible";
  }else{
   window.top.topPanel.generateReportControl.style.visibility = "hidden";
  }
 </script>

 </body>
</html>

