package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.caBIOApp.util.*;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import javax.swing.tree.*;

public class TreeEventHandler extends HttpServlet{

  private String _relativeSkinDir = null;
  private String _treeKeyName = null;
  private String _treeActionParamName = null;
  private String _nodeIdParamName = null;
  private String _treeDisplayJSPName = null;
  private String _treeBeanKeyName = null;
  private String _treeBeanClassname = null;

  public void init( ServletConfig config )
    throws ServletException
  {
    super.init( config );
    _relativeSkinDir = getInitParameter( "relativeSkinDir" );
    _treeKeyName = getInitParameter( "treeKeyName" );
    _treeActionParamName = getInitParameter( "treeActionParamName" );
    _nodeIdParamName = getInitParameter( "nodeIdParamName" );
    _treeDisplayJSPName = getInitParameter( "treeDisplayJSPName" );
    _treeBeanKeyName = getInitParameter( "treeBeanKeyName" );
    _treeBeanClassname = getInitParameter( "treeBeanClassname" );
    if( _treeBeanClassname == null ){
      _treeBeanClassname = "gov.nih.nci.caBIOApp.ui.tree.TreeBean";
    }
  }

  public void doGet( HttpServletRequest request, HttpServletResponse response )
    throws ServletException, IOException
  {
    HttpSession session = request.getSession();
    TreeBean bean = (TreeBean)session.getAttribute( _treeBeanKeyName );
    DefaultMutableTreeNode tree =
      (DefaultMutableTreeNode)session.getAttribute( _treeKeyName );
    if( tree != null ){
      //then we are dealing with a new tree
      
      session.removeAttribute( _treeKeyName );

      //check if we have a tree bean already
      if( bean == null ){
	try{
	  bean = (TreeBean)Class.forName( _treeBeanClassname ).newInstance();
	}catch( Exception ex ){
	  throw new ServletException( "Error instatiating tree bean", ex );
	}
	initializeBean( bean, request );
	session.setAttribute( _treeBeanKeyName, bean );
      }
      bean.setTree( tree );
      
    }else{
      //then we are dealing with the same tree
      
      if( bean == null ){
	throw new ServletException( "Couldn't find bean under: " + _treeBeanKeyName );
      }
      String actionName = request.getParameter( _treeActionParamName );
      String nodeId = request.getParameter( _nodeIdParamName );

      try{
	bean.updateTree( actionName, nodeId );
      }catch( Exception ex ){
	MessageLog.printStackTrace( ex );
	throw new ServletException( "Error updating tree.", ex );
      }
    }

    forward( request, response );
  }
  
  private void initializeBean( TreeBean bean, HttpServletRequest request ){
    bean.setSkin( _relativeSkinDir );
    bean.setServletURL( request.getContextPath() + request.getServletPath() );
    bean.setTreeActionParamName( _treeActionParamName );
    bean.setNodeIdParamName( _nodeIdParamName );
  }

  public void doPost( HttpServletRequest request, HttpServletResponse response )
    throws ServletException, IOException
  {
    doGet( request, response );
  }

  private void forward( HttpServletRequest request, HttpServletResponse response )
    throws ServletException, IOException
  {
    RequestDispatcher dispatcher = 
      getServletContext().getRequestDispatcher( _treeDisplayJSPName );
    if( dispatcher == null ){
      throw new ServletException( "Couldn't get dispatcher for: " + _treeDisplayJSPName );
    }
    dispatcher.forward( request, response );
  }

}

