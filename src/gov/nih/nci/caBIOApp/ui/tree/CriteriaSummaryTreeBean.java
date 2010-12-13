package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.sod.*;
import gov.nih.nci.caBIOApp.util.*;

import javax.swing.tree.*;
import java.util.*;

public class CriteriaSummaryTreeBean extends TreeBean{

  public DefaultMutableTreeNode getTree(){
    MessageLog.printInfo( "CriteriaSummaryTreeBean.getTree()" );
    DefaultMutableTreeNode displayNode = new DefaultMutableTreeNode( _tree.getUserObject() );
    buildTree( displayNode, _tree );
    return displayNode;
  }

  public void buildTree( DefaultMutableTreeNode displayNode, DefaultMutableTreeNode parent ){

    /**
     * Base condition: when parentSC has no child object nodes.
     */

    SearchCriteriaNode parentSC = (SearchCriteriaNode)parent;
    
    //Iterate through the property nodes
    for( Iterator i = parentSC.getPropertyNodes().iterator(); i.hasNext(); ){
      SearchCriteriaNode aChild = (SearchCriteriaNode)i.next();
      DefaultMutableTreeNode newNode = new DefaultMutableTreeNode( aChild.getUserObject() );
      displayNode.add( newNode );
      //Do not recurse
    }
    //Iterate through the object nodes
    for( Iterator i = parentSC.getObjectNodes().iterator(); i.hasNext(); ){
      SearchCriteriaNode aChild = (SearchCriteriaNode)i.next();

      if( aChild.isPathItem() ){
	/*
	MessageLog.printInfo( "CriteriaSummaryTreeBean.buildTree(): " + 
			      aChild.getObjectName() +
			      " is a path item." );
	*/
	buildTree( displayNode, aChild );

      }else{
	if( ((SearchCriteriaNode)parent).isPathItem() && !aChild.isPathItem() ){

	  //PathItems are no longer supported
	  throw new RuntimeException( "PathItem objects are no longer supported." );

	  /**
	   * If the parent is a PathItem and aChild is not a PathItem, then
	   * aChild is an object node, because PathItems will not have any
	   * child property nodes.
	   */
	  /*
	  SODUtils sod = SODUtils.getInstance();
	  String childId = ((CriterionValue)aChild.getUserObject()).getId();
	  //String parentId = ((CriterionValue)parent.getUserObject()).getId();
	  SearchCriteriaNode beginPoint = ((SearchCriteriaNode)parent).getPathBeginPointNode();
	  String parentId = ((CriterionValue)beginPoint.getUserObject()).getId();
	  String diff = childId.substring( parentId.length() + 1 );
	  //MessageLog.printInfo( "CriteriaSummaryTreeBean.buildTree(): diff = " + diff );
	  List path = new ArrayList();
	  if( diff.indexOf( "." ) == -1 ){
	    path.add( _packageName + "." + diff );
	  }else{
	    StringTokenizer st = new StringTokenizer( diff, "." );
	    while( st.hasMoreTokens() ){
	      path.add( _packageName + "." + st.nextToken() );
	    }
	  }
	  SearchableObject so = ((CriterionValue)beginPoint.getUserObject()).getSearchableObject();
	  Association a = sod.getAssociationWithPath( so, path );
	  if( a == null ){
	    throw new RuntimeException( "couldn't find associations for path: " + 
					so.getClassname() + " -> " + diff );
	  }
	  ((CriterionValue)aChild.getUserObject()).setContent( a.getLabel() );
	  */
	}
      
	DefaultMutableTreeNode newNode = new DefaultMutableTreeNode( aChild.getUserObject() );
	displayNode.add( newNode );
	//Recurse
	buildTree( newNode, aChild );
      }//--end else aChild is not a PathItems
    }//--end iteration through child object nodes
  }//--end buildTree

}

