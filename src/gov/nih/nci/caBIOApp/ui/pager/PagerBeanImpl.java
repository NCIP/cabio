package gov.nih.nci.caBIOApp.ui.pager;

import gov.nih.nci.caBIOApp.util.*;

import java.util.*;

public class PagerBeanImpl implements PagerBean{

  private int _startIdx = 0;
  private int _defaultDisplaySize = 25;
  private int _displaySize = _defaultDisplaySize;
  private String _scrollDirection = null;

  private TreeMap _cachedItems = null;
  private PagerItem[] _cachedItemsIndex = null;
  private TreeMap _selectedItems = null;
  private String[] _selectedIds = null;

  private PagerDataSource _dataSource = null;
  private int _itemCount = -1;
  private boolean _allowSelection = false;
  private String[] _headers = null;

  public PagerBeanImpl(){
  }

  public void setPagerDataSource( PagerDataSource pds )
    throws Exception
  {
    if( pds == null ){
      throw new Exception( "Data source is null." );
    }
    _dataSource = pds;
    _startIdx = 0;
    _scrollDirection = null;
    _cachedItems = new TreeMap();
    _selectedItems = new TreeMap();
    _itemCount = _dataSource.getItemCount();
    _cachedItemsIndex = new PagerItem[ _itemCount ];
    _headers = _dataSource.getHeaders();
  }

  public void setSelectedIds( String[] ids ){
    _selectedIds = ids;
  }

  public void select(){
    if( _selectedIds != null ){
      for( int i = 0; i < _selectedIds.length; i++ ){
	MessageLog.printInfo( "Selecting " + _selectedIds[i] );
	PagerItem pi = (PagerItem)_cachedItems.get( _selectedIds[i] );
	pi.setSelected( true );
	_selectedItems.put( _selectedIds[i], pi );
      }
    }
  }
  public void deselect(){
    if( _selectedIds != null ){
      for( int i = 0; i < _selectedIds.length; i++ ){
	MessageLog.printInfo( "Deselecting " + _selectedIds[i] );
	PagerItem pi = (PagerItem)_selectedItems.remove( _selectedIds[i] );
	pi.setSelected( false );
      }
    }
  }

  public PagerItem[] getAvailableItems()
    throws Exception
  {
    if( _cachedItemsIndex == null ){
      throw new Exception( "_cachedItemsIndex is null" );
    }

    PagerItem[] items = new PagerItem[ _startIdx + _displaySize ];
    if( _itemCount > 0 ){
      if( _cachedItemsIndex[ _startIdx ] == null ){
	if( _dataSource == null ){
	  throw new Exception( "_dataSource is null." );
	}
	PagerItem[] newItems = _dataSource.getItems( _startIdx, _displaySize );
	if( newItems == null ){
	  throw new Exception( "newItems is null" );
	}
	for( int i = 0; i < newItems.length; i++ ){
	  PagerItemWrapper piw = new PagerItemWrapper( _startIdx + i, newItems[i] );
	  items[i] = piw;
	  _cachedItemsIndex[ piw.getIndex() ] = piw;
	  if( _cachedItems == null ){
	    throw new Exception( "_cachedItems is null" );
	  }
	  _cachedItems.put( piw.getId(), piw );
	}
      }else{
	for( int i = 0; i < _displaySize; i++ ){
	  items[i] = _cachedItemsIndex[ i + _startIdx ];
	}
      }
    }//-- end if( _itemCount > 0...
    return items;
  }

  public PagerItem[] getSelectedItems(){
    PagerItem[] items = new PagerItem[ _selectedItems.size() ];
    int i = 0;
    for( Iterator it = _selectedItems.values().iterator(); it.hasNext(); i++ ){
      items[i] = (PagerItem)it.next();
    }
    return items;
  }

  public int getStartIndex(){
    return _startIdx;
  }
  public int getDisplaySize(){
    return _displaySize;
  }

  public boolean getAllowScrollBegin(){
    return getAllowScrollBackward();
  }
  public boolean getAllowScrollEnd(){
    return getAllowScrollForward();
  }
  public boolean getAllowScrollForward(){
    boolean allow = false;
    if( ( _startIdx + _defaultDisplaySize ) < _itemCount - 1 ){
      allow = true;
    }
    return allow;
  }
  public boolean getAllowScrollBackward(){
    boolean allow = false;
    if( ( _startIdx - _defaultDisplaySize ) > -1 ){
      allow = true;
    }
    return allow;
  }

  public void setScrollDirection( String s ){
    _scrollDirection = s;
  }
  public String getScrollDirection(){
    return _scrollDirection;
  }

  public void scroll()
    throws Exception
  {
    if( "begin".equals( _scrollDirection ) ){
      _startIdx = 0;
      _displaySize = Math.min( _defaultDisplaySize, _itemCount );
    }else if( "forward".equals( _scrollDirection ) ){
      _startIdx = Math.min( _itemCount - 1, _startIdx + _defaultDisplaySize );
      _displaySize = Math.min( _defaultDisplaySize, 
			       Math.min( _itemCount - _startIdx, 
					 _defaultDisplaySize ) );
    }else if( "backward".equals( _scrollDirection ) ){
      _startIdx = Math.max( 0, _startIdx - _defaultDisplaySize );
      _displaySize = Math.min( _defaultDisplaySize, _itemCount );
    }else if( "end".equals( _scrollDirection ) ){
      _startIdx = Math.max( 0, _itemCount - _defaultDisplaySize );
      _displaySize = Math.min( _defaultDisplaySize, _itemCount );
    }else{
      //Do nothing
    }

  }

  public void setAllowSelection( boolean b ){
    _allowSelection = b;
  }
  public boolean getAllowSelection(){
    return _allowSelection;
  }


  public int getItemCount(){
    return _itemCount;
  }
  public String[] getHeaders(){
    return _headers;
  }

  public void setDefaultDisplaySize( int i ){
    _defaultDisplaySize = i;
  }
}

