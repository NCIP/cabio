<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*" %>
<% 
   String s = request.getParameter( "propertyName" );
   String objName = s.substring( 0, s.lastIndexOf( "." ) );
   String propName = s.substring( s.lastIndexOf( "." ) + 1 );
   session.setAttribute( "browse.objName", objName );
   session.setAttribute( "browse.propName", propName );
   //CaBIOPagerDataSource ds = new CaBIOPagerDataSource( objName, null, "window.top.browse" );
   CaBIOPagerDataSource2 ds = new CaBIOPagerDataSource2( objName, "window.top.browse" );
   request.setAttribute( "gov.nih.nci.caBIOApp.ui.pager.dataSource", ds );
%>
<jsp:forward page="pageCaBIODataHandler"/>

