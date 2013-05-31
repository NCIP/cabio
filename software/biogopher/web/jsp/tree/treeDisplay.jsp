<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%!
private int getConnectorSize( DefaultMutableTreeNode node, int level ){
 int size = 0;
 if( node.getLevel() == level ){
  if( node.getChildCount() > 0 ){
   if( node.getNextSibling() == null ){
    size = 8;
   }else{
    size = 30;
   }
  }else{
   if( node.getParent().getParent() == null && node.getNextSibling() == null ){
    size = 15;
   }else if( node.getNextSibling() == null ){
    size = 18;
   }else{
    size = 30;
   }
  }
 }else{
  //get the parent at this level
  DefaultMutableTreeNode parentAtLevel = (DefaultMutableTreeNode)node.getParent();
  for( int i = parentAtLevel.getLevel(); i > level; i-- ){
   parentAtLevel = (DefaultMutableTreeNode)parentAtLevel.getParent();
  }
  if( parentAtLevel.getNextSibling() == null ){
   size = 0;
  }else{
   size = 30;
  }
 }
 return size;
}

%>
<script language="javascript">
function displayDesc(theElement, idx, level, theContent){
 var myDiv = document.all.descLayer;
 myDiv.style.zIndex = 10;
 myDiv.style.posTop = 28 * idx + 2 * idx;
 myDiv.style.posLeft = ( 15 * level ) + 10;
 myDiv.style.backgroundColor = "#FFFFCC";
 myDiv.style.border = "inset gray 1px";
 myDiv.style.color = "gray";
 myDiv.innerHTML = theContent;
 myDiv.style.display = "";
}
function hideDesc(){
 document.all.descLayer.style.display = "none";
}
</script>

<div style="position:absolute; left:15; top:50">

  <!-- BEGIN MAIN TABLE -->
  <table border="0" cellpadding="0" cellspacing="0">
   <% int idx = 0;
      Enumeration nodes = treeBean.getTree().preorderEnumeration(); 
      while( nodes.hasMoreElements() ){
       DefaultMutableTreeNode node = (DefaultMutableTreeNode)nodes.nextElement();
       NodeContent nodeContent = (NodeContent)node.getUserObject();

       //Check if this node should be rendered
       if( !treeBean.showNode( node ) ){
        continue;
       }else{
        idx++;
       }
       %>
       <tr>
        <td>
	 <!-- BEGIN NODE TABLE -->
	<% if( nodeContent.isActive() ){ %>
	 <a name="activeNode">
	<% } %>
	<div onmouseover="displayDesc( this, <%=idx%>, <%=node.getLevel()%>, '<%= gov.nih.nci.caBIOApp.ui.form.FormUtils.escapeApostrophes(nodeContent.getDescription()) %>')"
	     onmouseout="hideDesc()">
	 <table border="0" cellpadding="0" cellspacing="0">

	 

	  <tr>
	   <!-- BEGIN SPACER CELL -->
	   <td valign="top">
	    <% if( node.getParent() != null ){//node is not root %>
	    <table border="0" cellpadding="0" cellspacing="0">
	     <tr>
	      <% for( int i = 1; i <= node.getLevel(); i++ ){ %>
	      <td align="right" valign="top">
	       <% int connectorSize = getConnectorSize( node, i ); %>
	       <% if( connectorSize > 0 ){ %>
	       <img src="<%= treeBean.getSkin() %>/images/vertBar.jpg" 
	            border="0" align="top" width="10"
	            height="<%=connectorSize%>"
	       />
	       <% }else{ %>
	       <img src="<%= treeBean.getSkin() %>/images/transparent.gif" 
	            border="0" align="top" width="10"
	            height="30"
	       />
	       <% } %>

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

	     <% if( nodeContent.isExpanded() ){ %>
	     
	      <a href="<%= treeBean.getEventHandlerURL( "collapse", nodeContent.getId() ) %>">
	       <img src="<%= treeBean.getSkin() %>/images/folderOpen.jpg"
	            vspace="0" hspace="0" border="0" 
		    <%-- alt="<%= nodeContent.getDescription() %>" --%>/>
	      </a>

	     <% }else{//node is collapsed %>

	      <a href="<%= treeBean.getEventHandlerURL( "expand", nodeContent.getId() ) %>">
	       <img src="<%= treeBean.getSkin() %>/images/folderClosed.jpg"
	            vspace="0" hspace="0" border="0" 
		    <%-- alt="<%= nodeContent.getDescription() %>" --%>/>
	      </a>

	     <% }//-- end node is collapsed %>

	    <% }else{//node is leaf %>

	     <% if( node.getParent() == null ){//node is root %>
	      <img src="<%= treeBean.getSkin() %>/images/root.jpg"
	           vspace="0" hspace="0" border="0" 
		   <%-- alt="<%= nodeContent.getDescription() %>" --%>/>
	     <% }else{//node is not root %>
	      <img src="<%= treeBean.getSkin() %>/images/leaf.jpg"
	           vspace="0" hspace="0" border="0" 
		   <%-- alt="<%= nodeContent.getDescription() %>" --%>/>
	     <% }//-- end nod is root %>

	    <% }//-- end node is leaf %>
	   </td>
	   <!-- END ICON CELL -->

	   <!-- BEGIN CONTENT CELL -->
	   <td>

	    <!-- BEGIN EXTRA CONTENT -->
	    <% if( nodeContent.hasExtraContent() &&
	           nodeContent.isExtraContentFirst() ){ %>
	     <%= nodeContent.getExtraContent() %>
	    <% } %>
	    <!-- END EXTRA CONTENT -->

	    <% if( nodeContent.getLink() != null ){ %>

	     <% if( nodeContent.getTarget() != null ){ %>

	      <a target="<%= nodeContent.getTarget() %>"
		 href="<%= nodeContent.getLink() %>"/>
	       <%= nodeContent.getContent() %>
	      </a>

	     <% }else{//has target %>

	      <a href="<%= nodeContent.getLink() %>"/>
	       <%= nodeContent.getContent() %>
	      </a>

	     <% }//-- end nodeContent has target %>

	    <% }else{ %>

	     <%= nodeContent.getContent() %>

	    <% } %>

	    <!-- BEGIN EXTRA CONTENT -->
	    <% if( nodeContent.hasExtraContent() &&
	           !nodeContent.isExtraContentFirst() ){ %>
	     <%= nodeContent.getExtraContent() %>
	    <% } %>
	    <!-- END EXTRA CONTENT -->

	   </td>
	   <!-- END CONTENT CELL -->
	  </tr>
         </table>
	 <!-- END NODE TABLE -->
	 </div>
	 <% if( nodeContent.isActive() ){ %>
	  </a>
	 <% } %>
        </td>
       </tr>
    <% }//-- end while( node.hasMoreElements... %>
  </table>

 <div id="descLayer" style="position:absolute; display:none; width:250;"></div>
</div>
  <script language="javascript">
   var activeNode = document.all.activeNode;
   if( activeNode != null ){
     activeNode.scrollIntoView();
   }
  </script>
  <!-- END MAIN TABLE -->


