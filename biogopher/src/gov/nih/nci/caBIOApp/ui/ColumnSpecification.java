package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.sod.Attribute;
import gov.nih.nci.caBIOApp.sod.SODUtils;
import gov.nih.nci.caBIOApp.sod.SearchableObject;

public class ColumnSpecification {

    private String _id = null;
    private int _oldColumnNumber = -1;
    private int _newColumnNumber = -1;
    private String _oldColumnTitle = null;
    private String _newColumnTitle = null;
    private boolean _isMapped = false;
    private boolean _isMergeColumn = false;
    private String _objectName = null;
    private String _objectLabel = null;
    private String _attributeName = null;
    private String _attributeLabel = null;
    private boolean _isNewColumn = false;
    // private SearchableObjectsDescription _sod = null;
    private SODUtils _sod = null;
    // private String _label = null;
    private String _path = null;
    private boolean _active = false;

    public ColumnSpecification() {
        init();
    }

    public ColumnSpecification(String objectName, String attributeName)
            throws InvalidSpecificationException {
        init();
        // SearchableObject so = SODUtils.getSearchableObject( _sod, objectName
        // );
        SearchableObject so = _sod.getSearchableObject(objectName);
        if (so == null) {
            throw new InvalidSpecificationException(
                    "SearchableObject not found for: " + objectName);
        }
        Attribute att = _sod.getAttribute(so, attributeName);
        if (att == null) {
            throw new InvalidSpecificationException("Attribute not found for: "
                    + attributeName);
        }
        _objectName = so.getClassname();
        _attributeName = att.getName();
        _id = _objectName + "." + attributeName;
        _newColumnTitle = so.getLabel() + " " + att.getLabel();
        _objectLabel = so.getLabel();
        _attributeLabel = att.getLabel();
        _isNewColumn = true;
        _isMapped = true;
        // _label = _objectLabel + " " + _attributeLabel;
    }

    public ColumnSpecification(ColumnSpecification origSpec)
            throws InvalidSpecificationException {
        if (origSpec == null) {
            throw new InvalidSpecificationException("specification is null");
        }
        _id = origSpec.getId();
        _path = origSpec.getPath();
        _oldColumnNumber = origSpec.getOldColumnNumber();
        _newColumnNumber = origSpec.getNewColumnNumber();
        _oldColumnTitle = origSpec.getOldColumnTitle();
        _newColumnTitle = origSpec.getNewColumnTitle();
        _isMapped = origSpec.isMapped();
        _isMergeColumn = origSpec.isMergeColumn();
        _objectName = origSpec.getObjectName();
        _objectLabel = origSpec.getObjectLabel();
        _attributeName = origSpec.getAttributeName();
        _attributeLabel = origSpec.getAttributeLabel();
        _isNewColumn = origSpec.isNewColumn();
        _active = origSpec.isActive();
        // _sod = origSpec.getSOD();
        // _label = origSpec.getLabel();
    }

    private void init() {
        _sod = SODUtils.getInstance();
    }

    /**
     * Gets the value of id
     * 
     * @return the value of id
     */
    public String getId() {
        return this._id;
    }

    /**
     * Sets the value of id
     * 
     * @param argId Value to assign to this.id
     */
    public void setId(String argId) {
        this._id = argId;
    }

    /**
     * Gets the value of oldColumnNumber
     * 
     * @return the value of oldColumnNumber
     */
    public int getOldColumnNumber() {
        return this._oldColumnNumber;
    }

    /**
     * Sets the value of oldColumnNumber
     * 
     * @param argOldColumnNumber Value to assign to this._oldColumnNumber
     */
    public void setOldColumnNumber(int argOldColumnNumber) {
        this._oldColumnNumber = argOldColumnNumber;
    }

    /**
     * Gets the value of newColumnNumber
     * 
     * @return the value of newColumnNumber
     */
    public int getNewColumnNumber() {
        return this._newColumnNumber;
    }

    /**
     * Sets the value of newColumnNumber
     * 
     * @param argNewColumnNumber Value to assign to this._newColumnNumber
     */
    public void setNewColumnNumber(int argNewColumnNumber) {
        this._newColumnNumber = argNewColumnNumber;
    }

    /**
     * Gets the value of oldColumnTitle
     * 
     * @return the value of oldColumnTitle
     */
    public String getOldColumnTitle() {
        return this._oldColumnTitle;
    }

    /**
     * Sets the value of oldColumnTitle
     * 
     * @param argOldColumnTitle Value to assign to this._oldColumnTitle
     */
    public void setOldColumnTitle(String argOldColumnTitle) {
        this._oldColumnTitle = argOldColumnTitle;
    }

    /**
     * Gets the value of newColumnTitle
     * 
     * @return the value of newColumnTitle
     */
    public String getNewColumnTitle() {
        return this._newColumnTitle;
    }

    /**
     * Sets the value of newColumnTitle
     * 
     * @param argNewColumnTitle Value to assign to this._newColumnTitle
     */
    public void setNewColumnTitle(String argNewColumnTitle) {
        this._newColumnTitle = argNewColumnTitle;
    }

    /**
     * Gets the value of isMapped
     * 
     * @return the value of isMapped
     */
    public boolean isMapped() {
        return this._isMapped;
    }

    /**
     * Sets the value of isMapped
     * 
     * @param argIsMapped Value to assign to this._isMapped
     */
    public void setIsMapped(boolean argIsMapped) {
        this._isMapped = argIsMapped;
    }

    /**
     * Gets the value of isMergeColumn
     * 
     * @return the value of isMergeColumn
     */
    public boolean isMergeColumn() {
        return this._isMergeColumn;
    }

    /**
     * Sets the value of isMergeColumn
     * 
     * @param argIsMergeColumn Value to assign to this._isMergeColumn
     */
    public void setIsMergeColumn(boolean argIsMergeColumn) {
        this._isMergeColumn = argIsMergeColumn;
    }

    /**
     * Gets the value of objectName
     * 
     * @return the value of objectName
     */
    public String getObjectName() {
        return this._objectName;
    }

    /**
     * Sets the value of objectName
     * 
     * @param argObjectName Value to assign to this._objectName
     */
    public void setObjectName(String argObjectName) {
        this._objectName = argObjectName;
    }

    /**
     * Gets the value of objectLabel
     * 
     * @return the value of objectLabel
     */
    public String getObjectLabel() {
        return this._objectLabel;
    }

    /**
     * Sets the value of objectLabel
     * 
     * @param argObjectLabel Value to assign to this._objectLabel
     */
    public void setObjectLabel(String argObjectLabel) {
        this._objectLabel = argObjectLabel;
    }

    /**
     * Gets the value of attributeName
     * 
     * @return the value of attributeName
     */
    public String getAttributeName() {
        return this._attributeName;
    }

    /**
     * Sets the value of attributeName
     * 
     * @param argAttributeName Value to assign to this._attributeName
     */
    public void setAttributeName(String argAttributeName) {
        this._attributeName = argAttributeName;
    }

    /**
     * Gets the value of attributeLabel
     * 
     * @return the value of attributeLabel
     */
    public String getAttributeLabel() {
        return this._attributeLabel;
    }

    /**
     * Sets the value of attributeLabel
     * 
     * @param argAttributeLabel Value to assign to this._attributeLabel
     */
    public void setAttributeLabel(String argAttributeLabel) {
        this._attributeLabel = argAttributeLabel;
    }

    /**
     * Gets the value of isNewColumn
     * 
     * @return the value of isNewColumn
     */
    public boolean isNewColumn() {
        return this._isNewColumn;
    }

    /**
     * Sets the value of isNewColumn
     * 
     * @param argIsNewColumn Value to assign to this._isNewColumn
     */
    public void setIsNewColumn(boolean argIsNewColumn) {
        this._isNewColumn = argIsNewColumn;
    }

    /*
     * SearchableObjectsDescription getSOD(){ return _sod; }
     */
    public boolean equals(Object o) {
        boolean eq = false;
        if (o != null && o instanceof ColumnSpecification) {
            ColumnSpecification aColSpec = (ColumnSpecification) o;
            if (aColSpec.getId() != null && aColSpec.getId().equals(_id)) {
                eq = true;
            }
        }
        return eq;
    }

    public int hashCode() {
        int c = 0;
        if (_id != null) c = _id.hashCode();
        return c;
    }

    /*
     * public String getLabel(){ return _label; } public void setLabel( String s
     * ){ _label = s; }
     */
    public void setPath(String s) {
        _path = s;
    }

    public String getPath() {
        return _path;
    }

    public void setActive(boolean b) {
        _active = b;
    }

    public boolean isActive() {
        return _active;
    }
}
