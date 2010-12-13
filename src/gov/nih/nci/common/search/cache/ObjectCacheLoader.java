package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.*;

public class ObjectCacheLoader
  extends Thread
{
  protected SearchCriteria _sc = null;
  protected int _sleepTime = 60000;
  public ObjectCacheLoader( SearchCriteria sc ){
    _sc = sc;
  }
  public ObjectCacheLoader( SearchCriteria sc, int sleepTime ){
    _sc = sc;
    _sleepTime = sleepTime;
  }
  public void run(){
    try{
      SearchResult sr = _sc.search();
      ObjectCache oc = ObjectCacheFactory.defaultObjectCache();
      oc.put( _sc, sr );
      oc.save();
      Thread.sleep( _sleepTime );
    }catch( Exception ex ){
      ex.printStackTrace();
      throw new RuntimeException( "Error loading cache: " + 
				  ex.getMessage() );
    }
  }
}
