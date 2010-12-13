package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.common.search.*;
import gov.nih.nci.common.util.COREUtilities;
import gov.nih.nci.caBIOApp.sod.*;
import gov.nih.nci.caBIOApp.report.*;
import gov.nih.nci.caBIO.search.*;

import java.util.*;
import java.text.*;

public class ReportDesign{

  private QueryDesign _qd = null;
  private String _id = null;
  private String _label = null;
  private String _name = null;
  private Table _mergeTable = null;
  private List _colSpecs = new ArrayList();
  private boolean _refreshCache = true;
  private List _rowIndices = null;
  private int _idxSeq = 0;
  private List _nullCellRowNums = new ArrayList();
  private HashMap _filters = new HashMap();
  //private SearchableObjectsDescription _sod = null;

  public ReportDesign( String id, String label, QueryDesign qd ){
    try{
      _qd = qd;
      /*
      _id = qd.getId() + "_" + System.currentTimeMillis();
      _label = qd.getLabel() + " - Report " + 
	DateFormat.getTimeInstance( DateFormat.SHORT ).format( new Date() );
      */
      _id = id;
      _label = label;
      SearchCriteriaNode mergeNode = _qd.getMergeCriterionNode();
      if( mergeNode == null ){
	/* User doesn't want to merge. So, don't
	 * need to prepopulate merge table.
	 */
	MessageLog.printInfo( "ReportDesign( QueryDesign ): NOT merging" );
	_mergeTable = new CaBIOTable( 1, 1 );
      }else{
	/* User plans to merge.
	 */
	MessageLog.printInfo( "ReportDesign( QueryDesign ): IS merging" );
	_mergeTable = (Table)mergeNode.getTable().clone();
	setupColSpecs( _mergeTable, mergeNode );
      }
    }catch( RuntimeException ex ){
      MessageLog.printStackTrace( ex );
      throw ex;
    }
  }

  private void setupColSpecs( Table table, SearchCriteriaNode node ){

    int mergeCol = node.getSourceColumnNumber();
    MessageLog.printInfo( "ReportDesign.setupColSpecs(): mergeCol = " + mergeCol );
    int colCount = table.getColumnCount();
    for( int i = 0; i < colCount; i++ ){
      ColumnSpecification colSpec = new ColumnSpecification();
      if( i != mergeCol ){
	colSpec.setId( Integer.toString( i ) );
	String title = table.getColumnName( i );
	if( title == null ){
	  title = "COLUMN #" + Integer.toString( i + 1 );
	}
	colSpec.setOldColumnTitle( title );
	colSpec.setNewColumnTitle( title );
      }else{
	//colSpec.setId( node.getObjectName() +
	//	       "." + node.getPropertyName() );
	colSpec.setId( node.getId() );
	colSpec.setPath( node.getId() );
	MessageLog.printInfo( "The merge colSpec has id " + colSpec.getId() );
	CriterionValue val = (CriterionValue)node.getUserObject();
	colSpec.setOldColumnTitle( val.getObjectLabel() + " " +
				   val.getPropertyLabel() );
	colSpec.setNewColumnTitle( val.getObjectLabel() + " " +
				   val.getPropertyLabel() );
	colSpec.setIsMapped( true );
	colSpec.setIsMergeColumn( true );
	colSpec.setObjectName( val.getObjectName() );			  
	colSpec.setObjectLabel( val.getObjectLabel() );
	colSpec.setAttributeName( val.getPropertyName() );
	colSpec.setAttributeLabel( val.getPropertyLabel() );
      }
      colSpec.setOldColumnNumber( i );
      colSpec.setNewColumnNumber( i );
      _colSpecs.add( colSpec );
    }

  }


  /**
   * Given the classname of a caBIO object and an attribute name,
   * this method will check to see if a ColumnSpecification for it exists and
   * if so, return a _copy_ of it. If a ColumnSpecification for it doesn't
   * exist, it will create a new one and return a copy of it.
   *
   * @param objectName the classname of a caBIO object
   * @param attributeName the attribute name of the given caBIO object
   * @return ColumnSpecification that describes the mapping of column to object-attribute
   * @throws InvalidSpecificationException if the given object-attribute is not allowed according to rules
   */
  public ColumnSpecification selectColumn( String searchId )
    throws InvalidSpecificationException
  {
    ColumnSpecification theSpec = null;

    MessageLog.printInfo( "ReportDesign.selectColumn(): searchId = " + searchId );

    SODUtils sod = SODUtils.getInstance();
    if( searchId.startsWith( sod.getBeanName( _qd.getObjectName() ) + "." ) ){
      searchId = searchId.substring( searchId.indexOf( "." ) + 1 );
    }

    //deactivate all colSpecs
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification aColSpec = (ColumnSpecification)i.next();
      MessageLog.printInfo( "COLSPEC_ID: " + aColSpec.getId() );
      if( aColSpec.isActive() ){
	aColSpec.setActive( false );
      }
    }
    theSpec = getColumnSpecification( searchId );

    //if it doesn't exist, create a new one
    if( theSpec == null ){
      String theClassName = null;
      String theAttName = null;
      if( searchId.indexOf( "." ) != -1 ){
	theAttName = searchId.substring( searchId.lastIndexOf( "." ) + 1 );
	String rest = searchId.substring( 0, searchId.lastIndexOf( "." ) );
	String beanName = sod.getBeanNameFromPath( sod.getBeanName( _qd.getObjectName() ) + "." + rest );
	SearchableObject so = sod.getSearchableObject( beanName );
	if( so == null ){
	throw new InvalidSpecificationException( "couldn't find searchable object for: " + beanName );
	}
	theClassName = so.getClassname();
      }else{
	theClassName = _qd.getObjectName();
	theAttName = searchId;
      }
      theSpec = new ColumnSpecification( theClassName, theAttName );
      theSpec.setId( searchId );
      theSpec.setPath( searchId );
      theSpec.setNewColumnNumber( getMaxColumnNumber() + 1 );
      _colSpecs.add( theSpec );
    }
    ColumnSpecification copy = null;
    if( theSpec != null ){
      theSpec.setActive( true );
      copy = new ColumnSpecification( theSpec );
    }
    //return a copy, not the real thing
    return copy;
  }

  public void updateColumn( ColumnSpecification aColSpec )
    throws InvalidSpecificationException
  {
    if( aColSpec == null ){
      throw new InvalidSpecificationException( "specification is null" );
    }
    ColumnSpecification theColSpec = getColumnSpecification( aColSpec.getId() );
    if( theColSpec == null ){
      throw new InvalidSpecificationException( "Couldn't find ColumnSpecification for id: " +
					   aColSpec.getId() );
    }
    int oldSpecNewColNum = theColSpec.getNewColumnNumber();
    int newSpecNewColNum = aColSpec.getNewColumnNumber();
    /*
    MessageLog.printInfo( "ReportDesign.updateColumn(): " +
			  "theColSpec.getId() = " + theColSpec.getId() + 
			  ", theColSpec.getNewColumnNumber() = " + oldSpecNewColNum + 
			  ", aColSpec.getId() = " + aColSpec.getId() +
			  ", aColSpec.getNewColumnNumber() = " + newSpecNewColNum );
    MessageLog.printInfo( "ReportDesign.updateColumn(): size before calling _colSpecs.set: " +
			  _colSpecs.size() );
    */
    //Replace oldSpec with new
    //_colSpecs.set( oldSpecNewColNum, aColSpec );
    int idx = _colSpecs.indexOf( aColSpec );
    _colSpecs.set( idx, aColSpec );
    /*
    MessageLog.printInfo( "ReportDesign.updateColumn(): size after calling _colSpecs.set: " +
			  _colSpecs.size() );
    */
    //Determine if the positions of this spec has changed.
    if( oldSpecNewColNum != newSpecNewColNum ){

      //position has changed
      moveColumnSpecification( oldSpecNewColNum, newSpecNewColNum );
    }
  }

  public Table getMergeTable()
    throws InvalidSpecificationException
  {

    Table newMergeTable = 
      new CaBIOTable( _mergeTable.getRowCount(), _colSpecs.size() );
    
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification aSpec = (ColumnSpecification)i.next();
      if( !aSpec.isMapped() || aSpec.isMergeColumn() ){
	//copy the values of this column into the final table
	copyColumnValues( _mergeTable, newMergeTable, 
			  aSpec.getOldColumnNumber(), 
			  aSpec.getNewColumnNumber() );
      }else if( aSpec.isNewColumn() ){
	//do nothing
      }else{
	throw new InvalidSpecificationException( "ColumnSpecification " + aSpec.getId() +
						 " is neither unmapped, nor merge, nor new." );
      }
    }

    return newMergeTable;
  }

  public List getRowIndices()
    throws InvalidCriterionException
  {
    MessageLog.printInfo( "ReportDesign.getRowIndices()" );
    //if( _refreshCache ){
      buildRowIndicesAndSearchParams();
      //}
    return _rowIndices;
  }

  public List getJoinObjectNames(){
    Set objNames = new HashSet();
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification spec = (ColumnSpecification)i.next();
      if( spec.isMapped() ){
	objNames.add( spec.getObjectName() );
      }
    }

    StringBuffer sb = new StringBuffer();
    sb.append( "ReportDesign.getJoinObjectNames(): join objects: " );

    String mainObjName = _qd.getRootSearchCriteriaNode().getObjectName();
    List retVals = null;
    retVals = new ArrayList();

    //ensure that main object name is first
    sb.append( "\n" + mainObjName );
    retVals.add( mainObjName );
    for( Iterator i = objNames.iterator(); i.hasNext(); ){
      String name = (String)i.next();
      if( !mainObjName.equals( name ) ){
	sb.append( "\n" + name );
	retVals.add( name );
      }
    }
    MessageLog.printInfo( sb.toString() );
    return retVals;
  }

  private void buildRowIndicesAndSearchParams()
    throws InvalidCriterionException
  {
    MessageLog.printInfo( "ReportDesign.buildRowIndicesAndSearchParams()" );
    _rowIndices = new ArrayList();
    
    //generate the common SearchCriteria
    //SearchCriteria commonCriteria = _qd.toSearchCriteria();
    
    //get the merge criterion node
    SearchCriteriaNode mergeNode = _qd.getMergeCriterionNode();
    
    if( mergeNode == null ){
      //then we aren't merging
      MessageLog.printInfo( "ReportDesign: we are NOT merging." );
      //RowIndex idx = new RowIndex();
      //idx.setIndex( 1 );
      //idx.setSearchCriteria(commonCriteria);
      //_rowIndices.add( idx );
    }else{
      //we are merging
      MessageLog.printInfo( "ReportDesign: we are merging." );
      //build row indices and search params
      HashMap valToIdx = new HashMap();
      //int mergeColNum = getMergeColumnNumber();
      int mergeColNum = getMergeColumnSpecification().getOldColumnNumber();
      int rowCount = _mergeTable.getRowCount();
      int colCount = _mergeTable.getColumnCount();
      MessageLog.printInfo( "ReportDesign: mergeColNum = " + mergeColNum +
			    ", rowCount = " + rowCount + ", colCount = " + colCount );
      for( int rowNum = 0; rowNum < rowCount; rowNum++ ){
	
	//look for RowIndex with this value
	String val = _mergeTable.getStringValueAt( rowNum, mergeColNum );
	if( val != null && val.trim().length() > 0 ){
	  RowIndex idx = (RowIndex)valToIdx.get( val );
	  if( idx == null ){
	    MessageLog.printInfo( "ReportDesign: row " + rowNum +
				  " with value " + val + " first encountered." );	    
	    //create a rowIndex and searchParam
	    idx = new RowIndex();
	    idx.setIndex( _idxSeq++ );
	    idx.setDatasource( (Datasource)mergeNode.getTable() );
	    //idx.setSearchCriteria( _qd.toSearchCriteria( val ) );
	    idx.setCriteria( _qd.toSearchCriteria( val ) );
	    _rowIndices.add( idx );
	    valToIdx.put( val, idx );
	    
	  }else{
	    MessageLog.printInfo( "ReportDesign: row " + rowNum +
				  " has duplicate value: " + val );	    
	  }
	  //add this rowNum to found RowIndex
	  idx.addRowNumber( new Integer( rowNum ) );
	}else{
	  MessageLog.printInfo( "ReportDesign: val at row " + rowNum +
				" is null." );
	  _nullCellRowNums.add( new Integer( rowNum ) );
	}//-- end if( val != null...
	
      }//-- end for( int rowNum...
    }//-- end else: we are merging
    
  }//-- end build RowIndicesAndSearchParams
  
  public int getMergeColumnNumber(){
    return getMergeColumnSpecification().getNewColumnNumber();
  }

  public ColumnSpecification getMergeColumnSpecification(){
    MessageLog.printInfo( "ReportDesign.getMergeColumnSpecification()" );
    ColumnSpecification mSpec = null;
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification spec = (ColumnSpecification)i.next();
      if( spec.isMergeColumn() ){
	mSpec = spec;
      }
    }
    if( mSpec == null ){
      throw new RuntimeException( "Couldn't find merge colSpec" );
    }else{
      MessageLog.printInfo( "...found it." );
    }
    return mSpec;
  }

  public int getMaxColumnNumber(){
    int max = 0;
    /*
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      int tst = ((ColumnSpecification)i.next()).getNewColumnNumber();
      if( tst > max ){
	max = tst;
      }
    }
    */
    max = _colSpecs.size() - 1;
    return max;
  }

  private ColumnSpecification getColumnSpecification( String id ){

    ColumnSpecification theSpec = null;

    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification aSpec = (ColumnSpecification)i.next();
      /*
      MessageLog.printInfo( "ReportDesign.getColumnSpecification(): comparing " +
			    id + ", with " + aSpec.getId() );
      */
      if( aSpec.getId().equals( id ) ){
	theSpec = aSpec;
	break;
      }
    }
    
    return theSpec;
  }

  public void removeColumn( ColumnSpecification colSpec )
    throws InvalidSpecificationException
  {
    int numSpecs = _colSpecs.size();
    if( numSpecs == 1 ){
      _colSpecs.clear();
    }else{
      int idx = _colSpecs.indexOf( colSpec );
      if( idx == -1 ){
	throw new InvalidSpecificationException( "couldn't find spec with id: " + colSpec.getId() );
      }
      _colSpecs.remove( idx );
      for( int i = idx; i < _colSpecs.size(); i++ ){
	ColumnSpecification cs = (ColumnSpecification)_colSpecs.get( i );
	cs.setNewColumnNumber( i );
      }
    }
  }

  private void moveColumnSpecification( int oldNewColNum, int newNewColNum )
    throws InvalidSpecificationException
  {
    MessageLog.printInfo( "ReportDesign.moveColumnSpecification(): " +
			  "oldNewColNum = " + oldNewColNum +
			  ", newNewColNum = " + newNewColNum );

    //validate the move
    if( newNewColNum == _colSpecs.size() || newNewColNum < 0 ){
      throw new InvalidSpecificationException( "invalid column number: " + 
					       newNewColNum );
    }

    //if not moving, do nothing - return
    if( newNewColNum == oldNewColNum ){
      return;
    }
    
    //determine direction
    boolean toRight = true;
    if( newNewColNum < oldNewColNum ){
      toRight = false;
    }
    //MessageLog.printInfo( "MOVING TO " + ( toRight ? "RIGHT" : "LEFT" ) );

    //do the physical move
    ColumnSpecification theSpec = (ColumnSpecification)_colSpecs.get( oldNewColNum );
    //MessageLog.printInfo( "SIZE BEFORE REMOVING: " + _colSpecs.size() );
    _colSpecs.remove( oldNewColNum );
    // MessageLog.printInfo( "SIZE AFTER REMOVING: " + _colSpecs.size() );
    _colSpecs.add( newNewColNum, theSpec );
    //MessageLog.printInfo( "SIZE AFTER ADDING: " + _colSpecs.size() );

    //do the logical move
    boolean done = false;
    int colNum = 0;
    int idx = newNewColNum;
    do{
      if( toRight ){
	idx--;
      }else{//toLeft
	idx++;
      }
      if( idx == -1 || idx == _colSpecs.size() ){
	done = true;
      }
      if( !done && idx != newNewColNum ){
	ColumnSpecification cs = (ColumnSpecification)_colSpecs.get( idx );
	MessageLog.printInfo( "changing col num of cs " + cs.getId() +
			      " from " + cs.getNewColumnNumber() +
			      " to " + idx );
	cs.setNewColumnNumber( idx );
      }
    }while( !done );

  }//-- end moveColumnSpecification

  private void copyColumnValues( Table srcTable, Table destTable, int oldColNum, int newColNum ){

    int rowCount = srcTable.getRowCount();
    for( int i = 0; i < rowCount; i++ ){
      destTable.setStringValueAt( srcTable.getStringValueAt( i, oldColNum ), i, newColNum );
    }

  }

  public List getColumnSpecifications()
    throws InvalidSpecificationException
  {
    List copiedSpecs = new ArrayList();
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      copiedSpecs.add( new ColumnSpecification( (ColumnSpecification)i.next() ) );
    }
    return copiedSpecs;
  }

  public SearchCriteria getCommonCriteria()
    throws InvalidCriterionException
  {
    return _qd.toSearchCriteria();
  }
    public void setId( String s ){
	_id = s;
    }
    public String getId(){
	return _id;
    }
    public void setLabel( String s ){
	_label = s;
    }
    public String getLabel(){
	return _label;
    }
  public QueryDesign getQueryDesign(){
    return _qd;
  }
  public List getNullCellRowNums(){
    return _nullCellRowNums;
  }

  public SelectionNode getSelectionTree()
    throws Exception
  {
    MessageLog.printInfo( "ReportDesign.getSelectionTree()" );
    //This is here until I implement filter construction in the GUI
    SearchCriteriaNode mergeCrit = (SearchCriteriaNode)_qd.getMergeCriterionNode();
    if( mergeCrit != null ){
      SearchCriteriaNode mergeCritParent = (SearchCriteriaNode)mergeCrit.getParent();
      //MessageLog.printInfo( "...caching merge filter under: " + mergeCritParent.getId() );
      _filters.put( mergeCritParent.getId(), mergeCritParent );
    }

    //Create the root node
    String basePath = SODUtils.getInstance().getShortName( _qd.getObjectName() );
    SelectionNode tree = new SelectionNodeImpl( basePath,
						_qd.toSearchCriteria(),
						new ArrayList() );
    for( Iterator i = _colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification colSpec = (ColumnSpecification)i.next();
      if( colSpec.isMapped() ){
	String csPath = colSpec.getPath();
	/*
	int pidx = csPath.indexOf( "." );
	if( pidx != -1 ){
	  String fe = csPath.substring( 0, pidx );
	  if( basePath.equals( fe ) ){
	    csPath = csPath.substring( pidx + 1 );
	  }
	}
	*/
	if( !csPath.startsWith( basePath ) ){
	  csPath = basePath + "." + csPath;
	}
	MessageLog.printInfo( "...csPath = " + csPath );
	insertIntoTree( tree, csPath );
      }
    }
    return tree;
  }

  protected void insertIntoTree( SelectionNode parent, String path )
    throws Exception
  {
    MessageLog.printInfo( "ReportDesign.insertIntoTree(): parent.getClassname() = " +
    			  parent.getClassname() + ", path = " + path );
    SODUtils sod = SODUtils.getInstance();
    String pbn = sod.getBeanName( parent.getClassname() );
    if( pbn.endsWith( "Impl" ) ){
      pbn = pbn.substring( 0, pbn.indexOf( "Impl" ) );
    }
    if( path.startsWith( pbn + "." ) ){
      path = path.substring( path.indexOf( "." ) + 1 );
    }
    int idx = path.indexOf( "." );
    if( idx == -1 ){
      //Then we need to add an attribute to the parent node.
      List atts = parent.getAttributes();
      atts.add( path );
    }else{
      String firstElement = path.substring( 0, idx );
      String restOfPath = path.substring( idx + 1 );
      //See if child node for firstElement already exists
      SelectionNode theChild = null;
      for( Enumeration children = parent.children(); children.hasMoreElements(); ){
	SelectionNode aChild = (SelectionNode)children.nextElement();
	if( aChild.getPathName().endsWith( firstElement ) ){
	  theChild = aChild;
	  break;
	}
      }
      if( theChild == null ){
	//It doesn't exist, so create it.
	String newPath = parent.getPathName() + "." + firstElement;

	//See if there is a special filter for this.
	SearchCriteria filter = null;
	//MessageLog.printInfo( "...looking for filter under newPath: " + newPath );
	SearchCriteriaNode f = (SearchCriteriaNode)_filters.get( newPath );
	if( f != null ){
	  //MessageLog.printInfo( "...found special filter" );
	  filter = _qd.toSearchCriteria( f, null );
	}else{
	  //There isn't, so just use a blank one.
	  //MessageLog.printInfo( "...creating blank filter" );
	  /*
	  filter = 
	    (SearchCriteria)Class.forName( "gov.nih.nci.caBIO.bean." + 
					   firstElement + 
					   "SearchCriteria" ).newInstance();
	  */
	  String beanName = 
	    sod
	    .getBeanNameFromPath( sod.getBeanName( parent.getClassname() ) +
				  "." + firstElement );
	  String scClassName = 
	    COREUtilities.getSCPackageName( beanName ) + 
	    "." + beanName + "SearchCriteria";
	  filter = (SearchCriteria)Class.forName( scClassName ).newInstance();
	}
	theChild = new SelectionNodeImpl( newPath, filter, new ArrayList() );
	parent.insert( theChild, parent.getChildCount() );
      }
      insertIntoTree( theChild, restOfPath );
    }
  }
}

