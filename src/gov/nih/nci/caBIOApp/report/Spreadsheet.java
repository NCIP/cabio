package gov.nih.nci.caBIOApp.report;

import java.io.*;
import java.util.*;

public interface Spreadsheet{

  public Row createRow();

  public void addRow( Row row );

  public void addRows( Row[] rows );

  public void setRows( Row[] rows );

  public Row[] getRows();

  public void write( OutputStream out )
    throws IOException;

  public void setName( String s );

  public String getName();

  public int getNumRows();

}

