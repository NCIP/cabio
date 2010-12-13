package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;

import java.util.*;
import java.io.*;
import javax.servlet.*;

import org.apache.struts.action.*;
import org.apache.struts.upload.*;

public class TestQueryForm extends ActionForm{

  private FormFile _uploadedFile = null;
  private String _operation = null;

  public void setUploadedFile( FormFile f ){
    _uploadedFile = f;
  }
  public FormFile getUploadedFile(){
    return _uploadedFile;
  }
  public void setOperation( String s ){
    _operation = s;
  }
  public String getOperation(){
    return _operation;
  }
  public void reset(){
    if( _uploadedFile != null ){
      _uploadedFile.destroy();
    }
    _uploadedFile = null;
  }
}
