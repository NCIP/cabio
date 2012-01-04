package gov.nih.nci.caBIOApp.report;

import java.io.IOException;
import java.io.InputStream;

public interface TableParser {

    public Table parse(InputStream in) throws IndexOutOfBoundsException,
            IOException;

}
