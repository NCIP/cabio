/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.ui.QueryDesign;
import gov.nih.nci.caBIOApp.ui.ReportDesign;
import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.CreateReportForm;
import gov.nih.nci.caBIOApp.util.ActionParams;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class CreateReportAction extends Action {

    private boolean _initialized = false;
    private String _designReportActionPath = null;
    private String _queryDesignKeyName = null;
    private String _queryDesignsKeyName = null;
    private String _reportDesignKeyName = null;
    private String _reportDesignsKeyName = null;

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!_initialized) {
            initParams(mapping.getPath());
        }
        CreateReportForm form = (CreateReportForm) f;
        WorkflowState state = WorkflowState.getState(request, mapping);
        String lastStep = state.getLastStep();
        String nextStep = state.getNextStep();
        ActionForward forward = mapping.findForward("error");
        HttpSession session = request.getSession();
        if (form.getCallingSubAction()) {
            form.setCallingSubAction(false);
            ReportDesign rd = (ReportDesign) session.getAttribute(_reportDesignKeyName);
            if (rd != null) {
                session.setAttribute(_reportDesignKeyName, rd);
            }
            forward = prepareToFinish(state, mapping);
        }
        else if ("displaySelection".equals(lastStep)) {
            if ("cancel".equals(nextStep)) {
                forward = prepareToFinish(state, mapping);
            }
            else if ("rename".equals(nextStep)) {
                form.rename();
                forward = mapping.findForward("displaySelection");
            }
            else if ("remove".equals(nextStep)) {
                form.remove();
                forward = mapping.findForward("displaySelection");
            }
            else {
                ReportDesign rd = null;
                if ("create".equals(nextStep)) {
                    rd = form.create();
                }
                else if ("select".equals(nextStep)) {
                    rd = form.select();
                }
                else {
                    throw new ServletException("Unknown action: " + lastStep
                            + " - " + nextStep);
                }
                MessageLog.printInfo("CreateReportAction.perform(): setting report design under "
                        + _reportDesignKeyName);
                session.setAttribute(_reportDesignKeyName, rd);
                form.setCallingSubAction(true);
                state.pushState();
                forward = mapping.findForward(_designReportActionPath);
            }
            /*
            }else{
            ReportDesign rd = form.getSelectedReportDesign();
            MessageLog.printInfo( "CreateReportAction.perform(): setting report design under " +
            	      _reportDesignKeyName );
            session.setAttribute( _reportDesignKeyName, rd );
            form.setCallingSubAction( true );
            state.pushState();
            forward = mapping.findForward( _designReportActionPath );
            }
            */
        }
        else {
            initDisplay(session, form);
            forward = mapping.findForward("displaySelection");
        }
        MessageLog.printInfo(mapping.getPath() + ": forwarding to - "
                + (forward == null ? "null" : forward.getPath()));
        return forward;
    }

    public void initDisplay(HttpSession session, CreateReportForm form)
            throws ServletException {
        //MessageLog.printInfo( "CreateReportAction.initDisplay()" );
        HashMap qds = (HashMap) session.getAttribute(_queryDesignsKeyName);
        if (qds == null) {
            qds = new HashMap();
            session.setAttribute(_queryDesignsKeyName, qds);
        }
        form.setQueryDesigns(qds);
        HashMap rds = (HashMap) session.getAttribute(_reportDesignsKeyName);
        if (rds == null) {
            rds = new HashMap();
            session.setAttribute(_reportDesignsKeyName, rds);
        }
        form.setReportDesigns(rds);
        QueryDesign qd = (QueryDesign) session.getAttribute(_queryDesignKeyName);
        if (qd != null) {
            form.setSelectedQueryDesignId(qd.getId());
        }
        ReportDesign rd = (ReportDesign) session.getAttribute(_reportDesignKeyName);
        if (rd != null) {
            form.setSelectedReportDesignId(rd.getId());
        }
    }

    public void initParams(String path) throws ServletException {
        //MessageLog.printInfo( "CreateReportAction.initParams()" );
        try {
            AppConfig config = AppConfig.getInstance();
            ActionParams myParams = config.getActionParams(path);
            _designReportActionPath = myParams.getParam("designReportActionPath");
            _queryDesignsKeyName = myParams.getParam("queryDesignsKeyName");
            _reportDesignsKeyName = myParams.getParam("reportDesignsKeyName");
            ActionParams dqParams = config.getActionParams(_designReportActionPath);
            _queryDesignKeyName = dqParams.getParam("selectedQueryDesignKeyName");
            _reportDesignKeyName = dqParams.getParam("selectedReportDesignKeyName");
            _initialized = true;
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error initializing", ex);
        }
    }

    private ActionForward prepareToFinish(WorkflowState state,
            ActionMapping mapping) {
        ActionForward forward = null;
        if (state.isNested()) {
            state.popState();
            MessageLog.printInfo("CreateQueryAction: just popped state, action = "
                    + state.getAction()
                    + ", nextStep = "
                    + state.getNextStep()
                    + ", lastStep = " + state.getLastStep());
            forward = mapping.findForward(state.getAction());
        }
        else {
            forward = mapping.findForward("default");
        }
        return forward;
    }
}
