package gov.nih.nci.cagrid.cabio.service.globus.resource;


/** 
 * DO NOT EDIT:  This class is autogenerated!
 *
 * This class is used by the resource to get configuration information about the 
 * resource.
 * 
 * @created by Introduce Toolkit version 1.3
 * 
 */
public class CaBIO42GridSvcResourceConfiguration {
	private String registrationTemplateFile;
	private boolean performRegistration;

	private String domainModelFile;
	private String serviceMetadataFile;



	public boolean shouldPerformRegistration() {
		return performRegistration;
	}


	public void setPerformRegistration(boolean performRegistration) {
		this.performRegistration = performRegistration;
	}


	public String getRegistrationTemplateFile() {
		return registrationTemplateFile;
	}
	


	public void setRegistrationTemplateFile(String registrationTemplateFile) {
		this.registrationTemplateFile = registrationTemplateFile;
	}
	
	
	
	public String getDomainModelFile() {
		return domainModelFile;
	}
	
	
	public void setDomainModelFile(String domainModelFile) {
		this.domainModelFile = domainModelFile;
	}
	
	
	
	public String getServiceMetadataFile() {
		return serviceMetadataFile;
	}
	
	
	public void setServiceMetadataFile(String serviceMetadataFile) {
		this.serviceMetadataFile = serviceMetadataFile;
	}
		
}
