<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

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
  function getNumPops(){
    return "0";
  }
  function finish(){
    /*
    var form = document.selectTableForm;
    if( form.uploadedFile.value.length == 0 ){
     form = document.hiddenForm;
    }
    */
    var form = document.hiddenForm;
    form.nextStep.value = "finish";
    form.submit();
  }
  function upload( form ){
   if( form.uploadedFile.value.length > 0 ){
    form.nextStep.value = "upload";
    form.submit();
   }
  }
  </script>
 </head>
 <body class="boxCompleteLight">

<form name="selectTableForm" action="selectTable.do" method="post" enctype="multipart/form-data">

<table>
  <tr>
    <td align="left" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="5">
	<!-- ERROR SECTION -->
	<tr>
	  <td colspan="2">
	    <div class="textMediumDark">
	    <html:errors/>
	    </div>
	  </td>
	</tr>
	
	<!-- FILE UPLOAD SECTION -->
	<tr>
	  <td valign="top">
	    <img src="images/aTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
	  </td>
	  <td align="left" valign="top">
	    <div class="headerMediumDark">
	    Select local spreadsheet data source:
	    </div>
	    <div class="textMediumDark">
	    <html:file name="selectTableForm" property="uploadedFile"/>
	    </div>
	  </td>
	</tr>

	<!-- SPECIFY WORKSHEET SECTION -->
	<tr>
	  <td valign="top">
	    <img src="images/bTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
	  </td>
	  <td align="left" valign="top">
	    <div class="headerMediumDark">
	    Specify worksheet number (optional):
	    </div>
	    <div class="textMediumDark">
	    Default is to use the first worksheet within the spreadsheet file.
	    <br>
	    <input type="text" name="worksheetNumber" size="3" value="1"/>
	    </div>
	  </td>
	</tr>

	<!-- SPECIFY HEADER ROW -->
	<tr>
	  <td valign="top">
	    <img src="images/cTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
	  </td>
	  <td align="left" valign="top">
	    <div class="headerMediumDark">
	    Specify header row number (optional):
	    </div>
	    <div class="textMediumDark">
	    Leave this blank unless you have headers within your spreadsheet.<br>
	    <input type="text" name="headerRowNumber" size="3"/>
	    </div>
	  </td>
	</tr>
	
	<!-- SPECIFY DATA START ROW -->
	<tr>
	  <td valign="top">
	    <img src="images/dTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
	  </td>
	  <td align="left" valign="top">
	    <div class="headerMediumDark">
	    Specify in which row your data starts (optional):
	    </div>
	    <div class="textMediumDark">
	    Default is to start with the first row.<br>
	    <input type="text" name="dataStartRowNumber" size="3" value="1"/>
	    </div>
	  </td>
	</tr>

	<!-- DO UPLOAD SECTION -->
	<tr>
	  <td valign="top">
	    <img src="images/eTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
	  </td>
	  <td align="left" valign="top">
	    <div class="headerMediumDark">
	    Click here to add this data source
	    </div>
	    <div>
	    <input type="button" value="Select" onclick="upload( this.form )"/>
	    </div>
	  </td>
	</tr>

      </table>
    </td>
  </tr>
</table>

 <input type="hidden" name="lastStep" value="displayAvailableTables"/>
 <input type="hidden" name="nextStep" value="upload"/>
</form>

<form name="hiddenForm" action="selectTable.do" method="post">
 <input type="hidden" name="lastStep" value="displayAvailableTables"/>
 <input type="hidden" name="nextStep" value="upload"/>
</form>

<script language="javascript">
  window.top.tabsPanel.refresh( "supplyDatasource" );
  window.top.activePanel = window.top.sidebarPanel;
  window.top.topPanel.location = "selectTableRight.jsp";
  window.top.middlePanel.location = "emptyMiddlePanel.html";
</script>
</html>

