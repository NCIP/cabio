package gov.nih.nci.maservice.junit;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import junit.framework.TestCase;

public abstract class MaTestBase extends TestCase {
	private MaApplicationService appService;
	private String MASERVICE_URL= "http://localhost:8080/maservice";
	private MaApplicationService appServiceFromUrl;

	protected void setUp() throws Exception {
		super.setUp();
	    
		try
		{
		// attempt to get the right URL from the Java client configuration
        ApplicationContext ctx = 
            new ClassPathXmlApplicationContext("application-config-client.xml");
            MASERVICE_URL = (String) ctx.getBean("RemoteServerURL");
            
		} 
		catch ( Exception e )
		{
			
		}
		
		appService = (MaApplicationService)this.getApplicationServiceFromUrl();
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
		appServiceFromUrl = (MaApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(MASERVICE_URL);
		return appServiceFromUrl;
	}
	
	
	public static String getTestCaseName()
	{
		return "Molecular Service Base Test Case";
	}


}
