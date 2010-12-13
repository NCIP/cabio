package gov.nih.nci.caBIOApp.sod;

import gov.nih.nci.caBIOApp.util.*;

public interface SODFactory{

    public SearchableObjectsDescription getSOD()
	throws ConfigurationException;

}
