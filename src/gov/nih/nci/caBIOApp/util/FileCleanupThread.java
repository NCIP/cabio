package gov.nih.nci.caBIOApp.util;

import java.io.*;
import java.util.*;

public class FileCleanupThread implements Runnable{

  private static FileCleanupThread _instance = null;
  private static int _maxFileAge = 24; //in hours
  private static Thread _runner = null;
  private static List _files = Collections.synchronizedList(new ArrayList());

  private long ONE_HOUR = 3600000; //in milliseconds

  private FileCleanupThread(){
      _runner = new Thread( this );
      _runner.start();
  }

  public static void setMaxFileAge( int m ){
    _maxFileAge = m;
  }

  public static FileCleanupThread getInstance(){
    if( _instance == null ){
      _instance = new FileCleanupThread();
    }
    return _instance;
  }

  public void addFile( String fullPathToFile )
    throws Exception
  {
    File newFile = null;
    boolean canWrite = true;
    try{
      newFile = new File( fullPathToFile );
      canWrite = newFile.canWrite();
    }catch( Exception ex ){
      throw new Exception( "Error adding file: " + ex.getMessage() );
    }
    if( !canWrite ){
      throw new Exception( "No permission to delete file" );
    }
    _files.add( newFile );
  }

  public void run(){

    while( true ){
      List toRemove = new ArrayList();
      synchronized( _files ){
	for( Iterator i = _files.iterator(); i.hasNext(); ){
	  File f = (File)i.next();
	  if( System.currentTimeMillis() - f.lastModified() >= _maxFileAge * ONE_HOUR ){
	    try{
	      File dir = f.getParentFile();
	      f.delete();
	      if( dir != null && dir.isDirectory() ){
		File[] contents = dir.listFiles();
		if( contents.length == 0 ){
		  dir.delete();
		}
	      }
	    }catch( Exception ex ){
	      ex.printStackTrace();
	    }
	  }
	  toRemove.add( f );
	}//--end iteration through files
      }
      for( Iterator i = toRemove.iterator(); i.hasNext(); ){
	_files.remove( i.next() );
      }
      try{
	_runner.sleep( 3600000 );
      }catch( InterruptedException ex ){
	//nothing
      }
    }//--end infinite loop

  }

}
