<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.common.util.*,
                 gov.nih.nci.common.search.*,
                 gov.nih.nci.common.search.cache.*" %>
<%
String url = ObjectCacheLoaderServlet.createURL( request );
SearchCriteria sc = URL2SC.map( url );
sc.setMaxRecordset( new Integer( 25 ) );
CaBIOPagerDataSource2 ds = new CaBIOPagerDataSource2( sc, null );
request.setAttribute( "browserDatasource", ds );
request.setAttribute( "browserTitle", sc.getBeanName() );
%>
<jsp:forward page="browse"/>
<%--
<%
ObjectCache oc = ObjectCacheFactory.defaultObjectCache();
SearchResult sr = oc.get( sc );
if( sr == null ){
   System.err.println( "NO OBJECTS CACHED, SEARCHING." );
   sr = sc.search();
   oc.put( sc, sr );
}else{
   System.err.println( sr.getResultSet().length + " OBJECTS FOUND." );  
}
Object[] objs = sr.getResultSet();
for( int i = 0; i < objs.length; i++ ){
   %>Object: <%=objs[i].getClass().getName()%>:<%=COREUtilities.invoke( objs[i], "getId", new Object[0] ).toString()%><br/><%
}
%>
--%>
