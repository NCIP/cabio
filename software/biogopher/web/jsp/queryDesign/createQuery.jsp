<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="createQueryForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.CreateQueryForm"/>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <html:base/>
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>

  <script language="javascript">
  function createQuery( form ){
   if( form.newQueryLabel.value == null ||
       form.newQueryLabel.value == "" ){
     alert( "Please enter a name for the new query." );
   }else if( form.selectedObjectName.selectedIndex == -1 ){
     alert( "Please select an object for which to create the new query." );
   }else{
     form.selectedQueryDesignId.selectedIndex = -1;
     form.label.value = form.newQueryLabel.value;
     form.nextStep.value = "create";
     form.submit();
   }
  }
  function selectQuery( form ){
   if( form.selectedQueryDesignId.selectedIndex != -1 ){
     form.selectedObjectName.selectedIndex = -1;
     form.nextStep.value = "select";
     form.submit();
   }
  }
  function renameQuery( form ){
   if( form.selectedQueryDesignId.selectedIndex != -1 ){
    form.label.value = prompt( "Please enter the new name for your query.", "NAME" );
    if( form.label.value != null &&
       form.label.value != "" &&
       form.label.value != "NAME" &&
       form.label.value != "null" ){
     form.nextStep.value = "rename";
     form.submit();
    }
   }
  }
  function removeQuery( form ){
   if( form.selectedQueryDesignId.selectedIndex != -1 ){
    if( confirm( "This query will be permanently deleted. Continue?" ) ){
     form.nextStep.value = "remove";
     form.submit();
    }
   }
  }
  function finish(){
   var form = document.createQueryForm;
   form.nextStep.value = "cancel";
   form.submit();
  }
  function getNumPops(){
   return "0";
  }
  </script>
 </head>
 <body class="boxCompleteLight">
  <div class="textLargeDark">
   <html:errors/>
  </div>
  <html:form action="/createQuery" method="post">
  <table>
   <tr>
    <td>
     <div class="headerMediumDark">
      Create A New Query
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="textMediumDark">
      
       <img src="images/aTan.gif" width="30" height="30" hspace="0" 
	    vspace="0" border="0" align="absmiddle"/>
        Select the
	<a target="_blank" href="caBIO_objects_desc.html">
	object
	</a>
	 for which you will build a query.
	<table>
	 <tr>
	  <td>
	   <div class="selectListStrings">
	    <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	    <select name="selectedObjectName">
	     <logic:iterate id="value" name="createQueryForm" property="SOVLs"
                            type="gov.nih.nci.caBIOApp.ui.ValueLabelPair">
	      <option value="<%=value.getValue()%>"
		<%=(value.getValue().equals(createQueryForm.getSelectedObjectName()) ? " selected" : "")%>>
		<%= value.getLabel() %>
	      </option>
	     </logic:iterate>
	    </select>
	   </div>
	  </td>
	 </tr>
	</table>
       
       <img src="images/bTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Enter a name for this query.
        <table>
         <tr>
          <td>
	   <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/><input type="text" name="newQueryLabel" onKeyPress="window.top.cancelEnterKey(window.event)"/>
	  </td>
         </tr>
	</table>
       
       <img src="images/cTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Create the query.
	<table>
	 <tr>
	  <td>
	   <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/><input type="button" value="Create"
                  onclick="createQuery( this.form )"/>
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
      Work With An Existing Query
     </div>
    </td>
   </tr>
   <tr>
    <td>
     <div class="textMediumDark">
      
       <img src="images/aTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Select the query with which you would like to work.
	<table>
	 <tr>
	  <td>
	   <div class="selectListStrings">
	    <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
	    <select name="selectedQueryDesignId">
	     <logic:iterate id="value" name="createQueryForm" property="QDVLs"
                            type="gov.nih.nci.caBIOApp.ui.ValueLabelPair">
	      <option value="<%=value.getValue()%>"
		<%=(value.getValue().equals(createQueryForm.getSelectedQueryDesignId()) ? " selected" : "")%>>
		<%= value.getLabel() %>
	      </option>
	     </logic:iterate>
	    </select>
	   </div>
	  </td>
	 </tr>
	</table>
       
       <img src="images/bTan.gif" width="30" height="30" hspace="0" vspace="0" border="0" align="absmiddle"/>
        Work with the query.
	<table>
	 <tr>
	  <td>
	   <img src="images/shim.gif" width="30" height="5" hspace="0" vspace="0" border="0" align="left"/>
           <input type="button" value="Edit"
                  onclick="selectQuery( this.form )"/>
	   <input type="button" value="Rename"
                  onclick="renameQuery( this.form )"/>
	   <input type="button" value="Remove"
                  onclick="removeQuery( this.form )"/>
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
   window.top.tabsPanel.refresh( "createQuery" );
   window.top.activePanel = window.top.sidebarPanel;
   window.top.topPanel.location = "createQueryInstructions.html";
   window.top.middlePanel.location = "emptyMiddlePanel.html";
  </script>
 </body>
</html>

