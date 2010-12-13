package gov.nih.nci.caBIOApp.report;

import java.io.*;
import java.util.*;

public interface TableFormatter{

  public byte[] format( Table t )
    throws IOException;

}
