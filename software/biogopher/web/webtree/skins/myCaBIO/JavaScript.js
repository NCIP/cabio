// EvsTreeScript.js
// Supporting Javascript functions for the EVS Data Tree
//
// Aug-2002 : Marc Piparo (SAIC - Celebration, FL)
//

// optional confirm selection, selects concept with confirmation and calls setSelection()
function confirmSelection(formName, treeType, value, code, parent, displayName)
{ 
  var confirmationMessage;
  if (parent == true)
  {
    confirmationMessage = "Confirm Selection: \""+displayName+"\"\n\nMore specific data exists for the term you selected.\n\nClick \"OK\" to select this general term, or \nClick \"Cancel\" to continue searching for a more specific term.";
  }
  else
  { 
    confirmationMessage = "Confirm Selection: \""+displayName+"\"\n\nClick \"OK\" to select this term, or \nClick \"Cancel\" to continue searching for another term.";  
  }
	var confirmation = confirm(confirmationMessage);
	if (confirmation == true)
	{
		setSelection(formName, treeType, value, code, displayName);
	}
}

// sets selection of concept
function setSelection(formName, treeType, value, code, displayName)
{
  var form;
  if (formName != null) form = top.opener.document.forms[formName]; else alert("formName is null, a formName must be specified");
  if (form == null) alert("Form not found!\nformName = "+formName);

  if (treeType == 'tissue')
  {  
    setOrganSelection(code, value, form, displayName);
  }
  else
  {
    setDiagnosisSelection(code, value, form, displayName);
  }
}

// sets organ/tissue (called by setSelect())
function setOrganSelection(id, value, form, displayName)
{
  if (form.organ) form.organ.value = displayName;
  if (form.organTissueName) form.organTissueName.value = value;
  if (form.organTissueCode) form.organTissueCode.value = id;

  // reset diagnosis
  if (form.TumorClassification) form.TumorClassification.value = " ";
  if (form.DiagnosisName) form.DiagnosisName.value = " ";
  if (form.DiagnosisCode) form.DiagnosisCode.value = " "; 
  top.close();  
}

// sets diagnosis (called by setSelect())
function setDiagnosisSelection(id, value, form, displayName)
{
  form.TumorClassification.value = displayName;
  form.DiagnosisName.value = value;
  form.DiagnosisCode.value = id;
  top.close();
}

function setManualDiagnosis(formName)
{ 
  var reply = window.prompt("Enter your diagnosis below:", "");
  if (reply != null && reply != "")
  {
    setSelection(formName, "diagnosis", reply, "C000000", reply);
  }
}


