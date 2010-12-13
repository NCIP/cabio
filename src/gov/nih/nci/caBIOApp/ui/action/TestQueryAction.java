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
import gov.nih.nci.caBIOApp.ui.pager.*;
import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIO.bean.*;
import gov.nih.nci.caBIO.util.CriteriaElement;

public class TestQueryAction extends Action{

  public ActionForward perform( ActionMapping mapping, 
				ActionForm f,
				HttpServletRequest request,
				HttpServletResponse response )
    throws IOException, ServletException
  {
    TestQueryForm form = (TestQueryForm)f;
    ActionForward forward = null;
    String beanName = null;
    SearchCriteria sc = null;
    BufferedReader br = new BufferedReader( new InputStreamReader( form.getUploadedFile().getInputStream() ) );
    String line = br.readLine(); 
    while( "".equals( line.trim() ) || line.indexOf( "#" ) != -1 ){
      line = br.readLine();
    }
    List joins = new ArrayList();
    if( "testQueryResolver".equals( form.getOperation() ) ){
      String joinsStr = line.substring( line.indexOf( "JOINS:" ) + 6 );
      StringTokenizer st = new StringTokenizer( joinsStr, "," );
      while( st.hasMoreTokens() ){
	String join = "gov.nih.nci.caBIO.bean." + st.nextToken();
	MessageLog.printInfo( "Join: " + join );
	joins.add( join );
      }
      line = br.readLine();
    }
    beanName = line.substring( line.indexOf( "OBJECT:" ) + 7  );
    MessageLog.printInfo( "Starting with " + beanName );
    try{
      sc = (SearchCriteria)Class.forName( "gov.nih.nci.caBIO.bean." + beanName + "SearchCriteria" ).newInstance();
      sc.setClassName( beanName );
      buildSearchCriteria( sc, br );      
    }catch( Exception ex ){
      throw new ServletException( "Error building search criteria.", ex );
    }
    PagerDataSource ds = null;
    try{
      if( "testQueryResolver".equals( form.getOperation() ) ){
	ds = new TestPagerDataSource( "gov.nih.nci.caBIO.bean." + beanName, sc, joins );
      }else{
	ds = new CaBIOPagerDataSource( "gov.nih.nci.caBIO.bean." + beanName, sc );
      }
    }catch( Exception ex ){
      throw new ServletException( "error running query", ex );
    }
    request.setAttribute( "gov.nih.nci.caBIOApp.ui.pager.dataSource", ds );    
    forward = mapping.findForward( "displayResults" );
    


    MessageLog.printInfo( mapping.getPath() + ": forwarding to - " + forward.getPath() );

    return forward;
    
  }

  private SearchCriteria buildSearchCriteria( SearchCriteria criteria, BufferedReader reader )
    throws Exception
  {
    String line = null;
    while( (line = reader.readLine()) != null ){
      if( "".equals( line.trim() ) || line.indexOf( "#" ) != -1 ){
	continue;
      }else if( line.indexOf( "ATT:" ) != -1 ){
	List vals = new ArrayList();
	String propName = line.substring( line.indexOf( "ATT:" ) + 4, line.indexOf( "=" ) );
	 MessageLog.printInfo( "propName = " + propName );
	 String valStr = line.substring( line.indexOf( propName ) + propName.length() + 1 );
	 MessageLog.printInfo( "valStr = "  + valStr );
	 if( valStr.indexOf( "," ) == -1 ){
	   vals.add( valStr );
	 }else{
	   StringTokenizer st = new StringTokenizer( valStr, "," );
	   while( st.hasMoreTokens() ){
	     vals.add( st.nextToken() );
	   }
	 }
	 criteria.putCriteria( propName, vals );
      }else if( line.indexOf( "OBJECT:" ) != -1 ){
	String beanName = line.substring( line.indexOf( "OBJECT:" ) + 7 );
	MessageLog.printInfo( "Creating " + beanName + "SearchCriteria" );
	SearchCriteria sc = (SearchCriteria)Class.forName( "gov.nih.nci.caBIO.bean." + beanName + "SearchCriteria" ).newInstance();
	sc.setClassName( beanName );
	criteria.putSearchCriteria( buildSearchCriteria( sc, reader ), CriteriaElement.AND );
      }else if( line.indexOf( "END" ) != -1 ){
	return criteria;
      }else{
	throw new Exception( "invalid line: " + line );
      }
    }
    return criteria;
  }

}
