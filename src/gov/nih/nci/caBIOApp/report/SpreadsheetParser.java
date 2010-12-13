package gov.nih.nci.caBIOApp.report;

import java.io.*;

public interface SpreadsheetParser{

  public Spreadsheet parseExcelSpreadsheet( InputStream in, int worksheetNum )
    throws IndexOutOfBoundsException, IOException;

  public Spreadsheet parseDelimitedFile( InputStream in, String delimiter )
    throws Exception;

}

