<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ page import="gov.nih.nci.system.web.util.JSPUtils,
				 java.lang.reflect.*,
				 java.util.*" %> 
			 
<link href="styleSheet.css" type="text/css" rel="stylesheet" />
<%
JSPUtils jspUtils= null;
List fieldNames=new ArrayList();
List domainNames=new ArrayList();
String message = null, selectedSearchDomain=null;
String className = (String)request.getAttribute("klassName");

//out.println("className: " + className);
//session.setAttribute("selectedDomain", className);

if(className != null)
{
	try
	{	
		jspUtils = JSPUtils.getJSPUtils(config.getServletContext());
		fieldNames = jspUtils.getSearchableFields(className);
		domainNames = jspUtils.getAssociations(className);
		
	}
	catch(Exception ex){
		message=ex.getMessage();
	}
	
	if(fieldNames != null && fieldNames.size() > 0)
	{ 	
%>
<form method="post" target="_blank" action="Result.action" name="Result" id="Result">
	<table summary="layout" cellpadding="3" cellspacing="0" border="0" align="center">
		<tr>
			<td class="formTitle" height="20" colspan="3"><s:property value="fullyQualClassName" /></td>
		</tr>
		<% 
		
		if(fieldNames != null && fieldNames.size() > 0)
		{  
			String attrName="";
		   	String attrType="";
		   	String attrGenericTypeClassName;
		   	String attrTypeClassName = "";
		   
		   	for(int i=0; i < fieldNames.size(); i++)
		   	{	attrName = ((Field)fieldNames.get(i)).getName();
			   	attrType = ((Field)fieldNames.get(i)).getType().getName(); 
			   	
			    int beginIndex = attrType.lastIndexOf('.');
				if (beginIndex > 0) {
				  ++beginIndex;
					attrTypeClassName =  attrType.substring(beginIndex).toUpperCase();
				}			
			   	
		%>
			   	
		<tr align="left" valign="top">
			<td class="formRequiredNotice" width="5px">&nbsp;</td>
			<td class="formLabel" align="right"><label for="<%=attrName%>"><%=attrName%>:</label></td>
		<% if ( attrType.equalsIgnoreCase("java.Lang.Boolean") ) {%>
			<td class="formField" width="90%"><SELECT class="formFieldSized" NAME=<%=attrName%> id="<%=attrName%>" > 
			   		<OPTION SELECTED></OPTION>
			   		<OPTION >True</OPTION>
			   		<OPTION >False</OPTION>
			</SELECT></td>
		<%} else {%>
			<td class="formField"><input type="text" name="<%=attrName%>" class="formField" size="14" theme="simple" id="<%=attrName %>"/></td>
		<%}%>
		</tr>
		  <%}%>
		<tr align="left" valign="top">
			<td class="formRequiredNotice" width="5px">&nbsp;</td>
			<td class="formLabel" align="right"><label for="searchObj">Search Object:</label></td>
			<td class="formField" width="90%"><SELECT tabIndex="100" class="formFieldSized" size="1" NAME="searchObj" ID="searchObj" STYLE="width:90%">
			<% if(domainNames != null)
			   { if(!((String)domainNames.get(0)).equals("Please choose")) domainNames.add(0, "Please choose");
			   %>
			   		<%for(int i=0; i<domainNames.size(); i++)
			   		{%>
			   		<OPTION<% selectedSearchDomain = request.getParameter("searchObj");
			   				   if((selectedSearchDomain != null) && (domainNames.get(i).equals(selectedSearchDomain))) 
			   					{%> SELECTED <% } %> ><%=domainNames.get(i)%></OPTION>
			   		<%}%>
			   <%}%></SELECT></td>
			<%}// end if(domainNames != null) statement %>
			<%} %>			   
		</tr>
		<tr>
			<td align="left" colspan="3">
				<!-- action buttons begins -->
				<table cellpadding="4" cellspacing="0" border="0" summary="layout">
					<tr align="left">
						<td align="left"><input type="submit" name="BtnSearch" class="actionButton" value="Submit" ></td>
						<td align="left"><input class="actionButton" type="reset" value="Reset"></td> 
					</tr>
				</table>
				<!-- action buttons end -->
			</td>	
		</tr>
	</table>
	<s:hidden name="selectedDomain" />
</form>
<%		
	}%> 
