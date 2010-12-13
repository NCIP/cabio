package gov.nih.nci.caBIOApp.report;

import java.io.*;

public interface TableParser{

  public Table parse( InputStream in )
    throws IndexOutOfBoundsException, IOException;

}

