package gov.nih.nci.caBIOApp.ui.action;

import gov.nih.nci.caBIOApp.ui.WorkflowState;
import gov.nih.nci.caBIOApp.ui.form.WorkflowExceptionForm;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class WorkflowExceptionAction extends Action {

    public ActionForward perform(ActionMapping mapping, ActionForm f,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        WorkflowExceptionForm form = (WorkflowExceptionForm) f;
        form.setState(WorkflowState.getState(request, mapping));
        ActionForward forward = mapping.findForward("displayError");
        MessageLog.printInfo(mapping.getPath() + ": forwarding to - "
                + forward.getPath());
        return forward;
    }
}
