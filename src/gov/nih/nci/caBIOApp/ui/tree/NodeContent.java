package gov.nih.nci.caBIOApp.ui.tree;

public interface NodeContent{

  public void setId( String s );
  public String getId();
  public void setContent( String s );
  public String getContent();
  public void setDescription( String s );
  public String getDescription();
  public void setTarget( String s );
  public String getTarget();
  public void setLink( String s );
  public String getLink();
  public void setExpanded( boolean b );
  public boolean isExpanded();
  public void setContentModel( Object o );
  public Object getContentModel();
  public void setExtraContentFirst( boolean b );
  public boolean isExtraContentFirst();
  public void setExtraContent( String s );
  public String getExtraContent();
  public boolean hasExtraContent();
  public void setActive( boolean b );
  public boolean isActive();
}

