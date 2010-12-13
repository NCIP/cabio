package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIO.bean.*;
import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;
import gov.nih.nci.caBIOApp.sod.*;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.swing.tree.*;

import org.apache.struts.action.*;

public class DesignQueryForm extends ActionForm{

  private WorkflowState _state = null;
  private DefaultMutableTreeNode _objectTree = null;
  private QueryDesign _queryDesign = null;
  private CriterionValue _selectedCriterion = null;
  private String _selectedCriterionId = null;
  private String[] _selectedValues = new String[0];
  private String _selectedValue = null;
  private String _updateOperation = null;
  private String _criteriaTreeEventHandlerName = null;
  private Table _selectedTable = null;
  private int _selectedColNum = -1;
  private boolean _callingSubAction = false;
  private String _labelToAdd = null;
  private String _valueToAdd = null;
  private boolean _showingMergeButton = false;

  public void setCriteriaTreeEventHandlerName( String s ){
    _criteriaTreeEventHandlerName = s;
  }
  public String getCriteriaTreeEventHandlerName(){
    return _criteriaTreeEventHandlerName;
  }

  public void setObjectTree( DefaultMutableTreeNode tree ){
    _objectTree = tree;
  }
  public DefaultMutableTreeNode getObjectTree(){
    return _objectTree;
  }

  public void setQueryDesign( QueryDesign qd ){
    _queryDesign = qd;
  }
  public QueryDesign getQueryDesign(){
    return _queryDesign;
  }

  public void setSelectedCriterionId( String id ){
    _selectedCriterionId = id;
  }
  public String getSelectedCriterionId(){
    return _selectedCriterionId;
  }

  public CriterionValue getSelectedCriterion(){
    return _selectedCriterion;
  }

  public void setState( WorkflowState state ){
    _state = state;
  }
  public WorkflowState getState(){
    return _state;
  }

  public boolean isEditingCriterion(){
    return ( "editCriterion".equals( _state.getNextStep() ) );
  }
  public boolean showDeleteButton(){
    boolean show = false;
    if( "editCriterion".equals( _state.getNextStep() ) &&
	_selectedCriterion != null &&
	_selectedCriterion.getType() != CriterionValue.OBJECT_TYPE ){
      show = true;
    }
    return show;
  }

  /*
  public void selectAll()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    _selectedCriterion.setSelectAll( true );
    updateCriterion();
  }
  */
  public void selectCriterion()
    throws ServletException
  {
    _selectedTable = null;
    try{
      _selectedCriterion = _queryDesign.selectCriterion( _selectedCriterionId );
      MessageLog.printInfo( "DesignQueryForm.selectCriterion(): selectedCriterion: " + 
			    _selectedCriterion.getId() +
			    ", type = " + _selectedCriterion.getType() );
    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error selecting criterion: " + _selectedCriterionId, ex );
    }
  }

  public ValueLabelPair[] getWorkingValues()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    List vals = _selectedCriterion.getValues();
    ValueLabelPair[] vlpVals = null;
    if( vals != null ){
      vlpVals = new ValueLabelPair[vals.size()];
      int counter = 0;
      for( Iterator i = vals.iterator(); i.hasNext(); counter++ ){
	Object o = i.next();
	if( o instanceof ValueLabelPair ){
	  vlpVals[counter] = (ValueLabelPair)o;
	}else{
	  throw new ServletException( "unimplemented feature: can't handle non-ValueLablePair values" );
	}
      }
    }else{
      vlpVals = new ValueLabelPair[0];
    }
    return vlpVals;
  }
  public void setValueToAdd( String s ){
    _valueToAdd = s;
  }
  public String getValueToAdd(){
    return _valueToAdd;
  }
  public void setLabelToAdd( String s ){
    _labelToAdd = s;
  }
  public String getLabelToAdd(){
    return _labelToAdd;
  }
  
  public void setSelectedValue( String s ){
    _selectedValue = s;
  }
  
  public void setSelectedValues( String[] s ){
    _selectedValues = s;
  }
  public void setUpdateOperation( String s ){
    _updateOperation = s;
  }

  public ActionErrors updateCriterion()
    throws ServletException
  {
    ActionErrors errors = new ActionErrors();
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }

    List vals = _selectedCriterion.getValues();
    if( vals == null ) vals = new ArrayList();
    Set valsSet = new HashSet( vals );

    MessageLog.printInfo( "DesignQueryForm.updateCriterion(): _updateOperation = " + _updateOperation );

    if( "add".equals( _updateOperation ) ){
      if( _valueToAdd == null || "".equals( _valueToAdd ) ){
	if( _selectedValues != null ){
	  for( int i = 0; i < _selectedValues.length; i++ ){
	    String val = _selectedValues[i];
	    if( val.trim().length() > 0 ){
	      if( CriterionValue.NUMERIC_TYPE == _selectedCriterion.getType() &&
		  !FormUtils.isLong( val ) ){
		errors.add( "valueToAdd", new ActionError( "errors.nan", val ) );
	      }else{
		MessageLog.printInfo( "Adding: " + val );
		valsSet.add( new ValueLabelPair( val, val ) );
	      }
	    }
	  }
	}else{
	  MessageLog.printInfo( "_selectedValues is null" );
	}
      }else{
	if( _valueToAdd.trim().length() > 0 ){
	  MessageLog.printInfo( "Adding: " + _valueToAdd + ", " + _labelToAdd );
	  if( CriterionValue.BOOLEAN_TYPE == _selectedCriterion.getType() ||
	      CriterionValue.OBJECT_TYPE == _selectedCriterion.getType() ||
	      CriterionValue.DATE_TYPE == _selectedCriterion.getType() ){
	    valsSet.clear();
	  }
	  if( CriterionValue.NUMERIC_TYPE == _selectedCriterion.getType() &&
	      !FormUtils.isLong( _valueToAdd ) ){
		errors.add( "valueToAdd", new ActionError( "errors.nan", _valueToAdd ) );
	  }else{
	    valsSet.add( new ValueLabelPair( _valueToAdd, _labelToAdd ) );
	  }
	}
      }
    }else{
      if( _selectedValues != null && _selectedValues.length > 0 ){
	for( int i = 0; i < _selectedValues.length; i++ ){
	  MessageLog.printInfo( "Removing: " + _selectedValues[i] );
	  valsSet.remove( new ValueLabelPair( _selectedValues[i], null ) );
	}
      }else if( _selectedValue != null && _selectedValue.trim().length() > 0 ){
	MessageLog.printInfo( "Removing: " + _selectedValue );
	valsSet.remove( new ValueLabelPair( _selectedValue, null ) );
      }else{
	MessageLog.printInfo( "Nothing to remove." );
      }
    }

    vals = new ArrayList( valsSet );
    _selectedCriterion.setValues( vals );
    
    return errors;
  }

  public void updateCriteria()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    if( _selectedCriterion.getLink() == null ){
      _selectedCriterion.setLink( "javascript:" + _criteriaTreeEventHandlerName +
				  "('" + _selectedCriterion.getId() + "')" );
    }
    try{
      if( _selectedCriterion.getType() == CriterionValue.OBJECT_TYPE ){
	List vals = _selectedCriterion.getValues();
	if( vals.size() > 1 ){
	  throw new ServletException( "DesignQueryForm.updateCriteria(): vals.size() for object criteria " +
				      _selectedCriterion.getObjectName() + " > 1." );
	}
	String s = (String)((ValueLabelPair)vals.get( 0 )).getValue();
	if( "true".equals( s ) ){
	  _queryDesign.emptyCriterion( _selectedCriterion );
	  _selectedCriterion.setSelectAll( true );
	}else{
	  _selectedCriterion.setSelectAll( false );
	}
	
      }
      
      if( _selectedTable != null ){
	_queryDesign.updateCriterion( _selectedCriterion, _selectedTable, _selectedColNum );
	_selectedTable = null;
	_selectedColNum = -1;
      }else{
	_queryDesign.updateCriterion( _selectedCriterion );
      }

    }catch( Exception ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error updating criteria: " + ex.getMessage() );
    }
    updateContentDisplay( _selectedCriterion );
  }

  public boolean isSummaryToBeRefreshed(){
    return ( "updateCriteria".equals( _state.getNextStep() ) ||
	     "deleteCriterion".equals( _state.getNextStep() ) ||
	     "toggleMerge".equals( _state.getNextStep() ) );
  }


  public void reset( ActionMapping mapping, HttpServletRequest request ){

    String[] selectedVals = request.getParameterValues( "selectedValues" );
    if( selectedVals == null ){
      _selectedValues = new String[0];
    }
    _showingMergeButton = false;
  }


  public void editCriterion()
    throws ServletException
  {
    selectCriterion();
  }

  private void updateContentDisplay( CriterionValue val )
    throws ServletException
  {
    SearchCriteriaNode node = _queryDesign.findNode( val.getId() );
    if( node != null  ){
      if( node.getTable() != null ){
	_showingMergeButton = true;
	StringBuffer extra = new StringBuffer();
	extra.append( "<a href=\"javascript:window.top.topPanel.toggleMerge('" );
	extra.append( val.getId() );
	if( node.isMergeCriterionNode() ){
	  extra.append( "', false )\">" );
	  extra.append( "<img border='0' align='middle' src='images/merge.gif'/>" );
	}else{
	  extra.append( "', true )\">" );
	  extra.append( "<img border='0' align='middle' src='images/not_merge.gif'/>" );
	}
	extra.append( "</a>" );
	val.setExtraContentFirst( true );
	val.setExtraContent( extra.toString() );
      }
      StringBuffer content = new StringBuffer();
      if( val.getType() == CriterionValue.OBJECT_TYPE ){
	content.append( val.getObjectLabel() );
      }else{
	content.append( val.getPropertyLabel() + " = " );
      }
      List vals = val.getValues();
      for( ListIterator i = vals.listIterator(); i.hasNext(); ){
	Object o = i.next();
	if( o instanceof ValueLabelPair ){
	  ValueLabelPair vlp = (ValueLabelPair)o;
	  if( val.getType() == CriterionValue.OBJECT_TYPE ){
	    if( val.isSelectAll() ){
	      content.append( ": All" );
	    }else{
	      //don't append anything
	    }
	  }else{
	    content.append( vlp.getLabel() );
	    
	    //Only show the first 10 criterion values.
	    if( i.previousIndex() == 10 ){
	      content.append( "..." );
	      break;
	    }
	  }
	  if( i.hasNext() ){
	    content.append( " OR " );
	  }
	}else{
	  throw new ServletException( "unimplemented feature: can't handle non-ValueLabelPair values" );
	}
      }//-- end for
      val.setContent( content.toString() );
    }//-- end if( node != null...
  }
  
  public void cancelEdit()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    SearchCriteriaNode node = _queryDesign.findNode( _selectedCriterion.getId() );
    if( node == null ){
      throw new ServletException( "couldn't find criterion with id: " + 
				  _selectedCriterion.getId() );
    }
    CriterionValue val = (CriterionValue)node.getUserObject();
    try{
      _queryDesign.updateCriterion( val );
    }catch( InvalidCriterionException ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error updating criteria: " + ex.getMessage() );
    }
  }

  public void deleteCriterion()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    try{
      _queryDesign.removeCriterion( _selectedCriterion );
    }catch( InvalidCriterionException ex ){
      MessageLog.printStackTrace( ex );
      throw new ServletException( "error deleting criterion: " + ex.getMessage() );
    }
  }

  public ActionErrors updateCriterion( Table table, int colNum )
    throws ServletException
  {
    ActionErrors errors = new ActionErrors();
    //MessageLog.printInfo( "DesignQueryForm.updateCriterion(Table,int)" );
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    if( table != null && colNum > -1 ){
      _selectedTable = table;
      _selectedColNum = colNum;
      MessageLog.printInfo( "...rowCount = " + table.getRowCount() );

      //fill with vals
      ArrayList newVals = new ArrayList();
      for( int i = 0; i < table.getRowCount(); i++ ){
	String val = table.getStringValueAt( i, colNum );
	if( val != null && val.trim().length() > 0 ){
	  String s = val.trim();
	  if( CriterionValue.NUMERIC_TYPE == _selectedCriterion.getType() &&
	      !FormUtils.isLong( val ) ){
	    errors.add( "selectedValues", new ActionError( "errors.nan", val ) );
	  }else{
	    MessageLog.printInfo( "...adding val: " + val );
	    newVals.add( new ValueLabelPair( val, val ) );
	  }
	}
      }
      _selectedCriterion.setValues( newVals );
    }
    return errors;
  }

  public void setCallingSubAction( boolean b ){
    _callingSubAction = b;
  }
  public boolean getCallingSubAction(){
    return _callingSubAction;
  }

  public void toggleMerge()
    throws ServletException
  {
    SearchCriteriaNode node = _queryDesign.findNode( _selectedCriterionId );
    if( node == null ){
      throw new ServletException( "couldn't find node with id: " + _selectedCriterionId );
    }

    if( node.isMergeCriterionNode() ){
      MessageLog.printInfo( "DesignQueryForm.toggleMerge(): setting node " + 
			    ((CriterionValue)node.getUserObject()).getId() + " OFF" );
      node.setIsMergeCriterionNode( false );
      updateContentDisplay( (CriterionValue)node.getUserObject() );
    }else{
      //First, unset the old mergeNode, if it exists
      SearchCriteriaNode mergeNode = _queryDesign.getMergeCriterionNode();
      if( mergeNode != null ){
	MessageLog.printInfo( "DesignQueryForm.toggleMerge(): setting node " + 
			      ((CriterionValue)mergeNode.getUserObject()).getId() + " OFF" );
	mergeNode.setIsMergeCriterionNode( false );
	updateContentDisplay( (CriterionValue)mergeNode.getUserObject() );
      }

      //Then, set the new one to on.
      MessageLog.printInfo( "DesignQueryForm.toggleMerge(): setting node " + 
			    ((CriterionValue)node.getUserObject()).getId() + " ON" );
      node.setIsMergeCriterionNode( true );
      try{
	_queryDesign.setMergeCriterion( _selectedCriterionId );
      }catch( InvalidCriterionException ex ){
	MessageLog.printStackTrace( ex );
	throw new ServletException( "error toggling merge criterion: " + ex.getMessage() );
      }
      updateContentDisplay( (CriterionValue)node.getUserObject() );
    }
  }
  /*
  public String getOntologyBrowserJSFunctionName()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    String objName = _selectedCriterion.getObjectName();
    String funcName = null;
    if( "gov.nih.nci.caBIO.bean.Organ".equals( objName ) ){
      funcName = "showTissueTree";
    }else if( "gov.nih.nci.caBIO.bean.Disease".equals( objName ) ){
      funcName = "showDiagnosisTree";
    }else{
      throw new ServletException( "unimplemented feature: cannot handle ontological property for " +
				  objName );
    }
    return funcName;
  }
  */
  public boolean showFetchButton(){
    boolean show = false;
    if( CriterionValue.NUMERIC_TYPE == _selectedCriterion.getType() ||
	CriterionValue.STRING_TYPE == _selectedCriterion.getType() ){
      show = true;
    }
    return show;
  }

  public boolean isUsingSpreadsheet(){
    boolean is = false;
    if( _selectedTable != null ){
      is = true;
    }else{
      try{
	SearchCriteriaNode node = _queryDesign.findNode( _selectedCriterionId );
	if( node != null && node.getTable() != null ){
	  is = true;
	}
      }catch( Exception ex ){
	MessageLog.printStackTrace( ex );
	throw new RuntimeException( "error checking if is using sreadhseet: " + 
				    ex.getMessage() );
      }
    }
    return is;
  }

  public boolean showBrowseButton()
    throws ServletException
  {
    boolean show = false;
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    SearchableObject so = _selectedCriterion.getSearchableObject();
    if( so != null ){
      List labelProps = so.getLabelProperties();
      Attribute att = _selectedCriterion.getAttribute();
      if( att != null ){
	String attName = att.getName();
	for( Iterator i = labelProps.iterator(); i.hasNext(); ){
	  if( attName.equals( (String)i.next() ) ){
	    show = true;
	    break;
	  }
	}
      }
    }
    return show;
  }

  public String getBeanName()
    throws ServletException
  {
    if( _selectedCriterion == null ){
      throw new ServletException( "no criterion selected" );
    }
    SearchableObject so = _selectedCriterion.getSearchableObject();
    return SODUtils.getInstance().getShortName( so.getClassname() );
  }

  public String getOntologyRootId()
    throws ServletException
  {
    SearchableObject so = _selectedCriterion.getSearchableObject();
    if( !so.getOntological() ){
      throw new ServletException( so.getClassname() + " is not part of an ontology." );
    }
    Ontologable bean = null;
    try{
      bean = _queryDesign.getOntologyRoot( so.getClassname() );
    }catch( Exception ex ){
      throw new ServletException( "Couldn't get ontology root id.", ex );
    }
    if( bean == null ){
      throw new ServletException( "No ontology root found for " + so.getClassname() );
    }
    return bean.getId().toString();
  }
  
  /**
   * Allow if:
   *  1. The criterion type is not BOOLEAN or OBJECT
   *  2. The values come from a spreadsheet.
   */
  public boolean showAddButton(){
    boolean allow = true;
    int criterionType = _selectedCriterion.getType();
    if( CriterionValue.BOOLEAN_TYPE == criterionType ||
	CriterionValue.OBJECT_TYPE == criterionType ||
	isUsingSpreadsheet() ){
      allow = false;
    }
    return allow;
  }
  public boolean showRemoveButton(){
    return showAddButton();
  }  
  public boolean isShowingMergeButton(){
    return _showingMergeButton;
  }
}

