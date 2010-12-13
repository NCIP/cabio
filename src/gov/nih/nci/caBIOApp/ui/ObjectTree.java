package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.sod.*;
import gov.nih.nci.caBIOApp.ui.tree.*;

import javax.swing.tree.*;
import java.util.*;
import java.io.*;

public class ObjectTree extends DefaultMutableTreeNode{

  public static final int QUERY_MODE = 0;
  public static final int DISPLAY_MODE = 1;

  protected int _mode = QUERY_MODE;
  protected String _ontNodeContent = null;
  protected String _ontNodeDesc = null;
  protected String _allNodeContent = null;
  protected String _allNodeDesc = null;
  protected String _eventHandlerName = null;
  protected int _maxLevels = 0;
  protected SODUtils _sod = null;
  protected String _objectName = null;
  /**
   * This is a hack:
   *
   * Need generic way to say that tree may contain loops. And also
   * need way to say how many times those loops may occur. To do
   * this, I'm using a properties file will the name of each object
   * for which loops are allowed and how many loops for each object.
   */
  protected HashMap _loopers = new HashMap();

  public ObjectTree( String objectName, String eventHandlerName, int maxLevels, int mode ){

    _eventHandlerName = eventHandlerName;
    _maxLevels = maxLevels;
    _objectName = objectName;
    if( mode != QUERY_MODE && mode != DISPLAY_MODE ){
      throw new RuntimeException( "invalid mode: " + mode );
    }
    _mode = mode;
    init();
  }

  public ObjectTree( String objectName, 
		     String eventHandlerName, int maxLevels ){
    _eventHandlerName = eventHandlerName;
    _maxLevels = maxLevels;
    _objectName = objectName;
    init();
    
  }
  private void init(){
    try{
      InputStream in = 
	this.getClass().getClassLoader()
	.getResourceAsStream( "ApplicationResources.properties" );
      if( in == null ){
	in = this.getClass().getClassLoader()
	  .getSystemResourceAsStream( "ApplicationResources.properties" );
      }
      Properties props = new Properties();
      props.load( in );
      _ontNodeContent = 
	props.getProperty( "gov.nih.nci.caBIOApp.ui.ObjectTree.ontologicalNode.label",
					   "Ontological Property" );
      _ontNodeDesc = 
	props.getProperty( "gov.nih.nci.caBIOApp.ui.ObjectTree.ontologicalNode.description",
					"Indicates that this object is part of an ontology." );
      _allNodeContent = 
	props.getProperty( "gov.nih.nci.caBIOApp.ui.ObjectTree.allNode.label",
					   "All" );
      _allNodeDesc = props.getProperty( "gov.nih.nci.caBIOApp.ui.ObjectTree.allNode.description",
					   "Select all instances of this." );

      //Fill up my _loopers map.
      /*
      String looperInfo = 
	props.getProperty( "gov.nih.nci.caBIOApp.ui.ObjectTree.loopers" );
      StringTokenizer loopers = new StringTokenizer( looperInfo, ";" );
      while( loopers.hasMoreTokens() ){
	String looper = loopers.nextToken();
	int idx = looper.indexOf( ":" );
	String looperName = looper.substring( 0, idx );
	Integer numLoops = new Integer( looper.substring( idx + 1 ) );
	_loopers.put( looperName, numLoops );
      }
      */
    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new RuntimeException( "Error initializing object tree: " + ex.getMessage() );
    }
    _sod = SODUtils.getInstance();
    //System.err.println( "Root: " + _objectName );
    SearchableObject so = _sod.getSearchableObject( _objectName );
    NodeContent objNC = new CaBIONodeContent( this );
    objNC.setId( _sod.getBeanName( _objectName ) );
    objNC.setContent( so.getLabel() );
    objNC.setDescription( so.getDescription() );
    this.setUserObject( objNC );
    addAttributes( this, so );
    addAssociations( this, so, 0 );

    //Expand the root
    objNC.setExpanded( true );
  }

  public void buildTree( DefaultMutableTreeNode parentNode,
			 String role,
			 int currLevel ){
//     System.err.println( "buildTree: " + ((NodeContent)parentNode.getUserObject()).getId() +
// 			", " + role +
// 			", level " + currLevel );    
    //Find the SO for this role
    Association assoc = getAssociation( parentNode, role );
    SearchableObject so = getSearchableObject( parentNode, role );

    //Create this node and attach to parent
    DefaultMutableTreeNode childNode = new DefaultMutableTreeNode();
    NodeContent objNC = new CaBIONodeContent( this );
    objNC.setId( ((NodeContent)parentNode.getUserObject()).getId() + 
		   getExtraPath( parentNode, role ) + 
		 "." + role );
    objNC.setContent( assoc.getLabel() );
    objNC.setDescription( assoc.getDescription() );
    childNode.setUserObject( objNC );
    parentNode.add( childNode );

    //Create attribute nodes
    addAttributes( childNode, so );

    //Base Condition: currLevel >= _maxLevels
    if( currLevel < _maxLevels ){
      //Create association nodes      
      addAssociations( childNode, so, currLevel );
    }
  }
  protected void addAttributes( DefaultMutableTreeNode currNode,
				SearchableObject so ){
    NodeContent objNC = (NodeContent)currNode.getUserObject();
    List atts = getAttributes( so );
    for( Iterator i = atts.iterator(); i.hasNext(); ){
      Attribute att = (Attribute)i.next();
      NodeContent attNC = new CaBIONodeContent( this );
      attNC.setId( objNC.getId() + "." + att.getName() );
      attNC.setContent( att.getLabel() );
      attNC.setLink( "javascript:" + _eventHandlerName + "('" + attNC.getId() + "')" );
      attNC.setDescription( att.getDescription() );
      currNode.add( new DefaultMutableTreeNode( attNC ) );
    }
    //If in query mode and this is an Ontologable, the add ont node
    if( so.getOntological() && _mode == QUERY_MODE ){
      NodeContent attNC = new CaBIONodeContent( this );
      attNC.setId( objNC.getId() + ".ontological" );
      attNC.setContent( _ontNodeContent );
      attNC.setLink( "javascript:" + _eventHandlerName + "('" + attNC.getId() + "')" );
      attNC.setDescription( _ontNodeDesc );
      currNode.add( new DefaultMutableTreeNode( attNC ) );
    }
  }
  protected void addAssociations( DefaultMutableTreeNode currNode,
				  SearchableObject so,
				  int currLevel ){
    String path = ((NodeContent)currNode.getUserObject()).getId();
    for( Iterator i = so.getAssociations().iterator(); i.hasNext(); ){
      Association assoc = (Association)i.next();
      String role = assoc.getRole();
      if( showAssociation( path, so, role ) ){
	buildTree( currNode, role, currLevel + 1 );
      }
    }
  }
  protected String getExtraPath( DefaultMutableTreeNode parentNode,
				 String role ){
    StringBuffer sb = new StringBuffer();
    
    String id = ((NodeContent)parentNode.getUserObject()).getId();
    String beanName = _sod.getBeanNameFromPath( id );
    SearchableObject so = 
      _sod.getSearchableObject( beanName );
    if( so == null ){
      throw new RuntimeException( "Couldn't find SearchableObject for beanName " + beanName );
    }

    //Find the Association
    Association theAssoc = _sod.getAssociationWithRole( so, role );
    if( theAssoc == null ){
      throw new RuntimeException( "Couldn't find Association for " +
				  so.getClassname() + "." + role );
    }
    //Sort the path items
    List pathItemsLst = theAssoc.getPathItems();
    PathItem[] pathItemsA = new PathItem[pathItemsLst.size()];
    for( Iterator i = pathItemsLst.iterator(); i.hasNext(); ){
      PathItem item = (PathItem)i.next();
      pathItemsA[item.getOrder()] = item;
    }
    //Create the path
    if( pathItemsA.length > 0 ){
      SearchableObject nextSO = so;
      for( int i = 0; i < pathItemsA.length; i++ ){
	Association nextAssoc = 
	  _sod.getAssociation( nextSO, pathItemsA[i].getClassname() );
	if( nextAssoc == null ){
	  throw new RuntimeException( "Couldn't find Association from " +
				      nextSO.getClassname() + " to " +
				      pathItemsA[i].getClassname() );
	}
	sb.append( "." + nextAssoc.getRole() );
	nextSO = _sod.getSearchableObject( nextAssoc.getClassname() );
	if( nextSO == null ){
	  throw new RuntimeException( "Couldn't find SearchableObject for " +
				      nextAssoc.getClassname() );
	}
      }
    }

    return sb.toString();
  }
  protected List getAttributes( SearchableObject so ){
    List atts = null;
    if( _mode == DISPLAY_MODE ){
      atts = _sod.getDisplayableAttributes( so );
    }else{
      atts = _sod.getQueryableAttributes( so );
    }
    return atts;
  }
  protected boolean showAssociation( String path,
				     SearchableObject parentSO,
				     String role ){
    boolean show = false;
    Association assoc = _sod.getAssociationWithRole( parentSO, role );
    SearchableObject assocSO = 
      _sod.getSearchableObject( assoc.getClassname() );
    if( _mode == QUERY_MODE ){
      show =
	(numTimesInPathToRoot( path, assocSO, role ) < 1);
    }else{
      int numPermissableLoops = 0;
      Integer npl = (Integer)_loopers.get( assocSO.getClassname() );
      if( npl != null ){
	numPermissableLoops = npl.intValue();
      }
      show =
	(numTimesInPathToRoot( path, assocSO, role ) <= numPermissableLoops);
    }    
    return show;
  }
  protected int numTimesInPathToRoot( String path,
				      SearchableObject so,
				      String role ){
    int num = 0;
    StringTokenizer st = new StringTokenizer( path, "." );
    SearchableObject root = _sod.getSearchableObject( st.nextToken() );
    if( st.hasMoreTokens() ){
      Association nextAssoc = _sod.getAssociationWithRole( root, st.nextToken() );
      if( so.getClassname().equals( nextAssoc.getClassname() ) &&
	  nextAssoc.getRole().equals( role ) ||
	  nextAssoc.getClassname().equals( root.getClassname() ) ){
	num++;
      }
      while( st.hasMoreTokens() ){
	nextAssoc = _sod.getAssociationWithRole( nextAssoc.getClassname(), 
						 st.nextToken() );
	if( so.getClassname().equals( nextAssoc.getClassname() ) ||
	  nextAssoc.getClassname().equals( root.getClassname() ) ){
	  num++;
	}
      }
    }
    return num;
  }
  protected Association getAssociation( DefaultMutableTreeNode node, String role ){
    String id = ((NodeContent)node.getUserObject()).getId();
    return _sod.getAssociationWithRole( _sod.getBeanNameFromPath( id ), role );
  }
  protected SearchableObject getSearchableObject( DefaultMutableTreeNode node,
						  String role ){
    Association assoc = getAssociation( node, role );
    return _sod.getSearchableObject( assoc.getClassname() );
  }

  public void expanded( NodeContent nc ){
    String path = nc.getId();
    DefaultMutableTreeNode node = findNode( this, path );
    if( !nc.isExpanded() ){
      String role = path.substring( path.lastIndexOf( "." ) + 1 );
      buildTree( node, role, 0 );
    }
  }
  
  private DefaultMutableTreeNode findNode( DefaultMutableTreeNode root, String id ){
    DefaultMutableTreeNode result = null;
    for( Enumeration e = root.preorderEnumeration(); e.hasMoreElements(); ){
      DefaultMutableTreeNode n = (DefaultMutableTreeNode)e.nextElement();
      NodeContent nc = (NodeContent)n.getUserObject();
      if( nc != null && nc.getId().equals( id ) ){
	result = n;
	break;
      }
    }
    return result;
  }
}

