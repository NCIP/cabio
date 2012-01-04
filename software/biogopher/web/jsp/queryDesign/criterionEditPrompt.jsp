<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="designQueryForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.DesignQueryForm"/>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link href="styles/common.css" rel="stylesheet" type="text/css">
  <title><bean:message key="designQueryForm.editPanel.promptScreen.title"/></title>
  <script language="javascript" src="criterionEdit_script.js"></script>
 </head>
 <body class="boxTopDark">
  <% if( designQueryForm.isSummaryToBeRefreshed() ){ %>
   <script language="javascript">
    window.top.middlePanel.refresh();
   </script>
  <% } %>
<table>
 <tr>
  <td>
  <div class="headerLargeLight">
   Designing A Query
  </div>
  </td>
 </tr>
 <tr>
  <td>
<div class="textMediumLight">
To design a query, you start with the tree on the left. This tree displays
the object for which you are searching, its attributes, and its associated
objects. You build a query by specifying values for the attributes of the object
for which you are searching and/or the attributes of its associated objects.
<p>
When you click on one of the attributes in the tree on the left, a form
will appear in this (upper right) screen that will allow you to specify
values for the selected attribute. Once you have finished entering values,
you press the <em>Update Query</em> button. Doing so will move your
<em>Working Values</em> into you query. As you work, your query will be
displayed in the bottom right panel, below.
<p>
Once you are finished specifying values, you may proceed to formatting
your report by clicking on the <em>Report Format</em> tab, above.
</div>
  </td>
 </tr>
</table>

  <html:form action="/designQuery" method="post">
   <input type="hidden" name="nextStep" value=""/>
   <input type="hidden" name="lastStep" value="displayPromptScreen"/>
   <input type="hidden" name="selectedCriterionId" value=""/>
  </html:form>

 <script language="javascript">
  window.top.activePanel = window.top.topPanel;
 </script>

 </body>
</html>

