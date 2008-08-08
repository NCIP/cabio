package gov.nih.nci.cabio;

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * A test suite with all the unit tests for caBIO.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AllTests {

    private static CaBioApplicationService service;

    private static ArrayAnnotationService annotations;

    static {
        try {
            service = (CaBioApplicationService) ApplicationServiceProvider.getApplicationService();
            annotations = new ArrayAnnotationServiceImpl(service);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static CaBioApplicationService getService() {
        return service;
    }

    public static ArrayAnnotationService getAnnotationAPI() {
        return annotations;
    }

    public static Test suite() {
        TestSuite suite = new TestSuite("Test for gov.nih.nci.cabio");
        //$JUnit-BEGIN$
        suite.addTestSuite(ArraysTest.class);
        suite.addTestSuite(QueryTest.class);
        suite.addTestSuite(GridIdTest.class);
        suite.addTestSuite(XMLTest.class);
        suite.addTestSuite(CQLTest.class);
        suite.addTestSuite(CaBIGStandardModelTest.class);
        suite.addTestSuite(MarkerTest.class);
        suite.addTestSuite(WSTest.class);
        suite.addTestSuite(SVGTest.class);
        suite.addTestSuite(CGDCTest.class);
        suite.addTestSuite(DefectTest.class);
        suite.addTestSuite(RangeQueryTest.class);
        suite.addTestSuite(AnnotationAPITest.class);
        suite.addTestSuite(DevGuideTest.class);
        suite.addTestSuite(ReflectionUtilsTest.class);
        //$JUnit-END$
        return suite;
    }

}
