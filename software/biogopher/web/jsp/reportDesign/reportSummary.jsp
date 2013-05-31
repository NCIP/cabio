<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="gov.nih.nci.caBIOApp.ui.*,
                 java.util.*" %>
<jsp:useBean id="designReportForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.DesignReportForm"/>

<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

  <script language="javascript">

   function selectColumn( id ){
    var form = document.designReportForm;
    form.nextStep.value = "selectColumn";
    form.selectedColumnId.value = id;
    form.submit();
   }
   function getNumPops(){
    return "0";
   }
   function finish(){
    var form = document.designReportForm;
    form.nextStep.value ="finish";
    form.submit();
   }
   function updateColumn( operation, id ){
    var continueOp = true;
    if( 'remove' == operation ){
     continueOp = confirm( 'This column will be removed from the final report. Proceed?' );
    }
    if( continueOp ){
     var form = document.designReportForm;
     form.columnId.value = form.selectedColumnId.value = id;
     form.nextStep.value = "updateReport";
     form.updateOperationName.value = operation;
     form.submit();
    }

   }
   function renameColumn( id ){
    var form = document.designReportForm;
    form.newColumnName.value = prompt( "Please enter the new column name.", "NAME" );
    if( form.newColumnName.value != null &&
        form.newColumnName.value != "" &&
	form.newColumnName.value != "NAME" &&
        form.newColumnName.value != "null" ){
     updateColumn( "rename", id );
    }
   }
   function generateReport(){
     window.open( 'working.jsp?nextActionName=preparePageReport.jsp&reportDesignKey=caBIOApp.ui.selectedReportDesign', 'report' + (new Date()).getMilliseconds(), 'menubar,resizable,dependent,scrollbars,width=700,height=500,screenX=100,screenY=100' );
   }
  </script>
  
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>

 </head>
 <% List colSpecs = designReportForm.getReportDesign().getColumnSpecifications(); %>
  <body class="boxBottomDarker">
 <% if( colSpecs.size() > 0 ){ %>
   <script language="javascript">
    window.top.topPanel.location = "reportSummary_upper.jsp";
   </script>
 <% }else{ %>
   <script language="javascript">
    window.top.topPanel.location = "designReportInstructions.html";
   </script>
 <% } %>

 <% if( colSpecs.size() > 0 ){ %>

  <table width="<%=colSpecs.size() * 500%>">
   <tr>
    <td width="<%=colSpecs.size() * 500%>">
  <table nowrap cellspacing="0">
   <tr>  

   <% for( Iterator i = colSpecs.iterator(); i.hasNext(); ){ %>
    <th>
     <% ColumnSpecification colSpec = (ColumnSpecification)i.next(); %>
     <% if( colSpec.isActive() ){ %>
      <a name="activeColumn">
     <% } %>
     <%= colSpec.getNewColumnTitle() %>
     <% if( colSpecs.size() > 1 ){ %>&nbsp;<a href="javascript:renameColumn( '<%= colSpec.getId() %>' )" border="0"><img src="images/rename.gif" border="0"/></a><a href="javascript:updateColumn( 'moveLeft', '<%= colSpec.getId() %>' )" border="0"><img src="images/moveLeft.gif" border="0"/></a><a href="javascript:updateColumn( 'moveRight', '<%= colSpec.getId() %>' )" border="0"><img src="images/moveRight.gif" border="0"/></a><% } %><a href="javascript:updateColumn( 'remove', '<%= colSpec.getId() %>' )" border="0"><img src="images/remove.gif" border="0"/></a>
     <% if( colSpec.isActive() ){ %>
      </a>
     <% } %>
    </th>
   <% }	%>
   </tr>
   <% for( int i = 0; i < 5; i++ ){ %>
    <tr>
     <% for( int j = 0; j < colSpecs.size(); j++ ){ %>
      <td class="sampleText">XXXXXXXXX</td>
     <% } %>
    </tr>
   <% } %>
  </table>
    </td>
   </tr>
  </table>
 <% } %>

  <html:form action="/designReport" method="post">
   <input type="hidden" name="lastStep" value="displayEditScreen"/>
   <input type="hidden" name="nextStep" value=""/>
   <input type="hidden" name="updateOperationName" value=""/>
   <input type="hidden" name="selectedColumnId" value=""/>
   <input type="hidden" name="columnId" value=""/>
   <input type="hidden" name="newColumnName" value=""/>
  </html:form>

  <script language="javascript">
   window.top.tabsPanel.refresh( 'createReport' );
   window.top.activePanel = window.top.middlePanel;
   var activeColumn = document.all.activeColumn;
   if( activeColumn != null ){
     activeColumn.scrollIntoView( false );
   }
  </script>
 </body>

</html>

