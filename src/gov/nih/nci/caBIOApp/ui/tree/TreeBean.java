package gov.nih.nci.caBIOApp.ui.tree;

import javax.swing.tree.*;
import java.util.*;

public class TreeBean{

  protected String _skin = null;
  protected DefaultMutableTreeNode _tree = null;
  protected String _servletURL = null;
  protected String _treeActionParamName = null;
  protected String _nodeIdParamName = null;

  public void setTree( DefaultMutableTreeNode t ){
    _tree = t;
  }
  public DefaultMutableTreeNode getTree(){
    return _tree;
  }

  public void setSkin( String s ){
    _skin = s;
  }
  public String getSkin(){
    return _skin;
  }

  public void setServletURL( String s ){
    _servletURL = s;
  }
  public String getServletURL(){
    return _servletURL;
  }

  public void setTreeActionParamName( String s ){
    _treeActionParamName = s;
  }
  public String getTreeActionParamName(){
    return _treeActionParamName;
  }

  public void setNodeIdParamName( String s ){
    _nodeIdParamName = s;
  }
  public String getNodeIdParamName(){
    return _nodeIdParamName;
  }

  public String getEventHandlerURL( String actionName, String nodeId ){
    String handlerURL =
      _servletURL + "?" + _treeActionParamName + "=" + actionName +
      "&" + _nodeIdParamName + "=" + nodeId;
      
      return handlerURL;
  }

  public void updateTree( String actionName, String nodeId )
    throws TreeException
  {

    NodeContent theContent = null;

    Enumeration nodes = _tree.preorderEnumeration();
    while( nodes.hasMoreElements() ){
      
      DefaultMutableTreeNode node =
	(DefaultMutableTreeNode)nodes.nextElement();
      NodeContent aContent = (NodeContent)node.getUserObject();
      
      if( aContent.getId().equals( nodeId ) ){
	theContent = aContent;
	break;
      }
    }
    /*
    if( theContent == null ){
      throw new TreeException( "Couldn't find NodeContent with id: " + nodeId );
    }
    */
    if( theContent != null ){
      if( "expand".equals( actionName ) ){
	theContent.setExpanded( true );
      }else{
	theContent.setExpanded( false );
      }
      
      DefaultMutableTreeNode activeNode = getActiveNode();
      if( activeNode != null ){
	NodeContent actCont = (NodeContent)activeNode.getUserObject();
	actCont.setActive( false );
      }
      theContent.setActive( true );
    }else{
      System.err.println( "Couldn't find NodeContent with id: " + nodeId );
    }
  }

  public boolean showNode( DefaultMutableTreeNode node ){
    return findCollapsedParent( node ) == null;
  }

  private DefaultMutableTreeNode findCollapsedParent( DefaultMutableTreeNode node ){
    DefaultMutableTreeNode collapsedParent = null;
    DefaultMutableTreeNode parent =
      (DefaultMutableTreeNode)node.getParent();
    if( parent != null ){
      if( ((NodeContent)parent.getUserObject()).isExpanded() ){
	collapsedParent = findCollapsedParent( parent );
      }else{
	collapsedParent = parent;
      }
    }
    return collapsedParent;
  }

  protected DefaultMutableTreeNode getActiveNode(){
    DefaultMutableTreeNode theNode = null;
    Enumeration nodes = _tree.preorderEnumeration();
    while( nodes.hasMoreElements() ){
      DefaultMutableTreeNode aNode = (DefaultMutableTreeNode)nodes.nextElement();
      if( ((NodeContent)aNode.getUserObject()).isActive() ){
	theNode = aNode;
	break;
      }
    }
    return theNode;
  }
}

