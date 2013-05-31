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
  
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>

  <script language="javascript">
   function doOp( opname ){

    if( "generate" == opname && 
        document.columnsForm.selectedColumnId.length > 0 ){
      top.activePanel.generateReport();
    }else{
     var id = getId();
     if( id != null ){
      if( "moveUp" == opname ){
       top.activePanel.updateColumn( 'moveLeft', id );
      }else if( "moveDown" == opname ){
       top.activePanel.updateColumn( 'moveRight', id );
      }else if( "rename" == opname ){
       top.activePanel.renameColumn( id );
      }else if( "remove" == opname ){
       top.activePanel.updateColumn( 'remove', id );
      }
     }
    }
   }
   function getId(){
    var idx = document.columnsForm.selectedColumnId.selectedIndex;
    var id = document.columnsForm.selectedColumnId.value;
    if( idx == -1 || "NONE" == id ){
     id = null;
    }
    return id;
   }
  </script>

 </head>
 <% List colSpecs = designReportForm.getReportDesign().getColumnSpecifications(); %>
 
 <body class="boxTopLight">
  <table width="100%">
   <tr><!-- HEADER ROW -->
    <th class="headerLargeLight">
     Design Report - <%= designReportForm.getReportDesign().getLabel() %>
    </th>
   </tr>
   <tr><!-- CONTROL ROW -->
    <td>
    <!--
    Click on items in the tree on the left to add columns. Then, used the
    controls to the right of the list or the controls on the report format
    preview below to arrange the columns.</br>
    -->
  <form name="columnsForm">
   <table width="100%">
    <tr>
     <td align="right"> <!-- COLUMNS COLUMN -->
      <select name="selectedColumnId" size="5">
       <% if( colSpecs.size() > 0 ){ %>
        <% for( Iterator i = colSpecs.iterator(); i.hasNext(); ){ %>
         <% ColumnSpecification colSpec = (ColumnSpecification)i.next(); %>
          <option value="<%=colSpec.getId()%>"
           <%= colSpec.isActive() ? "selected" : "" %>
          >
           <%= colSpec.getNewColumnTitle() %>
          </option>
        <% }//--end iteration through colSpecs %>
       <% }else{ %>
        <option value="NONE">NONE</option>
       <% } %>

      </select>
     </td>
     <td align="left"><!-- CONTROLS COLUMN -->
      <table>
       <tr><td><a href="javascript:doOp( 'moveUp' )" border="0">
	       <img src="images/btnMoveup.gif" border="0"/></a></td></tr>
       <tr><td><a href="javascript:doOp( 'moveDown' )" border="0">
               <img src="images/btnMovedown.gif" border="0"/></a></td></tr>
       <tr><td><a href="javascript:doOp( 'rename' )" border="0">
               <img src="images/btnRename.gif" border="0"/></a></td></tr>
       <tr><td><a href="javascript:doOp( 'remove' )" border="0">
               <img src="images/btnRemove.gif" border="0"/></a></td></tr>
       <tr><td><a href="javascript:doOp( 'generate' )" border="0">
	        <img src="images/generateReport.gif" border="0"/>
	       </a></td></tr>
     </td>
    </tr>
   </table>
  </form>
    </td>
   </tr>
  </table>
 </body>

</html>

