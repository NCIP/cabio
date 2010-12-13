package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class StartupServlet extends GenericServlet{
    public void init( ServletConfig config )
	throws ServletException
    {
	super.init( config );
	try{
	    AppConfig wac = AppConfig.getInstance();

	}catch( Exception ex ){
	  log( "StartupServlet.init(): caught " + ex.getClass().getName() +
	       ": " + ex.getMessage() );
	    throw new ServletException( "Error initializing ui config. ", ex );
	}
    }
    public void service( ServletRequest req, ServletResponse res )
	throws ServletException, IOException
    {
	//nothing
    }
}

