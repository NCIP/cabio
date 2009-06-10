package gov.nih.nci.cabio.portal;

import gov.nih.nci.cabio.portal.portlet.ReportService;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * A test suite with all the unit tests for the caBIO portlet.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AllTests {

    private static CaBioApplicationService service;

    private static ReportService rs;

    static {
        try {
            service = (CaBioApplicationService) ApplicationServiceProvider.getApplicationService();
            rs = new ReportService(service);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static CaBioApplicationService getService() {
        return service;
    }

    public static ReportService getReportService() {
        return rs;
    }

    public static Test suite() {
        TestSuite suite = new TestSuite("Test for gov.nih.nci.cabio.portal");
        //$JUnit-BEGIN$
        suite.addTestSuite(ReportTest.class);
        suite.addTestSuite(GlobalQueriesTest.class);
        //$JUnit-END$
        return suite;
    }

}
