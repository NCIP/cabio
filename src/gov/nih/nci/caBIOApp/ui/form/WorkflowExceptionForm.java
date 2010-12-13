package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.ui.*;

import org.apache.struts.action.*;

public class WorkflowExceptionForm extends ActionForm{
  private WorkflowState _state = null;
  public void setState( WorkflowState ws ){
    _state = ws;
  }
  public WorkflowState getState(){
    return _state;
  }
}
