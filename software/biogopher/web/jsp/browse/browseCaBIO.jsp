<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.util.*,
                 gov.nih.nci.common.search.*,
		 gov.nih.nci.caBIOApp.sod.*" %>
<%
String beanName = request.getParameter( "beanName" );
String beanId = request.getParameter( "beanId" );
String roleName = request.getParameter( "roleName" );
MessageLog.printInfo( "browseCaBIO.jsp: beanName = " + beanName + ", beanId = " + beanId + ", roleName = " + roleName );
CaBIOPagerDataSource2 ds = null;
String title = null;
SODUtils sod = SODUtils.getInstance();
SearchableObject so1 = sod.getSearchableObject( beanName );
if( roleName == null ){
   ds = new CaBIOPagerDataSource2( beanName, "browse" );
   title = so1.getLabel();
}else{
   SearchCriteria sc = CaBIOUtils.reverseSearchCriteria( beanName, beanId, roleName );
   ds = new CaBIOPagerDataSource2( sc, "browse" );
   Association assoc = sod.getAssociationWithRole( so1, roleName );
   title = so1.getLabel() + " -&gt; " + assoc.getLabel();
}
request.setAttribute( "browserDatasource", ds );
request.setAttribute( "browserTitle", title );
%>
<jsp:forward page="browse"/>

