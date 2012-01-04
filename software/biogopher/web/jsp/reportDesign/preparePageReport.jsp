<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.ui.*,
	         gov.nih.nci.caBIOApp.report.*,
		 gov.nih.nci.caBIOApp.util.*,
	         java.io.*,
	         java.util.*" %>
<%!
  String _exportDirectoryName = "exports";

  private ValueLabelPair cacheReport( Table table, String fileName, HttpServletRequest request )
    throws Exception
  {
    ValueLabelPair vlp = null;
    String filePath = File.separator +
      _exportDirectoryName + File.separator + request.getSession().getId();
    String realPath =
      getServletConfig().getServletContext().getRealPath( "" ) + filePath;
    try{
      File f = new File( realPath );
      if( !f.exists() ){
	f.mkdirs();
      }
      f.deleteOnExit();
    }catch( Exception ex ){
      throw new ServletException( "Error creating export directory", ex );
    }
    String hrefPath =
      request.getContextPath() + filePath;
    String fullPath = realPath + File.separator + fileName;
    try{
      File f = new File( fullPath );
      f.deleteOnExit();
      OutputStream out = new FileOutputStream( fullPath );
      TableFormatter tf = new ExcelFormatter();
      out.write( tf.format( table ) );
      out.flush();
      out.close();
    }catch( Exception ex ){
      throw new ServletException( "Error writing " + fileName, ex );
    }
    FileCleanupThread.getInstance().addFile( fullPath );
    vlp = new ValueLabelPair( hrefPath + File.separator + fileName, fileName );

    return vlp;
  }
%>
<%
boolean successful = true;
ValueLabelPair reportLink = null;
String s1 = null;
String s2 = null;
try{
   String rdKey = request.getParameter( "reportDesignKey" );
   ReportDesign rd = (ReportDesign)session.getAttribute( rdKey );
   ReportDatasource rds = new ReportDatasource( rd );
   Table report = rds.getReport();
   reportLink = cacheReport( report, rd.getLabel() + System.currentTimeMillis() + ".xls", request );
   s1 = "reportDatasource" + System.currentTimeMillis();
   s2 = "reportBean" + System.currentTimeMillis();
   request.setAttribute( s1, rds );
}catch( Exception ex ){
   MessageLog.printInfo( "Error generating report: " + ex.getMessage() );
   request.setAttribute( "gov.nih.nci.caBIO.ui.error.exception", ex );
   request.setAttribute( "gov.nih.nci.caBIO.ui.error.exception_type", "report" );
%>
  <jsp:forward page="logError.jsp"/>
<%
}
%>
<jsp:forward page="pageReport">
 <jsp:param name="reportLink" value="<%=reportLink.getValue()%>"/>
 <jsp:param name="gov.nih.nci.caBIOApp.ui.pager.dataSourceKeyName" value="<%=s1%>"/>
 <jsp:param name="gov.nih.nci.caBIOApp.ui.pager.pagerBeanKeyName" value="<%=s2%>"/>
</jsp:forward>
