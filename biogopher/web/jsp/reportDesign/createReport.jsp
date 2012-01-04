<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="createReportForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.CreateReportForm"/>
<html>
 <head>
  <html:base/>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

  <link href="styles/common.css" rel="stylesheet" type="text/css"/>

  <script language="javascript">
  function selectItem( form, whatSelected ){
   if( 'queryDesign' == whatSelected ){

     if( form.newReportLabel.value == null ||
         form.newReportLabel.value == "" ){
       alert( "Please enter a name for the new report." );
     }else if( form.selectedQueryDesignId.selectedIndex == -1 ){
       alert( "Please select an query for which to create the new report." );
     }else{
       form.selectedReportDesignId.selectedIndex = -1;
       form.label.value = form.newReportLabel.value;
       form.nextStep.value = "create";
       form.submit();
     }
   }else if( 'reportDesign' == whatSelected &&
             form.selectedReportDesignId.selectedIndex != -1 ){
    form.selectedQueryDesignId.selectedIndex = -1;
    form.nextStep.value = "select";
    form.submit();
   }else{
    //do nothing
   }
  }
  function renameReport( form ){
   form.label.value = prompt( "Please enter the new name for your report.", "NAME" );
   if( form.label.value != null &&
       form.label.value != "" &&
       form.label.value != "NAME" &&
       form.label.value != "null" ){
    form.nextStep.value = "rename";
    form.submit();
   }
  }
  function removeReport( form ){
   if( confirm( "This report will be permanently deleted. Continue?" ) ){
    form.nextStep.value = "remove";
    form.submit();
   }
  }
  function getNumPops(){
   return "0";
  }
  function finish(){
   var form = document.createReportForm;
   form.nextStep.value = "cancel";
   form.submit();
  }
  </script>
 </head>
 <body class="boxCompleteLight">
  <div class="textLargeDark">
   <html:errors/>
  </div>
  <html:form action="/createReport" method="post">
  <table>
   <tr>
    <td>
     <div class="headerMediumDark">
      Create A New Report
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="textMediumDark">
      
       <img src="images/aTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Select the query for which you will build a report.
	<table>
	 <tr>
	  <td>
	   <div class="selectListStrings">
	    <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	    <select name="selectedQueryDesignId">
	     <logic:iterate id="value" name="createReportForm" property="QDVLs"
                            type="gov.nih.nci.caBIOApp.ui.ValueLabelPair">
	      <option value="<%=value.getValue()%>"
		<%=(value.getValue().equals(createReportForm.getSelectedQueryDesignId()) ? " selected" : "")%>>
		<%= value.getLabel() %>
	      </option>
	     </logic:iterate>
	    </select>
	   </div>
	  </td>
	 </tr>
	</table>
       
       <img src="images/bTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Enter a name for this report.
        <table>
         <tr>
          <td>
           <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	   <input type="text" name="newReportLabel" onKeyPress="window.top.cancelEnterKey(window.event)"/>
	  </td>
         </tr>
	</table>
       
       <img src="images/cTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Create the report.
	<table>
	 <tr>
	  <td>
           <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	   <input type="button" value="Create"
                  onclick="selectItem( this.form, 'queryDesign' )"/>
	  </td>
	 </tr>
	</table>
       
      
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="textLargeDark">
      - OR -
      <p> 
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="headerMediumDark">
      Work With An Existing Report
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="textMediumDark">
      
       <img src="images/aTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Select the report with which you would like to work.
	<table>
	 <tr>
	  <td>
	   <div class="selectListStrings">
	    <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	    <select name="selectedReportDesignId">
	     <logic:iterate id="value" name="createReportForm" property="RDVLs"
                            type="gov.nih.nci.caBIOApp.ui.ValueLabelPair">
	      <option value="<%=value.getValue()%>"
		<%=(value.getValue().equals(createReportForm.getSelectedReportDesignId()) ? " selected" : "")%>>
		<%= value.getLabel() %>
	      </option>
	     </logic:iterate>
	    </select>
	   </div>
	  </td>
	 </tr>
	</table>
       
       <img src="images/bTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Work with the report.
	<table>
	 <tr>
	  <td>
           <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	   <input type="button" value="Edit"
                  onclick="selectItem( this.form, 'reportDesign' )"/>
	   <input type="button" value="Rename"
                  onclick="renameReport( this.form )"/>
	   <input type="button" value="Remove"
                  onclick="removeReport( this.form )"/>
	  </td>
	 </tr>
	</table>
       
      
     </div>
    </td>
   </tr>
  </table>

  <input type="hidden" name="lastStep" value="displaySelection"/>
  <input type="hidden" name="nextStep" value=""/>
  <input type="hidden" name="label" value=""/>

  </html:form>

  <!-- Initializes the other panels -->
  <script language="javascript">
   window.top.tabsPanel.refresh( "createReport" );
   window.top.activePanel = window.top.sidebarPanel;
   window.top.topPanel.location = "createReportInstructions.html";
   window.top.middlePanel.location = "emptyMiddlePanel.html";
  </script>
 </body>
</html>

