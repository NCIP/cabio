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

public class CreateQueryAction extends Action{

  private boolean _initialized = false;
  private String _mainObjectNameKey = null;
  private String _designQueryActionPath = null;
  private String _queryDesignsKeyName = null;
  private String _queryDesignKeyName = null;

  public ActionForward perform( ActionMapping mapping, 
				ActionForm f,
				HttpServletRequest request,
				HttpServletResponse response )
    throws IOException, ServletException
  {
    if( !_initialized ){
      initParams( mapping.getPath() );
    }
    CreateQueryForm form = (CreateQueryForm)f;
    WorkflowState state = WorkflowState.getState( request, mapping );
    String lastStep = state.getLastStep();
    String nextStep = state.getNextStep();
    ActionForward forward = mapping.findForward( "error" );
    HttpSession session = request.getSession();

    if( form.getCallingSubAction() ){
      form.setCallingSubAction( false );
      /*
      HashMap qds = (HashMap)session.getAttribute( _queryDesignsKeyName );
      QueryDesign qd = null;
      if( qds.size() > 0 ){
	String id = ( qds.size() - 1 ) + "." + form.getSelectedObjectName();
	MessageLog.printInfo( "CreateQueryAction: looking for query design: " + id );
	qd = (QueryDesign)qds.get( id );
	if( qd != null ){
	  session.setAttribute( _queryDesignKeyName, qd );
	}
      }
      */
      QueryDesign qd = (QueryDesign)session.getAttribute( _queryDesignKeyName );
      if( qd != null ){
	if( qd.getRootSearchCriteriaNode().isEmpty() ){
	  HashMap designs = (HashMap)session.getAttribute( _queryDesignsKeyName );
	  if( designs != null ){
	    designs.remove( qd.getId() );
	  }
	}else{
	  session.setAttribute( _queryDesignKeyName, qd );
	}
      }
      forward = prepareToFinish( state, mapping );

    }else if( "displaySelection".equals( lastStep ) ){

      if( "cancel".equals( nextStep ) ){
	forward = prepareToFinish( state, mapping );
      }else if( "rename".equals( nextStep ) ){
	  form.rename();
	  forward = mapping.findForward( "searchableObjectSelection" );
      }else if( "remove".equals( nextStep ) ){
	  form.remove();
	  forward = mapping.findForward( "searchableObjectSelection" );
      }else{
	  QueryDesign qd = null;
	  if( "create".equals( nextStep ) ){
	      qd = form.create();
	  }else if( "select".equals( nextStep ) ){
	      qd = form.select();
	  }else{
	      throw new ServletException( "Unknown action: " + lastStep +
					  " - " + nextStep );
	  }
	  session.setAttribute( _queryDesignKeyName, qd );
	  form.setCallingSubAction( true );
	  state.pushState();
	  forward = mapping.findForward( _designQueryActionPath );
      }
    }else{
      HashMap designs = (HashMap)session.getAttribute( _queryDesignsKeyName );
      if( designs == null ){
	designs = new HashMap();
	session.setAttribute( _queryDesignsKeyName, designs );
      }
      
      form.setQueryDesigns( designs );
      forward = mapping.findForward( "searchableObjectSelection" );
    }

    MessageLog.printInfo( mapping.getPath() + ": forwarding to - " + 
			  ( forward == null ? "null" : forward.getPath() ) );

    return forward;
  }

  public void initParams( String path )
    throws ServletException
  {
    try{
      AppConfig config = AppConfig.getInstance();
      ActionParams myParams = config.getActionParams( path );
      _designQueryActionPath = myParams.getParam( "designQueryActionPath" );
      _queryDesignsKeyName = myParams.getParam( "queryDesignsKeyName" );
      ActionParams dqParams = config.getActionParams( _designQueryActionPath );
      _mainObjectNameKey = dqParams.getParam( "mainObjectNameKey" );
      _queryDesignKeyName = dqParams.getParam( "queryDesignKeyName" );
      _initialized = true;
    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error initializing", ex );
    }
  }

  private ActionForward prepareToFinish( WorkflowState state, ActionMapping mapping ){
    ActionForward forward = null;
    if( state.isNested() ){
      state.popState();
      MessageLog.printInfo( "CreateQueryAction: just popped state, action = " +
			    state.getAction() + ", nextStep = " + state.getNextStep() +
			    ", lastStep = " + state.getLastStep() );
      forward = mapping.findForward( state.getAction() );
    }else{
      forward = mapping.findForward( "default" );
    }
    return forward;
  }
}

