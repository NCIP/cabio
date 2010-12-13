package gov.nih.nci.caBIOApp.ui.action;

import org.apache.struts.action.*;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;
import gov.nih.nci.caBIOApp.sod.*;
import gov.nih.nci.caBIOApp.ui.form.*;
import gov.nih.nci.caBIOApp.util.*;

public class MyCaBIOMainAction extends Action{

  private boolean _initialized = false;
  private String _supplyDatasourceActionPath = null;
  private String _createReportActionPath = null;
  private String _createQueryActionPath = null;
  private String _selectedQueryDesignKeyName = null;
  private String _selectedReportDesignKeyName = null;
  private String _exportDirectoryName = null;
  private String _allowSelectionKeyName = null;
  private String _allowUploadKeyName = null;

  public ActionForward perform( ActionMapping mapping, 
				ActionForm f,
				HttpServletRequest request,
				HttpServletResponse response )
    throws IOException, ServletException
  {
    if( !_initialized ){
      initParams( mapping.getPath() );
    }
    MyCaBIOMainForm form = (MyCaBIOMainForm)f;
    WorkflowState state = WorkflowState.getState( request, mapping );
    String lastStep = state.getLastStep();
    String nextStep = state.getNextStep();
    ActionForward forward = mapping.findForward( "error" );
    
    MessageLog.printInfo( "MyCaBIOMainAction.perform(): nextStep = " +
			  nextStep + ", lastStep = " + lastStep +
			  ", callingSubAction = " + form.getCallingSubAction() );
    
    HttpSession session = request.getSession();
    if( form.getCallingSubAction() ){
      form.setCallingSubAction( false );
      if( "supplyDatasource".equals( nextStep ) ){
	forward = mapping.findForward( "supplyDatasourceFinish" );
      }else if( "createQuery".equals( nextStep ) ){
	form.setQueryDesign( (QueryDesign)session.getAttribute( _selectedQueryDesignKeyName ) );
	session.removeAttribute( _selectedQueryDesignKeyName );
	forward = mapping.findForward( "createQueryFinish" );
      }else if( "createReport".equals( nextStep ) ){
	ReportDesign design = (ReportDesign)session.getAttribute( _selectedReportDesignKeyName );
	if( design == null ){
	  MessageLog.printInfo( "MyCaBIOMainAction: no report design returned from createReport" );
	}
	form.setReportDesign( design );
	session.removeAttribute( _selectedReportDesignKeyName );
	forward = mapping.findForward( "createReportFinish" );
      }else{
	//throw new ServletException( "unkown operation: " + lastStep +
	//			    " - " + nextStep );
	//forward = mapping.findForward( "WorkflowException" );
	forward = mapping.findForward( "displayWorkflow" );
      }
    }else if( "displayWorkflow".equals( lastStep ) ){
      if( "generateReport".equals( nextStep ) ){
	Table report = form.generateReport();
	if( form.getQueryDesign() == null ){
	  throw new ServletException( "QUERY DESIGN IS NULL" );
	}
	ValueLabelPair vlp = 
	  cacheReport( report, 
		       form.getQueryDesign().getId() + ".xls", 
		       request );
	form.setReportDownloadLink( vlp );
	form.setScrollDirection( "begin" );
	form.scroll();
	forward = mapping.findForward( "displayReport" );
      }else{
	if( "supplyDatasource".equals( nextStep ) ){
	  session.setAttribute( _allowSelectionKeyName, "false" );
	  session.setAttribute( _allowUploadKeyName, "true" );
	  forward = mapping.findForward( _supplyDatasourceActionPath );
	}else if( "createQuery".equals( nextStep ) ){
	  forward = mapping.findForward( _createQueryActionPath );
	}else if( "createReport".equals( nextStep ) ){
	  QueryDesign design = form.getQueryDesign();
	  if( design != null ){
	    session.setAttribute( _selectedQueryDesignKeyName, form.getQueryDesign() );
	  }
	  forward = mapping.findForward( _createReportActionPath );	  
	}else{
	  //throw new ServletException( "unkown operation: " + lastStep +
	  //		      " - " + nextStep );
	  forward = mapping.findForward( "WorkflowException" );
	}
	state.pushState();
	form.setCallingSubAction( true );
      }
    }else if( "displayReport".equals( lastStep ) ){
      if( "scroll".equals( nextStep ) ){
	form.scroll();
	forward = mapping.findForward( "displayReport" );
      }else{
	form.reset();
	forward = mapping.findForward( "displayReportFinish" );
      }
    }else{
      form.reset();
      forward = mapping.findForward( "displayWorkflow" );
    }


    MessageLog.printInfo( mapping.getPath() + ": forwarding to - " + 
			  ( forward == null ? "null" : forward.getPath() ) );
    return forward;
  }

  private void initParams( String path )
    throws ServletException
  {

    AppConfig config = null;
    try{
      config = AppConfig.getInstance();
    }catch( Exception ex ){
      throw new ServletException( "Unable to get config instance.", ex );
    }

    ActionParams params = config.getActionParams( path );
    _supplyDatasourceActionPath = params.getParam( "supplyDatasourceActionPath" );
    _createQueryActionPath = params.getParam( "createQueryActionPath" );
    _createReportActionPath = params.getParam( "createReportActionPath" );
    _exportDirectoryName = params.getParam( "exportDirectoryName" );
    ActionParams cqSubParams = config.getActionParams( _createQueryActionPath );
    _selectedQueryDesignKeyName = cqSubParams.getParam( "queryDesignKeyName" );
    ActionParams crSubParams = config.getActionParams( _createReportActionPath );
    _selectedReportDesignKeyName = crSubParams.getParam( "reportDesignKeyName" );
    ActionParams sdSubParams = config.getActionParams( _supplyDatasourceActionPath );
    _allowSelectionKeyName = sdSubParams.getParam( "allowSelectionKeyName" );
    _allowUploadKeyName = sdSubParams.getParam( "allowUploadKeyName" );
    _initialized = true;
  }

  private ValueLabelPair cacheReport( Table table, String fileName, HttpServletRequest request )
    throws ServletException
  {
    ValueLabelPair vlp = null;
    String filePath = File.separator +
      _exportDirectoryName + File.separator + request.getSession().getId();
    String realPath =
      getServlet().getServletContext().getRealPath( "" ) + filePath;
    try{
      File f = new File( realPath );
      if( !f.exists() ){
	f.mkdirs();
      }
    }catch( Exception ex ){
      throw new ServletException( "Error creating export directory", ex );
    }
    String hrefPath =
      request.getContextPath() + filePath;
    String fullPath = realPath + File.separator + fileName;
    try{
      OutputStream out = new FileOutputStream( fullPath );
      TableFormatter tf = new ExcelFormatter();
      out.write( tf.format( table ) );
      out.flush();
      out.close();
    }catch( Exception ex ){
      throw new ServletException( "Error writing " + fileName, ex );
    }
    vlp = new ValueLabelPair( hrefPath + File.separator + fileName, fileName );

    return vlp;
  }

}

