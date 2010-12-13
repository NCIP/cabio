package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.ncicb.webtree.*;
import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.ui.tree.*;
import gov.nih.nci.caBIO.bean.Ontologable;
import gov.nih.nci.caBIO.bean.Relationable;
import gov.nih.nci.common.search.*;
import gov.nih.nci.common.domain.*;

import javax.swing.tree.*;
import java.io.*;
import java.util.*;

public class EVSOntologyTreeBuilder
  extends DefaultOntologyTreeBuilder
  implements TreeBuilder
{

  public EVSOntologyTreeBuilder(){
    super();
  }
  public DefaultMutableTreeNode buildTree( String ontName, String rootTerm )
    throws Exception
  {
    String term1 = rootTerm.substring( 0, rootTerm.indexOf( "," ) );
    String term2 = rootTerm.substring( rootTerm.indexOf( "," ) + 1 );
    List terms = new ArrayList();
    terms.add( term1 );
    terms.add( term2 );
    DefaultMutableTreeNode treeRoot = new DefaultMutableTreeNode();
    MessageLog.printInfo( "EVSOntologyTreeBuilder.initTree(): caching tree for " + ontName );
    SearchCriteria sc = CaBIOUtils.newSearchCriteria( ontName );
    sc.putCriterion( "name", Criterion.EQUAL_TO, terms );
    Object[] results = sc.search().getResultSet();
    if( results.length == 2 ){
      treeRoot.setUserObject( new WebNode( "EVS Ontology", "EVS Ontology", 
					   "javascript:blur()" ) );
      for( int i = 0; i < 2; i++ ){
	DefaultMutableTreeNode rootNode = new DefaultMutableTreeNode();
	Object rootObj = results[i];
	String id = (String)CaBIOUtils.getProperty( rootObj, "id" );
	String name = (String)CaBIOUtils.getProperty( rootObj, "name" );
	rootNode.setUserObject( new WebNode( id, name, 
					     "javascript:" + _eventHandler + "('" +
					     id + "', '" + name + "')" ) );
	buildTree( rootNode, rootObj );
	treeRoot.add( rootNode );
      }
    }else{
      throw new Exception( "Found " + results.length + "nodes for EVS terms: " + rootTerm );
    }
    return treeRoot;
  }
}
