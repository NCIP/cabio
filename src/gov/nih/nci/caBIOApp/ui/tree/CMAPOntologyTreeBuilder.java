package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.ncicb.webtree.*;
import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.ui.tree.*;
import gov.nih.nci.caBIO.bean.Ontologable;
import gov.nih.nci.caBIO.bean.Relationable;
import gov.nih.nci.common.search.*;
import gov.nih.nci.common.domain.*;
import gov.nih.nci.caBIO.bean.CMAPOntology;
import gov.nih.nci.caBIO.bean.CMAPOntologyRelationship;

import javax.swing.tree.*;
import java.io.*;
import java.util.*;

public class CMAPOntologyTreeBuilder
  extends DefaultOntologyTreeBuilder
  implements TreeBuilder
{

  public CMAPOntologyTreeBuilder(){
    super();
  }
  public DefaultMutableTreeNode buildTree( String ontName, String rootTerm )
    throws Exception
  {
    DefaultMutableTreeNode treeRoot = new DefaultMutableTreeNode();
    MessageLog.printInfo( "OntologyTree.initTree(): caching tree for " + ontName );
    SearchCriteria sc = CaBIOUtils.newSearchCriteria( ontName );
    sc.putCriterion( "name", Criterion.EQUAL_TO, rootTerm );
    Object[] results = sc.search().getResultSet();
    if( results.length == 1 ){
      CMAPOntology root = (CMAPOntology)results[0];
      CMAPOntologyRelationship[] rels = (CMAPOntologyRelationship[])root.getChildRelationships();
      CMAPOntology rootObj = rels[0].getChild();
      String id = CaBIOUtils.getProperty( rootObj, "id" ).toString();
      String name = rootTerm;
      treeRoot.setUserObject( new WebNode( id, name, 
					   "javascript:" + _eventHandler + "('" +
					   id + "', '" + name + "')" ) );
      buildTree( treeRoot, rootObj );
    }else if( results.length > 1 ){
      throw new Exception( "Found more that one root for root term: " + rootTerm );
    }else{
      throw new Exception( "Found not root for root term: " + rootTerm );
    }
    return treeRoot;
  }
}
