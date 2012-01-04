package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.report.Table;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.FetchValuesForm;
import gov.nih.nci.caBIOApp.util.ActionParams;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class FetchValuesAction extends Action {

    private boolean _initialized = false;
    private String _selectedTableKeyName = null;
    private String _subSelectedTableKeyName = null;
    private String _selectedColumnKeyName = null;
    private String _selectTableActionPath = null;
    private String _allowSelectionKeyName = null;
    private String _allowUploadKeyName = null;

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!_initialized) {
            initParams(mapping.getPath());
        }
        FetchValuesForm form = (FetchValuesForm) f;
        WorkflowState state = WorkflowState.getState(request, mapping);
        String lastStep = state.getLastStep();
        String nextStep = state.getNextStep();
        ActionForward forward = mapping.findForward("error");
        HttpSession session = request.getSession();
        if (form.getCallingSubAction()) {
            form.setCallingSubAction(false);
            Table t = (Table) session.getAttribute(_subSelectedTableKeyName);
            if (t != null) {
                form.setTable(t);
                forward = mapping.findForward("displayColumnSelection");
            }
            else {
                forward = pop(state, mapping);
            }
        }
        else if ("displayColumnSelection".equals(lastStep)) {
            if ("finish".equals(nextStep)) {
                Table t = form.getTable();
                String colNum = form.getColumnNumber();
                if (t != null && colNum != null) {
                    session.setAttribute(_selectedTableKeyName, t);
                    session.setAttribute(_selectedColumnKeyName, colNum);
                }
                else {
                    session.removeAttribute(_selectedTableKeyName);
                    session.removeAttribute(_selectedColumnKeyName);
                }
                forward = pop(state, mapping);
            }
            else {
                MessageLog.printError("FetchValuesAction: unknown operation "
                        + lastStep + " - " + nextStep);
                forward = mapping.findForward("WorkflowException");
            }
        }
        else {
            form.clear();
            session.setAttribute(_allowSelectionKeyName, "true");
            session.setAttribute(_allowUploadKeyName, "false");
            form.setCallingSubAction(true);
            state.pushState();
            forward = mapping.findForward(_selectTableActionPath);
        }
        MessageLog.printInfo(mapping.getPath() + ": forwarding to - "
                + (forward == null ? "null" : forward.getPath()));
        return forward;
    }

    private void initParams(String path) throws ServletException {
        try {
            AppConfig config = AppConfig.getInstance();
            ActionParams params = config.getActionParams(path);
            _selectedTableKeyName = params.getParam("selectedTableKeyName");
            _selectedColumnKeyName = params.getParam("selectedColumnKeyName");
            _selectTableActionPath = params.getParam("selectTableActionPath");
            ActionParams stParams = config.getActionParams(_selectTableActionPath);
            _subSelectedTableKeyName = stParams.getParam("selectedTableKeyName");
            _allowSelectionKeyName = stParams.getParam("allowSelectionKeyName");
            _allowUploadKeyName = stParams.getParam("allowUploadKeyName");
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error initializing", ex);
        }
    }

    private ActionForward pop(WorkflowState state, ActionMapping mapping)
            throws ServletException {
        ActionForward forward = null;
        try {
            if (state.isNested()) {
                state.popState();
                MessageLog.printInfo("FetchValuesAction: just popped state, action = "
                        + state.getAction()
                        + ", nextStep = "
                        + state.getNextStep()
                        + ", lastStep = "
                        + state.getLastStep());
                forward = mapping.findForward(state.getAction());
            }
            else {
                forward = mapping.findForward("default");
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error popping", ex);
        }
        return forward;
    }
}
