<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags" %>
<s:url id="browseTreeview" value="/AjaxShowDynamicTree.action" />  <!-- ShowDynamicTree.action" / -->

<table>
<tr>
<td height="20" class="mainMenu">
             
		<!-- main menu begins -->
		<table summary="" cellpadding="0" cellspacing="0" border="0" height="20">
		  <tr>
		    <td width="1"><!-- anchor to skip main menu --><a href="#content"><img src="images/shim.gif" alt="Skip Menu" width="1" height="1" border="0" /></a></td>
			<!-- link 1 begins -->
		    <td height="20" class="mainMenuItem" onmouseover="changeMenuStyle(this,'mainMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'mainMenuItem'),hideCursor()">
		      <s:a theme="ajax"
		      href="AjaxShowDynamicTree.action" targets="content">TreeView Browser</s:a>
		    </td>
		    <!-- link 1 ends -->
		    <td><img src="images/mainMenuSeparator.gif" width="1" height="16" alt="" /></td>
		    <!-- link 2 begins -->
		    <td height="20" class="mainMenuItemOver" onmouseover="changeMenuStyle(this,'mainMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'mainMenuItemOver'),hideCursor()" onclick="document.location.href='ShowDynamicTree.action'">
		      <s:a href="ShowDynamicTree.action">Advanced Query Builder</s:a>
		    </td>
		    <!-- link 2 ends -->
		    <td><img src="images/mainMenuSeparator.gif" width="1" height="16" alt=""/></td>
		    <td height="20" width="100%">&nbsp;</td> 		    
		   		    
		  </tr>
		</table>
		<!-- main menu ends -->
               
</td>
</tr>

</table>

<div id='content' style="border: 1px solid yellow;">&nbsp;</div>