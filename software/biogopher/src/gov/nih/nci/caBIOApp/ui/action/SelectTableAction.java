package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.report.Table;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.SelectTableForm;
import gov.nih.nci.caBIOApp.util.ActionParams;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class SelectTableAction extends Action {

    private boolean _initialized = false;
    private String _cachedTablesKeyName = null;
    private String _selectedTableKeyName = null;
    private String _allowSelectionKeyName = null;
    private String _allowUploadKeyName = null;

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!_initialized) {
            initParams(mapping.getPath());
        }
        SelectTableForm form = (SelectTableForm) f;
        WorkflowState state = WorkflowState.getState(request, mapping);
        String lastStep = state.getLastStep();
        String nextStep = state.getNextStep();
        ActionForward forward = mapping.findForward("error");
        HttpSession session = request.getSession();
        // MessageLog.printInfo( "SelectTableAction.perform(): lastStep = " +
        // lastStep + ", nextStep = " + nextStep );
        if ("displayAvailableTables".equals(lastStep)) {
            if ("upload".equals(nextStep)) {
                ActionErrors errors = form.addTable();
                if (errors.size() > 0) {
                    request.setAttribute(Action.ERROR_KEY, errors);
                }
                forward = mapping.findForward("displayAvailableTables");
            }
            else if ("finish".equals(nextStep)) {
                form.selectTable();
                Table t = form.getSelectedTable();
                if (t != null) {
                    session.setAttribute(_selectedTableKeyName,
                        form.getSelectedTable());
                }
                else {
                    session.removeAttribute(_selectedTableKeyName);
                }
                if (state.isNested()) {
                    state.popState();
                    MessageLog.printInfo("SelectTableAction: just popped state, action = "
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
            else {
                // throw new ServletException( "unknown operation: " + lastStep
                // +
                // " - " + nextStep );
                forward = mapping.findForward("WorkflowException");
            }
        }
        else {
            form.clear();
            initDisplay(form, request);
            forward = mapping.findForward("displayAvailableTables");
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
            _cachedTablesKeyName = params.getParam("cachedTablesKeyName");
            _allowSelectionKeyName = params.getParam("allowSelectionKeyName");
            _allowUploadKeyName = params.getParam("allowUploadKeyName");
            _initialized = true;
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error initializing", ex);
        }
    }

    private void initDisplay(SelectTableForm form, HttpServletRequest request)
            throws ServletException {
        HttpSession session = request.getSession();
        List cachedTables = (List) session.getAttribute(_cachedTablesKeyName);
        if (cachedTables == null) {
            cachedTables = new ArrayList();
            session.setAttribute(_cachedTablesKeyName, cachedTables);
        }
        form.setCachedTables(cachedTables);
        form.setAllowSelection("true".equals((String) session.getAttribute(_allowSelectionKeyName)));
        form.setAllowUpload("true".equals((String) session.getAttribute(_allowUploadKeyName)));
        MessageLog.printInfo("SelectTableAction.initDisplay(): allow selection = "
                + form.getAllowSelection()
                + ", allow upload = "
                + form.getAllowUpload());
    }
}
