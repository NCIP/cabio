/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.ui.ObjectTree;
import gov.nih.nci.caBIOApp.ui.QueryDesign;
import gov.nih.nci.caBIOApp.ui.ReportDesign;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.DesignReportForm;
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

public class DesignReportAction extends Action {

    private boolean _initialized = false;
    private String _objectTreeEventHandlerName = null;
    private int _maxObjectTreeLevels = -1;
    private String _objectTreeKeyName = null;
    private String _selectedQueryDesignKeyName = null;
    private String _selectedReportDesignKeyName = null;

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!_initialized) {
            initParams(mapping.getPath());
        }
        DesignReportForm form = (DesignReportForm) f;
        WorkflowState state = WorkflowState.getState(request, mapping);
        String lastStep = state.getLastStep();
        String nextStep = state.getNextStep();
        ActionForward forward = mapping.findForward("error");
        /*
         * MessageLog.printInfo( "DesignReportAction.perform(): lastStep = " +
         * lastStep +
         * ", nextStep = " + nextStep );
         */
        if ("displayEditScreen".equals(lastStep)
                || "displayPromptScreen".equals(lastStep)) {
            // The user is currently editing a criterion
            if ("selectColumn".equals(nextStep)) {
                // The user has selected a property from the object tree
                form.selectColumn();
                forward = mapping.findForward("colSpecsEdit");
            }
            else if ("finish".equals(nextStep)) {
                // The user has pressed the done button in the control panel
                HttpSession session = request.getSession();
                session.setAttribute(_selectedReportDesignKeyName,
                    form.getReportDesign());
                if (state.isNested()) {
                    state.popState();
                    MessageLog.printInfo("DesignReportAction: just popped state, action = "
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
            else if ("updateReport".equals(nextStep)) {
                // The user has selected a column from the colSpecEdit panel
                form.updateReport();
                forward = mapping.findForward("colSpecsEdit");
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
            form.setState(state);
            initDisplay(form, request);
            forward = mapping.findForward("reportDesignMain");
        }
        MessageLog.printInfo(mapping.getPath() + ": forwarding to - "
                + forward.getPath());
        return forward;
    }

    private void initParams(String path) throws ServletException {
        AppConfig config = null;
        try {
            config = AppConfig.getInstance();
        }
        catch (Exception ex) {
            throw new ServletException("Unable to get config instance.", ex);
        }
        ActionParams params = config.getActionParams(path);
        _objectTreeEventHandlerName = params.getParam("objectTreeEventHandlerName");
        _objectTreeKeyName = params.getParam("objectTreeKeyName");
        _selectedQueryDesignKeyName = params.getParam("selectedQueryDesignKeyName");
        _selectedReportDesignKeyName = params.getParam("selectedReportDesignKeyName");
        String s = params.getParam("maxObjectTreeLevels");
        try {
            _maxObjectTreeLevels = Integer.parseInt(s);
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("unable to convert " + s + " to int");
        }
    }

    private void initDisplay(DesignReportForm form, HttpServletRequest request)
            throws ServletException {
        HttpSession session = request.getSession();
        ReportDesign rd = (ReportDesign) session.getAttribute(_selectedReportDesignKeyName);
        if (rd == null) {
            throw new ServletException("Coudn't find report design under: "
                    + _selectedReportDesignKeyName);
        }
        QueryDesign qd = rd.getQueryDesign();
        form.setReportDesign(rd);
        String mainObjectName = qd.getRootSearchCriteriaNode().getObjectName();
        ObjectTree objTree = new ObjectTree(mainObjectName,
                _objectTreeEventHandlerName, _maxObjectTreeLevels,
                ObjectTree.DISPLAY_MODE);
        session.setAttribute(_objectTreeKeyName, objTree);
    }
}
