<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page import="javax.swing.tree.*,
                gov.nih.nci.caBIOApp.ui.tree.*,
                gov.nih.nci.caBIOApp.ui.*,
		java.util.*" %>
<jsp:useBean id="objectTreeBean" 
             class="gov.nih.nci.caBIOApp.ui.tree.TreeBean"
	     scope="session"/>
<jsp:useBean id="designQueryForm" 
             class="gov.nih.nci.caBIOApp.ui.form.DesignQueryForm"
	     scope="session"/>
<jsp:useBean id="designReportForm" 
             class="gov.nih.nci.caBIOApp.ui.form.DesignReportForm"
	     scope="session"/>
<% gov.nih.nci.caBIOApp.ui.tree.TreeBean treeBean = objectTreeBean; 
   int baseWidth = 1; 
   String skin = treeBean.getSkin();
   WorkflowState state = (WorkflowState)session.getAttribute( UIConstants.WORKFLOW_STATE_KEY );
   boolean designingReport = ( state != null && "/designReport".equals( state.getAction() ) );
%>

<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <% if( request.getHeader( "User-Agent" ).indexOf( "MSIE" ) != -1 ){ %>
  <link rel="stylesheet" type="text/css" href="<%= skin %>/treeDisplay.css"/>
  <% }else{ %>
  <link rel="stylesheet" type="text/css" href="<%= skin %>/treeDisplay-ns.css"/>
  <% } %>
  <script language="javascript" src="<%= skin %>/treeDisplay.js"></script>
  <script language="javascript">
   function viewCriteria( queryID ){
     window.open( 'viewCriteria.jsp?&bp=' + <%=Long.toString(System.currentTimeMillis())%>,
                  'viewCriteria', 'width=500,height=200,resizable,scrollbars' );
   }
  </script>
 </head>
 <body>
<% if( designingReport ){ %>
Query Name: <%= designReportForm.getReportDesign().getQueryDesign().getLabel() %>
 &nbsp;<a href="javascript:viewCriteria()">(view)</a><br>
Report Name: <%= designReportForm.getReportDesign().getLabel() %>
<% }else{ %>
Query Name: <%= designQueryForm.getQueryDesign().getLabel() %>
<% } %>
<p>
 
 <%@ include file="/treeDisplay.jsp" %>

 </body>
</html>
