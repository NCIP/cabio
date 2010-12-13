package gov.nih.nci.caBIOApp.ui.pager;

import gov.nih.nci.common.search.*;
import gov.nih.nci.common.search.cache.*;
import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.sod.*;

import java.util.*;
import java.lang.reflect.*;

public class CaBIOPagerDataSource implements PagerDataSource{

  protected static ObjectCache _cache = null;
  protected SearchableObject _searchableObject = null;
  protected Object _bean = null;
  protected SearchCriteria _criteria = null;
  protected SearchResult _searchResult;
  protected String[] _headers = null;
  protected int _itemCount = -1;
  protected boolean _initialized = false;
  protected String _eventHandler = null;
  

  public CaBIOPagerDataSource( SearchCriteria sc ){
    init( sc.getBeanClassName(), sc );
  }

  public CaBIOPagerDataSource( String classname, SearchCriteria criteria ){
    init( classname, criteria );
  }
  

  public CaBIOPagerDataSource( String classname, SearchCriteria criteria, String eventHandler ){
    _eventHandler = eventHandler;
    init( classname, criteria );
  }

  public CaBIOPagerDataSource( String classname, String beanId, String roleName, String eventHandler ){
    _eventHandler = eventHandler;
    SODUtils sod = SODUtils.getInstance();
    _searchableObject = sod.getSearchableObject( classname );
    if( _searchableObject == null ){
      throw new MissingResourceException( "Cannot find SearchableObject", classname, classname );
    }

    Association assoc = sod.getAssociationWithRole( _searchableObject, roleName );
    if( assoc == null ){
      throw new RuntimeException( "Couldn't find association with roleNam " + roleName +
				  " on " + classname );
    }
    try{
      SearchCriteria thisCrit = CaBIOUtils.newSearchCriteria( classname );
      if( beanId != null ){ 
	Object idObj = CaBIOUtils.convert( classname, "id", beanId );
	thisCrit.putCriteria( "id", idObj ); 
      }
      SearchCriteria assocCrit = CaBIOUtils.newSearchCriteria( assoc.getClassname() );
      String recipRole = CaBIOUtils.getReciprocalRole( thisCrit.getBeanName() + "." + roleName );
      assocCrit.putCriteria( recipRole, thisCrit );
      init( assoc.getClassname(), assocCrit );
    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new RuntimeException( "Error initializing datasource: " + ex.getMessage() );
    }
  }

  private void init( String classname, SearchCriteria criteria ){
    if( _cache == null ){
      _cache = ObjectCacheFactory.defaultObjectCache();
    }
    SODUtils sod = SODUtils.getInstance();
    _searchableObject = sod.getSearchableObject( classname );
    if( _searchableObject == null ){
      throw new MissingResourceException( "Cannot find SearchableObject", classname, classname );
    }
    try{
      _bean = Class.forName( classname ).newInstance();
      if( criteria == null ){
	_criteria = CaBIOUtils.newSearchCriteria( classname );
      }else{
	_criteria = criteria;
      }
    }catch( Exception ex ){
      ex.printStackTrace();
      if( ex instanceof ClassNotFoundException || 
	  ex instanceof InstantiationException ||
	  ex instanceof IllegalAccessException ){
	throw new RuntimeException( "Could not instantiate: " + ex.getMessage() );
      }else{
	throw new RuntimeException( "Error setting up bean: " + ex.getMessage() );
      }
    }
    MessageLog.printInfo( "CaBIOPagerDataSource.init(): _criteria is " + _criteria.getClass().getName() );

    List labelProps = _searchableObject.getLabelProperties();
    List assocs = getNavigableAssociations( _searchableObject.getAssociations() );
    _headers = new String[labelProps.size() + assocs.size()];
    int i = 0;
    for( Iterator it = labelProps.iterator(); it.hasNext(); i++ ){
      String propName = (String)it.next();
      Attribute att = sod.getAttribute( _searchableObject, propName );
      if( att == null ){
	throw new RuntimeException( "CaBIOPagerDataSource.init(): couldn't find attribute " + propName +
				    " on " + _searchableObject.getClassname() );
      }
      _headers[i] = att.getLabel();
    }
    for( Iterator it = assocs.iterator(); it.hasNext(); i++ ){
      Association assoc = (Association)it.next();
      _headers[i] = assoc.getLabel();
    }
  }

  public int getItemCount()
    throws Exception
  {
    if( !_initialized ){
      initializeItems();
    }
    return _itemCount;
  }

  public PagerItem[] getItems( int startIdx, int numItems )
    throws Exception
  {
    PagerItem[] items = null;
    _criteria.setStartAt( new Integer( startIdx ) );
    _criteria.setMaxRecordset( new Integer( numItems + 1 ) );
    SearchResult sr = _cache.get( _criteria );
    if( sr == null ){
      System.err.println( "GET ITEMS: NO OBJECTS FOUND, SEARCHING" );
      _searchResult = _criteria.search();
      _cache.put( _criteria, _searchResult );
    }else{
      _searchResult = sr;
    }
    if( _searchResult == null ){
      items = new PagerItem[0];
    }else{ //_searchResult is not null
      Object[] objects = _searchResult.getResultSet();
      if( objects == null || objects.length < numItems ){
	MessageLog.printError( "The result set length is less than number of items requested." );
	//throw new Exception( "The result set length is less than number of items requested." );
      }
      //MessageLog.printInfo( "### NUM ITEMS = " + numItems );
      items = new PagerItem[numItems];
      for( int i = 0; i < numItems; i++ ){
	if( objects[i] == null ){
	  throw new Exception( "objects[" + i + "] is null" );
	}
	//MessageLog.printInfo( "***** on object " + objects[i].getClass().getName() );
	Method m = null;
	String id = null;
	try{
	  m = objects[i].getClass().getMethod( "getId", new Class[0] );
	  id = m.invoke( objects[i], new Object[0] ).toString();
	}catch( Exception ex ){
	  throw new Exception( "Error calling 'getId' on " + 
			       objects[i].getClass().getName() + ": " + ex.getMessage() );
	}
	List labelProps = _searchableObject.getLabelProperties();
	List assocs = getNavigableAssociations( _searchableObject.getAssociations() );
	String[] vals = new String[labelProps.size() + assocs.size()];
	int j = 0;
	for( Iterator it = labelProps.iterator(); it.hasNext(); j++ ){
	  String propName = ((String)it.next()).trim();
	  //MessageLog.printInfo( "*** property '" + propName + "'" );
	  String methodName = 
	    "get" + propName.substring( 0, 1 ).toUpperCase() + 
	    propName.substring( 1 );
	  //MessageLog.printInfo( "*** method '" + methodName + "'" );
	  try{
	    m = objects[i].getClass().getMethod( methodName, new Class[0] );
	  }catch( Exception ex ){
	    try{
	      if( propName.indexOf( "is" ) != -1 ){
		methodName = propName;
	      }else{
	      methodName = "get" +
		propName.substring( 0, 1 ).toUpperCase() + 
		propName.substring( 1 );
	      }
	      m = objects[i].getClass().getMethod( methodName, new Class[0] );
	    }catch( NoSuchMethodException ex1 ){
	      throw new Exception( "Could not find method '" + methodName +
				   "' on " + objects[i].getClass().getName() + ": " +
				   ex.getMessage() );
	    }catch( SecurityException ex2 ){
	      throw new Exception( "No access to method '" + methodName +
				   "' on " + objects[i].getClass().getName() + ": " +
				   ex.getMessage() );
	    }
	  }
	  try{
	    Object val = m.invoke( objects[i], new Object[0] );
	    if( val != null ){
	      vals[j] = val.toString();
	    }else{
	      //MessageLog.printInfo( "****** val for " + propName + " is null." );
	    }
	  }catch( Exception ex ){
	    ex.printStackTrace();
	    throw new Exception( "Error invoking " + methodName + " on " +
				 objects[i].getClass().getName() + ": " + ex.getMessage() );
	  }
	}//-- end for( Iterator it...
	for( Iterator it = assocs.iterator(); it.hasNext(); j++ ){
	  Association assoc = (Association)it.next();
	  vals[j] = 
	    "<a href=\"javascript:" + _eventHandler + "('" + objects[i].getClass().getName() +
	    "', '" + id + "', '" + assoc.getRole() + "')\">" + assoc.getLabel() + 
	    getCountString( objects[i], assoc.getRole() ) + "</a>";
	}
	
	//MessageLog.printInfo( "***** About to set pager item with id " + id + " in items[" + i + "]" );
	items[i] = new PagerItemImpl( id, vals );
	
      }//-- end for( int i...
    }//-- end _searchResult is not null
    return items;
  }

  public String[] getHeaders(){
    return _headers;
  }

  private void initializeItems()
    throws Exception
  {
    _criteria.setReturnCount( new Boolean( true ) );
    SearchResult sr = _cache.get( _criteria );
    if( sr == null ){
      System.err.println( "INITIALIZE ITEMS: NO OBJECTS FOUND, SEARCHING" );
      _searchResult = _criteria.search();
      _cache.put( _criteria, _searchResult );
    }else{
      _searchResult = sr;
    }
    if( _searchResult == null ){
      MessageLog.printInfo( "CaBIOPagerDataSource.initializeItems(): _searchResult is null." );
    }else{
      _itemCount = _searchResult.getCount().intValue();
    }
    if( _itemCount < 0 ){
      _itemCount = 0;
      MessageLog.printInfo( "CaBIOPagerDataSource.initializeItems(): _itemCount = " + _itemCount );
    }
    _initialized = true;
  }

  private String getCountString( Object bean, String propName ){
    String countStr = "";
    /*
    Method[] methods = bean.getClass().getMethods();
    for( int i = 0; i < methods.length; i++ ){
      String name = methods[i].getName();
      if( name.toLowerCase().indexOf( propName.toLowerCase() ) != -1 && 
	  name.toLowerCase().indexOf( "count" ) != -1 ){
	try{
	  Integer count = (Integer)methods[i].invoke( bean, new Object[0] );
	  countStr = "[" + count + "]";
	  break;
	}catch( Exception ex ){
	  MessageLog.printStackTrace( ex );
	}
      }
    }
    */
    return countStr;
  }
  
  private List getNavigableAssociations( List assocs ){
    List results = new ArrayList();
    if( _eventHandler != null ){
     assocs = _searchableObject.getAssociations();
     for( Iterator i = assocs.iterator(); i.hasNext(); ){
       Association a = (Association)i.next();
       if( a.getNavigable() ){
	 results.add( a );
       }
     }
    }    
    return results;
  }
}

