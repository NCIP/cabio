package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.report.Table;

import org.apache.struts.action.ActionForm;

public class FetchValuesForm extends ActionForm {

    private boolean _callingSubAction = false;
    private Table _table = null;
    private String _columnNumber = null;

    public void setCallingSubAction(boolean b) {
        _callingSubAction = b;
    }

    public boolean getCallingSubAction() {
        return _callingSubAction;
    }

    public void setTable(Table t) {
        _table = t;
    }

    public Table getTable() {
        return _table;
    }

    public void setColumnNumber(String s) {
        _columnNumber = s;
    }

    public String getColumnNumber() {
        return _columnNumber;
    }

    public void clear() {
        _callingSubAction = false;
        _table = null;
        _columnNumber = null;
    }
}
