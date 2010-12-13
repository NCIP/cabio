package gov.nih.nci.caBIOApp.sod;

import java.util.*;

public class SearchableObjectImplImpl
  extends SearchableObjectImpl
{
  public SearchableObjectImplImpl(){
    super();
  }
  public List getAssociations(){
    return SODUtils.sortAssociations( super.getAssociations() );
  }
  public List getAttributes(){
    return SODUtils.sortAttributes( super.getAttributes() );
  }
}
