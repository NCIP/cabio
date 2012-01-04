<%@ page import="javax.swing.tree.*,
                gov.nih.nci.caBIOApp.ui.tree.*,
                gov.nih.nci.caBIOApp.ui.*,
		java.util.*" %>
<jsp:useBean id="designReportForm" 
             class="gov.nih.nci.caBIOApp.ui.form.DesignReportForm"
	     scope="session"/>
<% int baseWidth = 1; 
 DefaultMutableTreeNode tree = designReportForm.getReportDesign().getQueryDesign().getRootSearchCriteriaNode(); 
 TreeBean treeBean = new CriteriaSummaryTreeBean(); 
 treeBean.setTree( tree );
 treeBean.setSkin( "skin" );
 String skin = treeBean.getSkin(); %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <% if( request.getHeader( "User-Agent" ).indexOf( "MSIE" ) != -1 ){ %>
<style type="text/css">
BODY 
{
	border: 2px solid #CC9900;
	font-family: Tahoma, Arial, Helvetica, sans-serif;
	font-size: .9em;
	font-weight: bold;
	color: #FFFFFF;
	background-color: #2b5871;
	padding: 20px;
}

A {
	font-family: Tahoma, Arial, Helvetica, sans-serif;
	font-size: .9em;
	font-weight: normal;
	color: #FFFFFF;
}
a:hover {
	color: #CC6600;
}
a:active {
	color: #CC6600;
}
.highlightNode 
{
	background-color: #6495ED;
}
table{
	cell-spacing: 0;
	padding: { 0, 0, 0, 0 };
}
</style>
  <% }else{ %>
  <style type="text/css">
BODY 
{
	font-family: Tahoma, Arial, Helvetica, sans-serif;
	font-size: .9em;
	font-weight: bold;
	color: #FFFFFF;
	padding: 20px;
}

A {
	font-family: Tahoma, Arial, Helvetica, sans-serif;
	font-size: .9em;
	font-weight: normal;
	color: #FFFFFF;
}
a:hover {
	color: #CC6600;
}
a:active {
	color: #CC6600;
}
.highlightNode 
{
	background-color: #6495ED;
}
table{
	cell-spacing: 0;
	padding: { 0, 0, 0, 0 };
}

  </style>
  <% } %>

  <script language="javascript" src="<%= skin %>/treeDisplay.js"></script>
  <script language="javascript">
   function refresh(){
    window.location = "<%=request.getContextPath()%>/criteriaTreeHandler";
   }
  </script>
 </head>
 <body>
 

  <!-- BEGIN MAIN TABLE -->
  <table border="0" cellpadding="0" cellspacing="0">
   <% 
      Enumeration nodes = treeBean.getTree().preorderEnumeration(); 
      while( nodes.hasMoreElements() ){
       DefaultMutableTreeNode node = (DefaultMutableTreeNode)nodes.nextElement();
       NodeContent nodeContent = (NodeContent)node.getUserObject();
       %>
       <tr>
        <td>
	 <!-- BEGIN NODE TABLE -->
	 <table border="0" cellpadding="0" cellspacing="0">
	  <tr>
	   <!-- BEGIN SPACER CELL -->
	   <td valign="top">
	    <% if( node.getParent() != null ){//node is not root %>
	    <table border="0" cellpadding="0" cellspacing="0">
	     <tr>
	      <% for( int i = 1; i <= node.getLevel(); i++ ){ %>
	      <td width="30" align="right" valign="top">
	       <img src="<%= treeBean.getSkin() %>/images/transparent.gif" 
	            border="0" align="top" width="5"
	            height="30"
	       />
	      </td>
	      <% }//-- end for( int i... %>
	     </tr>
	    </table>
	    <% }//-- end node is not root %>
	   </td>


	   <!-- END SPACER CELL -->      

	   <!-- BEGIN ICON CELL -->
	   <td width="40" align="left">	   
	    <% if( !node.isLeaf() ){ %>

	       <img src="<%= treeBean.getSkin() %>/images/folderOpen.jpg"
	            vspace="0" hspace="0" border="0" 
		    alt="<%= nodeContent.getDescription() %>"/>

	    <% }else{//node is leaf %>

	     <% if( node.getParent() == null ){//node is root %>
	      <img src="<%= treeBean.getSkin() %>/images/root.jpg"
	           vspace="0" hspace="0" border="0" 
		   alt="<%= nodeContent.getDescription() %>"/>
	     <% }else{//node is not root %>
	      <img src="<%= treeBean.getSkin() %>/images/dot.jpg"
	           vspace="0" hspace="0" border="0" 
		   alt="<%= nodeContent.getDescription() %>"/>
	     <% }//-- end nod is root %>

	    <% }//-- end node is leaf %>
	   </td>
	   <!-- END ICON CELL -->

	   <!-- BEGIN CONTENT CELL -->
	   <td>

	     <%= nodeContent.getContent() %>

	   </td>
	   <!-- END CONTENT CELL -->
	  </tr>
         </table>
	 <!-- END NODE TABLE -->
        </td>
       </tr>
    <% }//-- end while( node.hasMoreElements... %>
  </table>
  <!-- END MAIN TABLE -->



 </body>
</html>
