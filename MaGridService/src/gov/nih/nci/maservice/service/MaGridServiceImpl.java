package gov.nih.nci.maservice.service;

import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import gov.nih.nci.maservice.domain.*;
import gov.nih.nci.maservice.util.*;
import gov.nih.nci.maservice.errors.MAException;

import java.rmi.RemoteException;
import java.util.List;
import java.util.Collections;

/** 
 * TODO:I am the service side implementation class.  IMPLEMENT AND DOCUMENT ME
 * 
 * @created by Introduce Toolkit version 1.3
 * 
 */
public class MaGridServiceImpl extends MaGridServiceImplBase {
	private MaApplicationService maservice;
	
	public MaGridServiceImpl() throws RemoteException {
		super();
		try
		{
		    String appServiceURL = getRemoteApplicationUrl();
		    maservice = (MaApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(appServiceURL);		    
		} 
		catch ( Exception e)
		{
			throw new RemoteException(
					"Error loading MaService for Spring remote service URL: "
							+ e);		      	
		}
		                     
	}
	
  public gov.nih.nci.maservice.domain.Gene[] getGeneBySymbol(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	 Gene[] geneArray = null; 
	  
	 try
	 {
          List<Gene> genes = maservice.getGeneBySymbol(geneSearchCriteria);
          
          if ( genes!=null )
          {
	          geneArray = new Gene[ genes.size()];
	          int i=0;
	          for ( Gene g: genes)
	          {
	        	  geneArray[i++] = g;
	          }
          }
	 }
	 catch ( MAException e)
	 {
		 throw new RemoteException(e.getMessage()); 
	 }	    
	 
	 return geneArray;
  }

  private String getRemoteApplicationUrl() throws Exception {
      String hostname = getConfiguration().getCqlQueryProcessorConfig_applicationHostName();
      String port = getConfiguration().getCqlQueryProcessorConfig_applicationHostPort();
      
      while (hostname.endsWith("/")) {
          hostname = hostname.substring(0, hostname.length() - 1);
      }
      String urlPart = hostname + ":" + port;
      urlPart += "/";
      urlPart += getConfiguration().getCqlQueryProcessorConfig_applicationName();
      return urlPart;
  }  
  public gov.nih.nci.maservice.domain.AgentAssociation[] getAgentAssociation(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
		 AgentAssociation[] agentAssocs = null; 
		  
		 try
		 {
	          List<AgentAssociation> aas = maservice.getAgentAssociations(geneSearchCriteria);
	          
	          if ( aas!=null )
	          {
	        	  agentAssocs = new AgentAssociation[ aas.size()];
		          int i=0;
		          for ( AgentAssociation g: agentAssocs)
		          {
		        	  agentAssocs[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return agentAssocs;
  }

}

