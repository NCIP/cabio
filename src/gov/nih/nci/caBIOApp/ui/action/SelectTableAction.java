package gov.nih.nci.caBIOApp.ui.action;

import org.apache.struts.action.*;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;
import gov.nih.nci.caBIOApp.ui.form.*;
import gov.nih.nci.caBIOApp.util.*;

public class SelectTableAction extends Action{

  private boolean _initialized = false;
  private String _cachedTablesKeyName = null;
  private String _selectedTableKeyName = null;
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
    SelectTableForm form = (SelectTableForm)f;
    WorkflowState state = WorkflowState.getState( request, mapping );
    String lastStep = state.getLastStep();
    String nextStep = state.getNextStep();
    ActionForward forward = mapping.findForward( "error" );
    HttpSession session = request.getSession();

    //MessageLog.printInfo( "SelectTableAction.perform(): lastStep = " + lastStep + ", nextStep = " + nextStep );

    if( "displayAvailableTables".equals( lastStep ) ){
      if( "upload".equals( nextStep ) ){
	ActionErrors errors = form.addTable();
	if( errors.size() > 0 ){
	  request.setAttribute( Action.ERROR_KEY, errors );
	}
	forward = mapping.findForward( "displayAvailableTables" );
      }else if( "finish".equals( nextStep ) ){
	form.selectTable();
	Table t = form.getSelectedTable();
	if( t != null ){
	  session.setAttribute( _selectedTableKeyName, form.getSelectedTable() );
	}else{
	  session.removeAttribute( _selectedTableKeyName );
	}
	if( state.isNested() ){
	  state.popState();
	  MessageLog.printInfo( "SelectTableAction: just popped state, action = " +
				state.getAction() + ", nextStep = " + state.getNextStep() +
				", lastStep = " + state.getLastStep() );
	  forward = mapping.findForward( state.getAction() );
	}else{
	  forward = mapping.findForward( "default" );
	}	
      }else{
	//throw new ServletException( "unknown operation: " + lastStep +
	//		    " - " + nextStep );
	forward = mapping.findForward( "WorkflowException" );
      }
    }else{
      form.clear();
      initDisplay( form, request );
      forward = mapping.findForward( "displayAvailableTables" );
    }
    MessageLog.printInfo( mapping.getPath() + ": forwarding to - " + 
			  ( forward == null ? "null" : forward.getPath() ) );
    return forward;
  }

  private void initParams( String path )
    throws ServletException
  {
    try{
      AppConfig config = AppConfig.getInstance();
      ActionParams params = config.getActionParams( path );
      _selectedTableKeyName = params.getParam( "selectedTableKeyName" );
      _cachedTablesKeyName = params.getParam( "cachedTablesKeyName" );
      _allowSelectionKeyName = params.getParam( "allowSelectionKeyName" );
      _allowUploadKeyName = params.getParam( "allowUploadKeyName" );
      _initialized = true;
    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error initializing", ex );
    }
  }

  private void initDisplay( SelectTableForm form, HttpServletRequest request )
    throws ServletException
  {
    HttpSession session = request.getSession();
    List cachedTables = (List)session.getAttribute( _cachedTablesKeyName );
    if( cachedTables == null ){
      cachedTables = new ArrayList();
      session.setAttribute( _cachedTablesKeyName, cachedTables );
    }
    form.setCachedTables( cachedTables );
    form.setAllowSelection( "true".equals( (String)session.getAttribute( _allowSelectionKeyName ) ) );
    form.setAllowUpload( "true".equals( (String)session.getAttribute( _allowUploadKeyName ) ) );
    MessageLog.printInfo( "SelectTableAction.initDisplay(): allow selection = " + form.getAllowSelection() +
			  ", allow upload = " + form.getAllowUpload() );
  }

}

