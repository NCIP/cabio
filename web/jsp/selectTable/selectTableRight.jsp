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
 </head>
<body class="boxTopDark">

 <table width="100%" cellpadding="10">
  <tr>
   <td align="left" valign="top">
    <table width="100%">

     <!-- PROMPT SECTION -->
     <tr>
      <td align="left" valign="top">
       <div class="headerMediumLight">
       Currently available spreadsheets:
       </div>
      </td>
     </tr>

     <!-- DATASOURCES SECTION -->
     <tr>
      <td>
       <table width="50%" class="fileList">
      <% if( selectTableForm.getCachedTables().size() > 0 ){ %>
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

      <% }else{ %>
        <tr>
	 <td>NONE</td>
	</tr>
      <% } %>
       </table>
      </td>
     </tr>

     <tr>
      <td>
       <div class="textMediumLight">
	The list, above, displays the spreadsheets that are available for
	use in your queries. You may make as many spreadsheets available as you like.
	<p>
	You must tell BIOgopher which worksheet, within your spreadsheet, that you want
	to make available. The default is the first worksheet. To make more than one
	worksheet from a single spreadsheet file available, repeat steps A-B-C for each
	worksheet, specifying the correct worksheet number each time. The filenames in the
	above list will indicate the worksheet number within brackets. 
       </div>
      </td>
     </tr>


    </table>
   </td>
  </tr>
 </table>

 </body>
</html>

