package gov.nih.nci.caBIOApp.ui.action;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.struts.action.*;

import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;
import gov.nih.nci.caBIOApp.ui.form.*;
import gov.nih.nci.caBIOApp.util.*;

public class WorkflowExceptionAction extends Action{

  public ActionForward perform( ActionMapping mapping, 
				ActionForm f,
				HttpServletRequest request,
				HttpServletResponse response )
    throws IOException, ServletException
  {
    WorkflowExceptionForm form = (WorkflowExceptionForm)f;
    form.setState( WorkflowState.getState( request, mapping ) );
    ActionForward forward = mapping.findForward( "displayError" );
    MessageLog.printInfo( mapping.getPath() + ": forwarding to - " + forward.getPath() );
    return forward;
  }

}

