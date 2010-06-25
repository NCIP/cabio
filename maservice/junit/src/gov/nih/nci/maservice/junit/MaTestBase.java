package gov.nih.nci.maservice.junit;

import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import junit.framework.TestCase;

public abstract class MaTestBase extends TestCase {
	private MaApplicationService appService;
	private MaApplicationService appServiceFromUrl;

	protected void setUp() throws Exception {
		super.setUp();
		appService = (MaApplicationService)ApplicationServiceProvider.getApplicationService();
	}


	protected void tearDown() throws Exception 
	{
		appService = null;
		super.tearDown();
	}
	
	protected MaApplicationService getApplicationService()
	{
		return appService;
	}
	
	
	protected MaApplicationService getApplicationServiceFromUrl() throws Exception
	{
		String url = "http://localhost:8080/maservice";
		appServiceFromUrl = (MaApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(url);
		return appServiceFromUrl;
	}
	
	protected MaApplicationService getBadApplicationServiceFromUrl() throws Exception
	{
		String url = "http://badhost:8080/badcontext";
		appServiceFromUrl = (MaApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(url);
		return appServiceFromUrl;
	}
	
	public static String getTestCaseName()
	{
		return "Molecular Service Base Test Case";
	}


}
