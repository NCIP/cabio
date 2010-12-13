package gov.nih.nci.caBIOApp.ui;

public class ValueLabelPair{

    protected String _label;
    protected String _value;

    public ValueLabelPair( String value, String label ){
	this._label = label;
	this._value = value;
    }

  public ValueLabelPair( ValueLabelPair orig ){
    _label = new String( orig.getLabel() );
    _value = new String( orig.getValue() );
  }

    public void setLabel( String label ){
	this._label = label;
    }
    public String getLabel(){
	return _label;
    }

    public void setValue( String value ){
	this._value = value;
    }
    public String getValue(){
	return _value;
    }

    public boolean equals( Object o ){
	boolean eq = false;
	if( o != null && o instanceof ValueLabelPair ){
	    String v = ((ValueLabelPair)o).getValue();
	    if( v != null && v.equals( _value ) ){
		eq = true;
	    }
	}
	return eq;
    }

    public int hashCode(){
	int c = 0;
	if( _value != null ) c = _value.hashCode();
	return c;
    }

}
