package  gov.nih.nci.caBIOApp.report;

import java.util.*;

public interface Row{

  public Cell createCell( String s );

  public void addCell( Cell c );

  public void addCells( Cell[] l );

  public void setCells( Cell[] l );

  public Cell[] getCells();

  public int getNumCells();

}

