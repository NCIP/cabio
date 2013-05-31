/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.report.Table;
import gov.nih.nci.caBIOApp.ui.ObjectTree;
import gov.nih.nci.caBIOApp.ui.QueryDesign;
import gov.nih.nci.caBIOApp.ui.SearchCriteriaNode;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.DesignQueryForm;
import gov.nih.nci.caBIOApp.util.ActionParams;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class DesignQueryAction extends Action {

    private boolean _initialized = false;
    private String _objectTreeEventHandlerName = null;
    private String _criteriaTreeEventHandlerName = null;
    private int _maxObjectTreeLevels = -1;
    private String _queryDesignKeyName = null;
    private String _objectTreeKeyName = null;
    private String _criteriaTreeKeyName = null;
    private String _fetchValuesActionPath = null;
    private String _selectedTableKeyName = null;
    private String _selectedColumnKeyName = null;

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!_initialized) {
            initParams(mapping.getPath());
        }
        DesignQueryForm form = (DesignQueryForm) f;
        WorkflowState state = WorkflowState.getState(request, mapping);
        String lastStep = state.getLastStep();
        String nextStep = state.getNextStep();
        ActionForward forward = mapping.findForward("error");
        MessageLog.printInfo("DesignQueryAction.perform(): nextStep = "
                + nextStep + ", lastStep = " + lastStep);
        if ("displayPromptScreen".equals(lastStep)) {
            //The user is not currently editing a criterion
            if ("selectCriterion".equals(nextStep)) {
                //The user has selected a property from the object tree
                form.selectCriterion();
                forward = mapping.findForward("criterionEdit");
            }
            else if ("editCriterion".equals(nextStep)) {
                //The user has selected a criterion from the criteria tree
                form.editCriterion();
                forward = mapping.findForward("criterionEdit");
            }
            else if ("finish".equals(nextStep)) {
                //The user has pressed the done button in the control panel
                if (state.isNested()) {
                    state.popState();
                    MessageLog.printInfo("DesignQueryAction: just popped state, action = "
                            + state.getAction()
                            + ", nextStep = "
                            + state.getNextStep()
                            + ", lastStep = "
                            + state.getLastStep());
                    forward = mapping.findForward(state.getAction());
                }
            }
            else if ("toggleMerge".equals(nextStep)) {
                //The user has clicked on the merge icon of a criterion in the criteria tree
                form.toggleMerge();
                HttpSession session = request.getSession();
                session.setAttribute(_criteriaTreeKeyName,
                    form.getQueryDesign().getRootSearchCriteriaNode());
                forward = mapping.findForward("criterionEditPrompt");
            }
            else {
                //throw new ServletException( "unknown operation: " + lastStep +
                //		    " - " + nextStep );
                forward = mapping.findForward("WorkflowException");
            }
        }
        else if ("displayEditScreen".equals(lastStep)) {
            //The user is currently editing a criterion
            if ("fetchValues".equals(nextStep)) {
                //The user wants to use the values in a spreadsheet for this criterion
                if (form.getCallingSubAction()) {
                    //we have already called the sub action
                    form.setCallingSubAction(false);
                    HttpSession session = request.getSession();
                    Table table = (Table) session.getAttribute(_selectedTableKeyName);
                    String colStr = (String) session.getAttribute(_selectedColumnKeyName);
                    if (table != null && colStr != null) {
                        int colNum = -1;
                        try {
                            colNum = Integer.parseInt(colStr);
                        }
                        catch (Exception ex) {
                            throw new ServletException(colStr
                                    + "is not a valid column number");
                        }
                        ActionErrors errors = form.updateCriterion(table,
                            colNum);
                        if (errors.size() > 0) {
                            saveErrors(request, errors);
                        }
                    }
                    forward = mapping.findForward("criterionEdit");
                }
                else {
                    //prepare to call sub action
                    form.setCallingSubAction(true);
                    state.pushState();
                    forward = mapping.findForward(_fetchValuesActionPath);
                }
            }
            else if ("cancelEdit".equals(nextStep)) {
                //The user does not want to commit the changes
                form.cancelEdit();
                forward = mapping.findForward("criterionEditPrompt");
            }
            else if ("deleteCriterion".equals(nextStep)) {
                //The user wants to remove the current criterion from the criteria tree
                form.deleteCriterion();
                HttpSession session = request.getSession();
                session.setAttribute(_criteriaTreeKeyName,
                    form.getQueryDesign().getRootSearchCriteriaNode());
                forward = mapping.findForward("criterionEditPrompt");
            }
            else if ("updateCriterion".equals(nextStep)) {
                //The user wants to make changes to the current criterion
                ActionErrors errors = form.updateCriterion();
                if (errors.size() > 0) {
                    saveErrors(request, errors);
                }
                forward = mapping.findForward("criterionEdit");
            }
            else if ("updateCriteria".equals(nextStep)) {
                //The user wants to add the current criterion to the criteria tree
                form.updateCriteria();
                HttpSession session = request.getSession();
                session.setAttribute(_criteriaTreeKeyName,
                    form.getQueryDesign().getRootSearchCriteriaNode());
                forward = mapping.findForward("criterionEditPrompt");
            }
            else {
                //throw new ServletException( "unknown operation: " + nextStep );
                forward = mapping.findForward("WorkflowException");
            }
        }
        else if ("displaySummaryScreen".equals(lastStep)) {
            forward = mapping.findForward("criteriaSummary");
        }
        else {
            form.setState(state);
            initDisplay(form, request);
            forward = mapping.findForward("queryDesignMain");
        }
        MessageLog.printInfo(mapping.getPath() + ": forwarding to - "
                + forward.getPath());
        return forward;
    }//-- end perform(...

    private void initDisplay(DesignQueryForm form, HttpServletRequest request)
            throws ServletException {
        HttpSession session = request.getSession();
        QueryDesign design = (QueryDesign) session.getAttribute(_queryDesignKeyName);
        if (design == null) {
            throw new ServletException("QueryDesign not found under "
                    + _queryDesignKeyName);
        }
        String objectName = design.getObjectName();
        //Create the object tree display
        ObjectTree objTree = new ObjectTree(objectName,
                _objectTreeEventHandlerName, _maxObjectTreeLevels,
                ObjectTree.QUERY_MODE);
        form.setObjectTree(objTree);
        form.setQueryDesign(design);
        form.setCriteriaTreeEventHandlerName(_criteriaTreeEventHandlerName);
        //make the trees accessible to their respective handlers.
        SearchCriteriaNode criteriaTree = design.getRootSearchCriteriaNode();
        session.setAttribute(_objectTreeKeyName, objTree);
        session.setAttribute(_criteriaTreeKeyName, criteriaTree);
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
        _criteriaTreeEventHandlerName = params.getParam("criteriaTreeEventHandlerName");
        String s = params.getParam("maxObjectTreeLevels");
        try {
            _maxObjectTreeLevels = Integer.parseInt(s);
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("unable to convert " + s + " to int");
        }
        _queryDesignKeyName = params.getParam("queryDesignKeyName");
        _objectTreeKeyName = params.getParam("objectTreeKeyName");
        _criteriaTreeKeyName = params.getParam("criteriaTreeKeyName");
        _fetchValuesActionPath = params.getParam("fetchValuesActionPath");
        //get params relating to subaction
        ActionParams subParams = config.getActionParams(_fetchValuesActionPath);
        _selectedTableKeyName = subParams.getParam("selectedTableKeyName");
        _selectedColumnKeyName = subParams.getParam("selectedColumnKeyName");
        _initialized = true;
    }
}
