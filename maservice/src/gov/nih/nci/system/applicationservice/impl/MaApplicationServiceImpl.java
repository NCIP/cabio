package gov.nih.nci.system.applicationservice.impl;

import java.util.List;

import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.errors.MAException;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.maservice.util.ReporterSearchCriteria;
import gov.nih.nci.maservice.util.SearchCriteria;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.dao.Request;
import gov.nih.nci.system.util.ClassCache;

import gov.nih.nci.iso21090.St;

/**
 * The Molecular Service extension of the ApplicationService, providing additional 
 * methods.
 * 
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class MaApplicationServiceImpl extends ApplicationServiceImpl 
                           implements MaApplicationService {
	private final ClassCache classCache;
    
    public MaApplicationServiceImpl(ClassCache classCache) {
        super(classCache);
        
        // hold onto this so that we can do our own DAO queries
        this.classCache = classCache;
    }
    
	public List search(SearchCriteria searchCriteria)
			throws ApplicationException {
        Request request = new Request(searchCriteria);
        request.setDomainObjectName(searchCriteria.getClass().getName());
        return (List)super.query(request).getResponse();
	}

	public List<Gene> getGeneBySymbol(GeneSearchCriteria geneSearchCriteria)
	       throws MAException {
		List<Gene> genes = null;
		try
		{
	        Gene gene = new Gene();
	        gene.setSymbol(geneSearchCriteria.getSymbolOrAlias());
	        genes = this.search(Gene.class, gene);
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException();
			St msg = new St();
			msg.setValue(e.getMessage());
			me.setMessage(msg );
			throw me;
		}
		
		return genes;
	}
	
	public List<AgentAssociation> getAgentAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<BiologicalProcess> getBiologicalProcesses(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<CellularComponent> getCellularLocations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<DiseaseAssociation> getDiseaseAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<MolecularFunction> getFunctionalAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Gene> getGeneByMicroarrayReporter(
			ReporterSearchCriteria reporterSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Gene> getHomologousGene(Organism organism,
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<SingleNucleotidePolymorphism> getStructuralVariations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		// TODO Auto-generated method stub
		return null;
	}	
	
}
