package gov.nih.nci.common.search.cache;

public class ObjectCacheFactory{
  public static ObjectCache defaultObjectCache(){
    try{
      return new DefaultObjectCache();
    }catch( Exception ex ){
      ex.printStackTrace();
      throw new RuntimeException( "Error instantiating object cache:" +
				  ex.getMessage() );
    }
  }
}
