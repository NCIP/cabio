package gov.nih.nci.caBIOApp.util;

import gov.nih.nci.common.search.*;
import gov.nih.nci.common.util.*;
import gov.nih.nci.caBIOApp.sod.*;

import java.lang.reflect.*;

public class CaBIOUtils{

  public static gov.nih.nci.caBIO.bean.Ontologable getOntologyRoot( String classname )
    throws Exception
  {
    gov.nih.nci.caBIO.bean.Ontologable root = null;
    /*
    int numIts = 1000; //looping to deal with GoOntology bug
    OntologySearchCriteria sc = 
      (OntologySearchCriteria)Class.forName( classname + "SearchCriteria" ).newInstance();
    sc.setMaxRecordset( new Integer( numIts ) );
    Ontologable ont =
      (Ontologable)Class.forName( classname ).newInstance();
    Ontologable[] results = ont.searchOntologys( sc );
    if( results == null || results.length == 0 ){
      throw new Exception( "No instances of " + classname + " found." );
    }
    numIts = results.length;
    int i = 0;
    do{
      root = findOntologyRoot( results[i] );
      i++;
    }while( root == null && i < numIts );
    */
    return root;
  }
  /*
  public static Ontologable findOntologyRoot( Ontologable bean )
    throws Exception
  {
    Ontologable root = null;
    String classname = bean.getClass().getName();
    RelationshipSearchCriteria rsc = 
      (RelationshipSearchCriteria)Class.forName( classname + 
						 "RelationshipSearchCriteria" ).newInstance();
    rsc.setRelationshipChildId( bean.getId() );
    Relationable rel = 
      (Relationable)Class.forName( classname + 
				   "Relationship" ).newInstance();
    Relationable[] rels = rel.searchRelationships( rsc );
    if( rels != null && rels.length > 0 ){

      if( rels.length > 1 ){
	throw new Exception( classname + ":" + bean.getId() + " has more than one parent." );
      }

      Ontologable[] onts = rels[0].getOntologies();
      if( onts == null || onts.length == 0 ){
	MessageLog.printInfo( "QueryDesign.findOntologyRoot(): " + classname + 
			      ":" + bean.getId() + " has no parent." );
	root = bean;
	//throw new Exception( "No ontologies found for " + classname + ":" + bean.getId() );
      }else if( onts.length > 1 ){
	throw new Exception( "More than on Ontologable found for " + classname + ":" + bean.getId() );
      }else{
	if( bean.getId().equals( onts[0].getId() ) ){
	  //this is an error situation
	  MessageLog.printError( "CaBIOUtils.findOntologyRoot(): bean.getId() == onts[0].getId() " +
				 "for " + classname + ":" + bean.getId() );
	  root = null;
	}else{
	  root = findOntologyRoot( onts[0] );
	}
      }
    }else{
      throw new Exception( "No relationships found for " + classname + ":" + bean.getId() );
    }

    return root;
  }
*/
  public static SearchCriteria newSearchCriteria( String beanName )
    throws Exception
  {
    if( beanName == null ){
      throw new Exception( "Given object name is null" );
    }
    //Make sure it's a bean name, not a classname.
    beanName = beanName.substring( beanName.lastIndexOf( "." ) + 1 );
    return (SearchCriteria)Class
      .forName( COREUtilities.getSCClassName( beanName ) )
      .newInstance();
  }
  public static String getReciprocalRole( String beanNameDotRole ){
    return COREUtilities.getReciprocalRole( beanNameDotRole );
  }
  public static Object convert( String beanName, String attName, Object value )
    throws Exception
  {
    String beanClassName = beanName;
    if( beanName.indexOf( "." ) == -1 ){
      beanClassName = COREUtilities.getBeanClassName( beanName );
    }
    return COREUtilities.convert( beanClassName, attName, value );
  }

  public static Object getProperty( Object obj, String propName )
    throws Exception
  {
    String methodName = getMethodName( obj, propName );
    if( methodName == null ){
      throw new Exception( "No getter found on " + 
			   obj.getClass().getName() +
			   " for property " + propName );
    }
    return COREUtilities.invoke( obj, methodName, new Object[0] );
  }
  public static String getMethodName( Object obj, String propName )
    throws Exception
  {
    String methodName = 
      "get" + propName.substring( 0, 1 ).toUpperCase() + 
      propName.substring( 1 );
    Class klass = obj.getClass();
    Method m = COREUtilities.findMethod( klass, methodName );
    if( m == null ){
      if( propName.indexOf( "is" ) != -1 ){
	methodName = propName;
      }else{
	methodName = "get" +
	  propName.substring( 0, 1 ).toUpperCase() + 
	  propName.substring( 1 );
      }
      m = COREUtilities.findMethod( klass, methodName );
    }
    if( m == null ){
      methodName = null;
    }else{
      methodName = m.getName();
    }
    return methodName;
  }

  public static SearchCriteria reverseSearchCriteria( String beanName, String id, String roleName )
    throws Exception
  {
    if( beanName.endsWith( "Impl" ) ){
      beanName = beanName.substring( 0, beanName.indexOf( "Impl" ) );
    }
    int dotIdx = beanName.lastIndexOf( "." );
    if( dotIdx != -1 ){
      beanName = beanName.substring( dotIdx + 1 );
    }
    SODUtils sod = SODUtils.getInstance();
    SearchableObject so = sod.getSearchableObject( beanName );
    if( so == null ){
      throw new Exception( "Cannot find SearchableObject for " + beanName );
    }
    Association assoc = sod.getAssociationWithRole( so, roleName );
    if( assoc == null ){
      throw new Exception( "Couldn't find association with roleNam " + roleName +
			   " on " + beanName );
    }

    SearchCriteria thisCrit = CaBIOUtils.newSearchCriteria( beanName );
    if( id != null ){ 
      Object idObj = CaBIOUtils.convert( thisCrit.getBeanName(), "id", id );
      thisCrit.putCriteria( "id", idObj ); 
    }
    SearchCriteria assocCrit = CaBIOUtils.newSearchCriteria( assoc.getClassname() );

    String recipRole = CaBIOUtils.getReciprocalRole( beanName + "." + roleName );
    assocCrit.putCriteria( recipRole, thisCrit );
    return assocCrit;
  }
}

