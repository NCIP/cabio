package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.sod.*;
import gov.nih.nci.caBIOApp.ui.tree.*;
import gov.nih.nci.caBIOApp.util.*;

import java.util.*;

public class CriterionValue
  extends CaBIONodeContent
  implements Cloneable
{

  public static final int STRING_TYPE = 0;
  public static final int NUMERIC_TYPE = 1;
  public static final int DATE_TYPE = 2;
  public static final int ONTOLOGICAL_TYPE = 3;
  public static final int OBJECT_TYPE = 4;
  public static final int BOOLEAN_TYPE = 5;
  public static final int FLOAT_TYPE = 6;

  private int _type = -1;
  private String _objectName = null;
  private String _propertyName = null;
  private String _objectLabel = null;
  private String _propertyLabel = null;
  private List _values = new ArrayList();
  private List _ranges = new ArrayList();
  private SearchableObject _so = null;
  private Attribute _att = null;
  private boolean _selectAll = false;

  public CriterionValue( SearchableObject so, String id ){
    super( id, so.getLabel(), so.getDescription(),
	   null, null, false, null );
    _type = OBJECT_TYPE;
    _objectLabel = so.getLabel();
    _objectName = so.getClassname();
    _propertyName = "";
    _propertyLabel = "";
    _so = so;
  }
  public CriterionValue( SearchableObject so, Attribute att, String id ){
    super( id, ( att == null ? "Ontological Property" : att.getLabel() ),
	   ( att == null ? "This object is part of an ontology" : att.getLabel() ), 
	   null, null, false, null );
    MessageLog.printInfo( "CriterionValue(SearchableObject,Attribute,String): " +
			  "creating node" +
			  ", so.getOntological() = " + so.getOntological() +
			  ", id = " + id );
    if( so.getOntological() && att == null ){

      _type = ONTOLOGICAL_TYPE;
      _propertyName = "ontological";
      _propertyLabel = "Ontological Property";
    }else{
      MessageLog.printInfo( "att.getType() = " + att.getType() );
      if( att.getType().equals( AttributeType.ALPHANUMERIC ) ){
	_type = STRING_TYPE;
      }else if( att.getType().equals( AttributeType.NUMERIC ) ){
	_type = NUMERIC_TYPE;
      }else if( att.getType().equals( AttributeType.BOOLEAN ) ){
	_type = BOOLEAN_TYPE;
      }else if( att.getType().equals( AttributeType.DATE ) ){
	_type = DATE_TYPE;
      }else if( att.getType().equals( AttributeType.FLOAT ) ){
	_type = FLOAT_TYPE;
      }
      _propertyName = att.getName();
      _propertyLabel = att.getLabel();
    }

    _objectName = so.getClassname();
    _objectLabel = so.getLabel();
    _so = so;
    _att = att;
  }

  public CriterionValue( CriterionValue val ){
    super( (CaBIONodeContent)val );
    _att = val.getAttribute();
    _so = val.getSearchableObject();
    _type = val.getType();
    _objectName = new String( val.getObjectName() );
    _objectLabel = new String( val.getObjectLabel() );
    _propertyName = new String( val.getPropertyName() );
    _propertyLabel = new String( val.getPropertyLabel() );
    _values = new ArrayList();
    for( Iterator i = val.getValues().iterator(); i.hasNext(); ){
      Object o = i.next();
      if( o instanceof ValueLabelPair[] ){
	ValueLabelPair[] a = (ValueLabelPair[])o;
	//it is a range
	ValueLabelPair r1 = new ValueLabelPair( (ValueLabelPair)a[0] );
	ValueLabelPair r2 = new ValueLabelPair( (ValueLabelPair)a[1] );
	ValueLabelPair[] range = new ValueLabelPair[]{ r1, r2 };
	_values.add( range );
      }else{
	//it is a discrete value
	_values.add( new ValueLabelPair( (ValueLabelPair)o ) );
      }
    }
  }

  public boolean isEdited(){
    return ( _values.size() > 0 || _ranges.size() > 0 );
  }

  public void setType( int i ){
    _type = i;
  }
  public int getType(){
    return _type;
  }

  public void setValues( List l ){
    _values = l;
  }

  public void setValue( String s ){
    _values.clear();
    _values.add( s );
  }
  public void addValue( String s ){
    _values.add( s );
  }
  public List getValues(){
    return _values;
  }
  public boolean removeValue( String s ){
    return _values.remove( s );
  }
  public String getValue(){
    if( _values.size() > 1 ){
      throw new IllegalArgumentException( "_values.size() > 1" );
    }
    if( _values.size() == 1 ){
      return (String)_values.get( 0 );
    }
    return null;
  }

  public void addRange( String[] r ){
    _ranges.add( r );
  }
  public List getRanges(){
    return _ranges;
  }
  public boolean removeRange( String[] r ){
    return _ranges.remove( r );
  }

  public String getObjectName(){
    return _objectName;
  }
  public String getObjectLabel(){
    return _objectLabel;
  }
  public String getPropertyName(){
    return _propertyName;
  }
  public String getPropertyLabel(){
    return _propertyLabel;
  }

  public Object clone(){
    return new CriterionValue( this );
  }
  public SearchableObject getSearchableObject(){
    return _so;
  }
  public Attribute getAttribute(){
    return _att;
  }
  public void setSelectAll( boolean b ){
    _selectAll = b;
  }
  public boolean isSelectAll(){
    return _selectAll;
  }

}

