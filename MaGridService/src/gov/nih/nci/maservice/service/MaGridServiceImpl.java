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
	

  private String getRemoteApplicationUrl() throws Exception {
      String hostname = getConfiguration().getCqlQueryProcessorConfig_applicationHostName();
      String port = getConfiguration().getCqlQueryProcessorConfig_applicationHostPort();

      if (!hostname.startsWith("http://") || !hostname.startsWith("https://")) {
          hostname = "http://" + hostname;
      }
      
      while (hostname.endsWith("/")) {
          hostname = hostname.substring(0, hostname.length() - 1);
      }
      String urlPart = hostname + ":" + port;
      urlPart += "/";
      urlPart += getConfiguration().getCqlQueryProcessorConfig_applicationName();
      return urlPart;
  }  
  public gov.nih.nci.maservice.domain.AgentAssociation[] getAgentAssociations(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
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
  
  public gov.nih.nci.maservice.domain.BiologicalProcess[] getBiologicalProcesses(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	     BiologicalProcess[] results = null; 
		  
		 try
		 {
	          List<BiologicalProcess> list = maservice.getBiologicalProcesses(geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new BiologicalProcess[ list.size()];
		          int i=0;
		          for ( BiologicalProcess g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results;
  }

  public gov.nih.nci.maservice.domain.CellularComponent[] getCellularLocations(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	     CellularComponent[] results = null; 
		  
		 try
		 {
	          List<CellularComponent> list = maservice.getCellularLocations(geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new CellularComponent[ list.size()];
		          int i=0;
		          for ( CellularComponent g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results;
  }

  public gov.nih.nci.maservice.domain.DiseaseAssociation[] getDiseaseAssociations(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	  DiseaseAssociation[] results = null; 
		  
		 try
		 {
	          List<DiseaseAssociation> list = maservice.getDiseaseAssociations(geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new DiseaseAssociation[ list.size()];
		          int i=0;
		          for ( DiseaseAssociation g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results;
  }

  public gov.nih.nci.maservice.domain.MolecularFunction[] getFunctionalAssociations(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	  MolecularFunction[] results = null; 
		  
	   try
		 {
	          List<MolecularFunction> list = maservice.getFunctionalAssociations(geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new MolecularFunction[ list.size()];
		          int i=0;
		          for ( MolecularFunction g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results; 
  }

  public gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism[] getStructuralVariations(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	  SingleNucleotidePolymorphism[] results = null; 
		  
	   try
		 {
	          List<SingleNucleotidePolymorphism> list = maservice.getStructuralVariations(geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new SingleNucleotidePolymorphism[ list.size()];
		          int i=0;
		          for ( SingleNucleotidePolymorphism g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results;
  }

  public gov.nih.nci.maservice.domain.Gene[] getGenesBySymbol(gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
		 Gene[] geneArray = null; 
		  
		 try
		 {
	          List<Gene> genes = maservice.getGenesBySymbol(geneSearchCriteria);
	          
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

  public gov.nih.nci.maservice.domain.Gene[] getHomologousGenes(gov.nih.nci.maservice.domain.Organism organism,gov.nih.nci.maservice.util.GeneSearchCriteria geneSearchCriteria) throws RemoteException {
	  Gene[] results = null; 
		  
	   try
		 {
	          List<Gene> list = maservice.getHomologousGenes(organism, geneSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new Gene[ list.size()];
		          int i=0;
		          for ( Gene g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results;
  }

  public gov.nih.nci.maservice.domain.Gene[] getGenesByMicroarrayReporter(gov.nih.nci.maservice.util.ReporterSearchCriteria reporterSearchCriteria) throws RemoteException {
	   Gene[] results = null; 
		  
	   try
		 {
	          List<Gene> list = maservice.getGenesByMicroarrayReporter(reporterSearchCriteria);
	          
	          if ( list!=null )
	          {
	        	  results = new Gene[ list.size()];
		          int i=0;
		          for ( Gene g: results)
		          {
		        	  results[i++] = g;
		          }
	          }
		 }
		 catch ( MAException e)
		 {
			 throw new RemoteException(e.getMessage()); 
		 }	    
		 
		 return results; 
  }

}

