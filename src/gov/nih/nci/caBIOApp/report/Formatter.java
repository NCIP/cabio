package gov.nih.nci.caBIOApp.report;
import java.io.*;
import java.util.*;
import java.net.*;

public interface Formatter {
   public ByteArrayOutputStream format(Table finalTable);
}
