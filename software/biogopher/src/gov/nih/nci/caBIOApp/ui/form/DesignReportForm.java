/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.ui.ColumnSpecification;
import gov.nih.nci.caBIOApp.ui.ReportDesign;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.List;

import javax.servlet.ServletException;

import org.apache.struts.action.ActionForm;

public class DesignReportForm extends ActionForm {

    private ReportDesign _reportDesign = null;
    private WorkflowState _state = null;
    private String _selectedColumnId = null;
    private String _columnId = null;
    private String _updateOperationName = null;
    private ColumnSpecification _selectedColSpec = null;
    private String _newColumnName = null;

    public void setState(WorkflowState s) {
        _state = s;
    }

    public WorkflowState getState() {
        return _state;
    }

    public void setSelectedColumnId(String s) {
        MessageLog.printInfo("DesignReportForm.setSelectedColumnId(): " + s);
        _selectedColumnId = s;
    }

    public String getSelectedColumnId() {
        return _selectedColumnId;
    }

    public void setColumnId(String s) {
        _columnId = s;
    }

    public String getColumnId() {
        return _columnId;
    }

    public void setUpdateOperationName(String s) {
        _updateOperationName = s;
    }

    public String getUpdateOperationName() {
        return _updateOperationName;
    }

    public void selectColumn() throws ServletException {
        if (_selectedColumnId == null) {
            throw new ServletException("no column id selected");
        }
        try {
            _selectedColSpec = _reportDesign.selectColumn(_selectedColumnId);
        }
        catch (Exception ex) {
            throw new ServletException("error selecting column", ex);
        }
    }

    public void setReportDesign(ReportDesign rd) {
        _reportDesign = rd;
    }

    public ReportDesign getReportDesign() {
        return _reportDesign;
    }

    public void updateReport() throws ServletException {
        _selectedColumnId = _columnId;
        selectColumn();
        try {
            if ("moveLeft".equals(_updateOperationName)) {
                int newColNum = _selectedColSpec.getNewColumnNumber() - 1;
                MessageLog.printInfo("DesignReportForm.updateReport(): movingLeft to colNum "
                        + newColNum);
                if (newColNum > -1) {
                    _selectedColSpec.setNewColumnNumber(newColNum);
                    _reportDesign.updateColumn(_selectedColSpec);
                }
            }
            else if ("moveRight".equals(_updateOperationName)) {
                int numCols = ((List) _reportDesign.getColumnSpecifications()).size();
                int newColNum = _selectedColSpec.getNewColumnNumber() + 1;
                MessageLog.printInfo("DesignReportForm.updateReport(): movingRight to colNum "
                        + newColNum + ", and numCols == " + numCols);
                if (newColNum < numCols) {
                    _selectedColSpec.setNewColumnNumber(newColNum);
                    _reportDesign.updateColumn(_selectedColSpec);
                }
            }
            else if ("rename".equals(_updateOperationName)) {
                _selectedColSpec.setNewColumnTitle(_newColumnName);
                _reportDesign.updateColumn(_selectedColSpec);
            }
            else if ("remove".equals(_updateOperationName)) {
                _reportDesign.removeColumn(_selectedColSpec);
            }
            else {
                throw new ServletException("unknown operation: "
                        + _updateOperationName);
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error updating column", ex);
        }
    }

    public void clear() {
        _reportDesign = null;
    }

    public boolean isSummaryToBeRefreshed() {
        return true;
    }

    public void setNewColumnName(String s) {
        _newColumnName = s;
    }

    public String getNewColumnName() {
        return _newColumnName;
    }
}
