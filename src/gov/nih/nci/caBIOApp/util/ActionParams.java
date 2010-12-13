package gov.nih.nci.caBIOApp.util;

import java.util.*;

public class ActionParams extends HashMap{

  private String _actionName = null;

  public void setPath( String s ){
    //MessageLog.printInfo( "ActionParams.setPath(): path = " + s );
    _actionName = s;
  }
  public String getPath(){
    return _actionName;
  }

  public void addParam( String paramName, String paramValue ){
    //MessageLog.printInfo( "ActionParams.addParam(): path = " + _actionName +
    //		  ", name = " + paramName + ", value = " + paramValue );
    put( paramName, paramValue );
  }
  public String getParam( String paramName ){
    return (String)get( paramName );
  }

}
