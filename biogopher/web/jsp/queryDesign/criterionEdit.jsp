<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page import="gov.nih.nci.caBIOApp.ui.*,
                 gov.nih.nci.caBIOApp.util.*" %>
<jsp:useBean id="designQueryForm" 
             scope="session"
             class="gov.nih.nci.caBIOApp.ui.form.DesignQueryForm"/>
<% boolean allowModify = false; %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <title><bean:message key="designQueryForm.editPanel.editScreen.title"/></title>

  <script language="javascript" src="calendar.js"></script>
  <script language="javascript" src="OntologyTree.js"></script>
  <script language="javascript">
  
  function getNumPops(){
    return "2";
  }

  function doCalendar( dateField ){
    setDateField (dateField);
    window.top.newWin = window.open ('calendar.html', 'cal',
				   'dependent=yes,width=210,height=230,screenX=200,screenY=300,titlebar=yes');
  }
  function selectCriterion(){
    alert( '<bean:message key="designQueryForm.editPanel.editScreen.message.selectCriterion"/>' );
  }
   function editCriterion(){
     alert( '<bean:message key="designQueryForm.editPanel.editScreen.message.editCriterion"/>' );
   }

   function toggleMerge(){
    alert( '<bean:message key="designQueryForm.editPanel.editScreen.message.toggleMerge"/>' );
   }
   function cancelEdit(){
     var form = document.designQueryForm;
     form.nextStep.value = "cancelEdit";
     form.submit();
   }
   function updateCriteria(){
     var form = document.designQueryForm;
     form.nextStep.value = "updateCriteria";
     form.submit();
   }
   function deleteCriterion(){
    var doDelete = confirm( '<bean:message key="designQueryForm.editPanel.editScreen.message.deleteCriterion"/>' );
    if( doDelete ){
     var form = document.designQueryForm;
     form.nextStep.value = "deleteCriterion";
     form.submit();
    }
   }
   function addValue(){
     var form = document.designQueryForm;
     var newVal = prompt( "Enter value to add.", "VALUE" );
     if( newVal != "null" && newVal.length > 0 ){
      form.labelToAdd.value = newVal;
      if( form.valueToAdd.value.length == 0 ){
        form.valueToAdd.value = form.labelToAdd.value;
      }      
      form.selectedValues.value = null;
      updateCriterion( "add" );
     }
   }

   function removeValue( form, value ){
     form.selectedValue.value = value;
     updateCriterion( "delete" );
   }

   function updateCriterion( opName ){
     var form = document.designQueryForm;
     form.updateOperation.value = opName;
     //if( confirm( form.updateOperation.value ) ){
     form.nextStep.value = "updateCriterion";
     form.submit();
     //}
   }
   function fetchValues( form ){
     var form = document.designQueryForm;
     form.nextStep.value = "fetchValues";
     form.submit();
   }
   function addOntologicalValue( id, name ){
     ontologyBrowserWindow.close();
     var form = document.designQueryForm;
     form.tempLabel.value = name;
     form.valueToAdd.value = id;
     form.labelToAdd.value = name;
     updateCriterion( "add" );
   }
   function addDateValue( date ){
     var form = document.designQueryform;
     form.labelToAdd.value = form.valueToAdd.value;
     updateCriterion( "add" );
   }
   function browseData(){
     window.open( 'browseObjectInstances.jsp?propertyName=<%=designQueryForm.getSelectedCriterion().getObjectName() + "." + designQueryForm.getSelectedCriterion().getPropertyName()%>', 'page', 'status,resizable,dependent,scrollbars,width=700,height=500,screenX=100,screenY=100' );
   }

   function explainButton( buttonName ){
    window.open( 'explainButton.jsp?buttonName=' + buttonName,
                 'explainButton', 'width=300,height=100' );
   }
</script>

<link href="styles/common.css" rel="stylesheet" type="text/css"/>
</head>
<body class="boxTopLight">

<html:form action="/designQuery" method="post">

<table>
  <tr>
    <td width="50%" valign="top" align="center">
      <% int criterionType = designQueryForm.getSelectedCriterion().getType(); %>
      <% switch( criterionType ){
      case CriterionValue.STRING_TYPE: %><%@ include file="/editCriterion_STRING.jsp" %><% break;
      case CriterionValue.DATE_TYPE: %><%@ include file="/editCriterion_DATE.jsp" %><% break;
      case CriterionValue.NUMERIC_TYPE: %><%@ include file="/editCriterion_STRING.jsp" %><% break;
      case CriterionValue.FLOAT_TYPE: %><%@ include file="/editCriterion_STRING.jsp" %><% break;
      case CriterionValue.BOOLEAN_TYPE: %><%@ include file="/editCriterion_BOOLEAN.jsp" %><% break;
      case CriterionValue.ONTOLOGICAL_TYPE: %><%@ include file="/editCriterion_ONTOLOGICAL.jsp" %><% break;
      case CriterionValue.OBJECT_TYPE: %><%@ include file="/editCriterion_OBJECT.jsp" %><% break;
      default: 
      throw new JspException( "unknown criterion type" );
      }//-- end switch(... 
      %>
      <p>
      <div class="textMediumDark">
      <html:errors/>
      </div>

    </td>
    <td width="50%" valign="top" align="center">
      <table width="100%">
	<tr>
	  <th class="headerLargeLight" colspan="2">
	    Operations
	  </th>
	</tr>
	<% if( designQueryForm.showAddButton() ){ %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <% if( CriterionValue.ONTOLOGICAL_TYPE == criterionType ){ %>
	    <a href="javascript:openOntologyBrowser( 'webtree/WebTreeMain.jsp', '<%=designQueryForm.getBeanName()%>' )">
	    <% }else{ %>
	    <a href="javascript:addValue()">
	    <% } %>
	     <img src="images/btnAdd.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	   <a href="javascript:explainButton( 'addValues' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Adds a value to your set of working values.
	    </div>
	  </td>
	  --%>
	</tr>
	<% } %>
	<% if( designQueryForm.showRemoveButton() ){ %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:updateCriterion( 'delete' )">
	    <img src="images/btnRemove.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
  	   <a href="javascript:explainButton( 'removeValues' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Removes the selected value from your set of working values.
	    </div>
	    --%>
	  </td>
	</tr>	
	<% } %>
	<% if( designQueryForm.showFetchButton() ){ %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:fetchValues()">
	    <img src="images/btnAcquire.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	  <a href="javascript:explainButton( 'acquireValues' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Allows you to fetch values from one of the datasources that you supplied.
	    </div>
	    --%>
	  </td>
	</tr>
	<% } %>

	<% if( designQueryForm.showBrowseButton() ){ %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:browseData()">
	    <img src="images/btnBrowse.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	  <a href="javascript:explainButton( 'browse' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Allows you to browse caBIO data and select values to add to your set of working values.
	    </div>
	    --%>
	  </td>
	</tr>
	<% } %>
	<% if( designQueryForm.showDeleteButton() ){ %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:deleteCriterion()">
	    <img src="images/btnDelete.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	  <a href="javascript:explainButton( 'deleteCriterion' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Deletes the currently selected values from your query.
	    </div>
	    --%>
	  </td>
	</tr>
	<% } %>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:updateCriteria()">
	    <img src="images/btnUpdate.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	  <a href="javascript:explainButton( 'updateCriteria' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Moves your working values into the query that you are building below.
	    </div>
	    --%>
	  </td>
	</tr>
	<tr>
	  <td valign="top" align="right" width="55%">
	    <a href="javascript:cancelEdit()">
	    <img src="images/btnCancel.gif" border="0"/>
	    </a>
	  </td>
	  <td align="left">
	  <a href="javascript:explainButton( 'cancel' )" border="0"/>?</a>
	  <%--
	    <div class="textMediumDark">
	    Cancels editing of working values without moving them into your query.
	    </div>
	    --%>
	  </td>
	</tr>	
      </table>
    </td>
  </tr>
</table>

<p>

<input type="hidden" name="nextStep" value=""/>
<input type="hidden" name="lastStep" value="displayEditScreen"/>
<input type="hidden" name="updateOperation" value=""/>
<input type="hidden" name="labelToAdd" value=""/>
<input type="hidden" name="valueToAdd" value=""/>
<input type="hidden" name="selectedValue" value=""/>

</html:form>
<script language="javascript">
window.top.activePanel = window.top.topPanel;
</script>
</body>
</html>

