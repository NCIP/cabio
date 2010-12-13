package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIOApp.util.*;

public class SpreadsheetParsingException extends BaseException
{
    public SpreadsheetParsingException(){
	super();
    }
    public SpreadsheetParsingException( String s ){
	super( s );
    }
    public SpreadsheetParsingException( String s, Throwable t ){
	super( s, t );
    }

}

