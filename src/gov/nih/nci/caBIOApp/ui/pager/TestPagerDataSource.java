package gov.nih.nci.caBIOApp.ui.pager;

import gov.nih.nci.caBIO.bean.*;
import gov.nih.nci.caBIO.search.*;
import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.ui.pager.*;

import java.util.*;
import java.lang.reflect.*;

public class TestPagerDataSource extends CaBIOPagerDataSource implements PagerDataSource{

  private ArrayList _items = new ArrayList();

  public TestPagerDataSource( String classname, SearchCriteria criteria, List joins ){
    super( classname, criteria );
    /*
    try{
      QueryResolver qr = new QueryResolver();
      CaBIOMatrix matrix = qr.getCaBIOMatrix( _criteria, joins );
      if( matrix == null ){
	MessageLog.printInfo( "TestPagerDataSource.<init>: matrix is null" );
      }else{
	MessageLog.printInfo( "TestPagerDataSource.<init>: matrix is NOT null" );
      }
      boolean showMsg = true;
      for( Iterator i = matrix.getIterator(); i.hasNext(); ){
	if( showMsg ){
	  MessageLog.printInfo( "TestPagerDataSource.<init>: in for loop" );
	  showMsg = false;
	}
	Hashtable row = (Hashtable)i.next();
	if( row == null ){
	  MessageLog.printInfo( "TestPagerDataSource.<init>: row is null" );
	}else{
	  MessageLog.printInfo( "TestPagerDataSource.<init>: getting vals..." );	  

	  Set keys = row.keySet();
	  if( keys != null ){
	    MessageLog.printInfo( "TestPagerDataSource.<init>: keys is NOT null" );
	    if( keys.size() > 0 ){
	      //List valsList = new ArrayList( vals );
	      //_items.add( new PagerItemImpl( "x", (String[])valsList.toArray( new String[valsList.size()] ) ) );
	      MessageLog.printInfo( "keys.size() = " + keys.size() );
	      String[] strs = new String[keys.size()];
	      int idx = 0;
	      for( Iterator j = keys.iterator(); j.hasNext(); idx++ ){
		String key = (String)j.next();
		MessageLog.printInfo( "key = " + key );
		strs[idx] = row.get( key ).toString();
	      }
	      PagerItemImpl pil = new PagerItemImpl( "x", strs );
	      _items.add( pil );
	    }
	  }else{
	    MessageLog.printInfo( "TestPagerDataSource.<init>: keys is null" );
	  }
	}
      }
    }catch( Exception ex ){
      throw new RuntimeException( "Error constructing: " + ex.getMessage() );
    }
    */
  }

  public PagerItem[] getItems( int startIdx, int numItems )
    throws Exception
  {
    PagerItem[] items = new PagerItem[ numItems ];
    for( int i = 0; i < numItems; i++ ){
      items[i] = (PagerItem)_items.get( startIdx + i );
    }
    return items;
  }

  public int getItemCount(){
    return _items.size();
  }
    
}

