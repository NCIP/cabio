/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionMapping;

public class WorkflowState implements Serializable {

    public static final boolean _debug = false;
    private String _action = null;
    private LinkedList _actions = new LinkedList();
    private LinkedList _steps = new LinkedList();
    private LinkedList _states = new LinkedList();
    private HashMap _state = null;
    private String _lastStep = null;
    private String _nextStep = null;
    private boolean _populate = true;

    public void setPopulate(boolean b) {
        _populate = b;
    }

    public boolean getPopulate() {
        return _populate;
    }

    public void setLastStep(String s) {
        if (_debug) MessageLog.printInfo("WorkflowState.setLastStep(): " + s);
        _lastStep = s;
    }

    public String getLastStep() {
        if (_lastStep != null) {
            return new String(_lastStep);
        }
        else {
            return null;
        }
    }

    public void setNextStep(String s) {
        if (_debug) MessageLog.printInfo("WorkflowState.setNextStep(): " + s);
        _nextStep = s;
    }

    public String getNextStep() {
        if (_nextStep != null) {
            return new String(_nextStep);
        }
        else {
            return null;
        }
    }

    private void pushSteps() {
        String l = null;
        if (_lastStep != null) l = new String(_lastStep);
        String n = null;
        if (_nextStep != null) n = new String(_nextStep);
        String[] s = new String[] { l, n };
        _steps.addLast(s);
        _lastStep = _nextStep = null;
    }

    private void popSteps() {
        _lastStep = _nextStep = null;
        if (!_steps.isEmpty()) {
            String[] s = (String[]) _steps.removeLast();
            _lastStep = s[0];
            _nextStep = s[1];
        }
    }

    public void setAction(String s) {
        _action = s;
    }

    public String getAction() {
        if (_action != null) {
            return new String(_action);
        }
        else {
            return null;
        }
    }

    private void pushAction() {
        if (_action == null) {
            throw new IllegalStateException("action has not been set");
        }
        pushSteps();
        _actions.addLast(new String(_action));
        _action = null;
    }

    private void popAction() {
        if (_actions.isEmpty()) {
            throw new IllegalStateException("action stack is empty");
        }
        popSteps();
        _action = (String) _actions.removeLast();
    }

    public String getRootAction() {
        String a = null;
        if (!_actions.isEmpty()) {
            String s = (String) _actions.getFirst();
            if (s != null) a = new String(s);
        }
        return a;
    }

    public String getAction(int idx) {
        if (idx > 0) {
            throw new IllegalArgumentException(
                    "action index must be negative or zero");
        }
        String a = null;
        if (!_actions.isEmpty()) {
            try {
                int negIdx = _actions.size() - 1 + idx;
                String s = (String) _actions.get(negIdx);
                if (s != null) a = new String(s);
            }
            catch (IndexOutOfBoundsException ex) {
                // nothing, return null
            }
        }
        return a;
    }

    public void pushState() {
        pushSteps();
        pushAction();
        _states.addLast(_state);
        _populate = true;
    }

    public void popState() {
        if (_states.isEmpty()) {
            throw new IllegalStateException("state stack is empty");
        }
        popSteps();
        popAction();
        _state = (HashMap) _states.removeLast();
        _populate = false;
    }

    public void setState(HashMap m) {
        _state = m;
    }

    public HashMap getState() {
        return _state;
    }

    public boolean isNested() {
        return !_states.isEmpty();
    }

    public void reset() {
        _action = _lastStep = _nextStep = null;
    }

    public void set(String key, Object o) {
        _state.put(key, o);
    }

    public Object get(String key) {
        return _state.get(key);
    }

    public static WorkflowState getState(HttpServletRequest request,
            ActionMapping mapping) {
        HttpSession session = request.getSession();
        WorkflowState state = (WorkflowState) session.getAttribute(UIConstants.WORKFLOW_STATE_KEY);
        if (state == null) {
            if (_debug) {
                MessageLog.printInfo("WorkflowState: creating new state");
            }
            state = new WorkflowState();
            session.setAttribute(UIConstants.WORKFLOW_STATE_KEY, state);
        }
        String thisAction = mapping.getPath();
        if (_debug) {
            MessageLog.printInfo("WorkflowState: mapping.getPath() = "
                    + mapping.getPath() + ", state.getAction() = "
                    + state.getAction());
        }
        if (thisAction.equals(state.getAction())) {
            if (_debug) {
                MessageLog.printInfo("WorkflowState: within same action...");
            }
            if (state.getPopulate()) {
                if (_debug) {
                    MessageLog.printInfo("WorkflowState: populating...");
                }
                state.setNextStep(request.getParameter(UIConstants.NEXT_STEP_KEY));
                state.setLastStep(request.getParameter(UIConstants.LAST_STEP_KEY));
            }
            state.setPopulate(true);
        }
        else {
            if (_debug) {
                MessageLog.printInfo("WorkflowState: resetting...");
            }
            state.reset();
            state.setAction(thisAction);
        }
        return state;
    }

    public boolean isCurrentStep(String step) {
        MessageLog.printInfo("WorkflowState.isCurrentStep()");
        boolean b = false;
        for (Iterator i = _actions.iterator(); i.hasNext();) {
            String actionName = (String) i.next();
            MessageLog.printInfo("   " + actionName + " - " + step);
            if (actionName.indexOf(step) != -1) {
                b = true;
            }
        }
        return b;
    }
}
