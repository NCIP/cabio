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
Once you are finished specifying values, you may proceed to formatting
your report by clicking on the <em>Report Format</em> tab, above.

<% if( designQueryForm.isShowingMergeButton() ){ %>
<%-- ..then the user has the option to merge on an uploaded spreadsheet --%>
<p>
<b>What do these mean?:</b>
&nbsp;
<img src="images/not_merge.gif"/>
&nbsp; and &nbsp;
<img src="images/merge.gif"/>
<p>
BIOgopher gives you the option of merging your search results
into a spreadsheet that you supply. If you have selected values from a
spreadsheet for an attribute, an icon will be displayed in the bottom panel
next to the attribute for which you specified those values.
<p>
Clicking on this icon allows you to specify whether you want you search results
to be merged into you original spreadsheet. The default is to not merge
<img src="images/not_merge.gif"/>. Clicking on this will change it to
<img src="images/merge.gif"/>, which indicates that you want to merge.

<% } %>
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

