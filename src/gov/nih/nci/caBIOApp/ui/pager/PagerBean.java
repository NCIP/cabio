package gov.nih.nci.caBIOApp.ui.pager;

import java.util.*;

public interface PagerBean{

  public void setPagerDataSource( PagerDataSource pds ) throws Exception;
  public void setSelectedIds( String[] s );
  public void select();
  public void deselect();
  public PagerItem[] getAvailableItems() throws Exception;
  public PagerItem[] getSelectedItems();
  public int getStartIndex();
  public int getDisplaySize();
  public boolean getAllowScrollBegin();
  public boolean getAllowScrollEnd();
  public boolean getAllowScrollForward();
  public boolean getAllowScrollBackward();
  public void setScrollDirection( String s );
  public String getScrollDirection();
  public void scroll() throws Exception;
  public void setAllowSelection( boolean b );
  public boolean getAllowSelection();
  public int getItemCount();
  public String[] getHeaders();
  public void setDefaultDisplaySize( int i );
}
