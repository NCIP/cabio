package gov.nih.nci.system.applicationservice.impl;

import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.ArrayReporter;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.HomologousAssociation;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.MolecularSequenceAnnotation;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.errors.MAException;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.maservice.util.ReporterSearchCriteria;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.util.ClassCache;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * The Molecular Annotation(MA) Service extension of the ApplicationService, 
 * providing additional methods for MA Service based on its functional profiles.
 * 
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class MaApplicationServiceImpl extends ApplicationServiceImpl 
                           implements MaApplicationService {
    
    private static Logger log = Logger.getLogger(MaApplicationServiceImpl.class);
   
    public MaApplicationServiceImpl(ClassCache classCache) {
        super(classCache);
    }

    /**
     * getGeneBySymbol method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return the gene(s) named by the specified gene symbol or gene alias and the genes organism.
     * @throws MAException
     */
    public List<Gene> getGeneBySymbol(GeneSearchCriteria geneSearchCriteria)
	       throws MAException {
		List<Gene> genes = null;
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return genes;
	}

    /**
     * getAgentAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the AgentAssociation class.
     * @throws MAException
     */    
	public List<AgentAssociation> getAgentAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {		
		List<Gene> genes = null;
		List<AgentAssociation> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        list = new ArrayList<AgentAssociation>();
            for (Gene g: genes)
            {
               Collection<MolecularSequenceAnnotation> msac = 
                   getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof AgentAssociation) {
		                list.add((AgentAssociation)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
		
	}

    /**
     * getBiologicalProcesses method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the BiologicalProcess class.
     * @throws MAException
     */    	
	public List<BiologicalProcess> getBiologicalProcesses(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<BiologicalProcess> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        list = new ArrayList<BiologicalProcess>();
            for (Gene g: genes)
            {
               Collection<MolecularSequenceAnnotation> msac = 
                   getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof BiologicalProcess) {
		                list.add((BiologicalProcess)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
	}

    /**
     * getCellularLocations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the CellularComponent class.
     * @throws MAException
     */	
	public List<CellularComponent> getCellularLocations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<CellularComponent> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        list = new ArrayList<CellularComponent>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof CellularComponent) {
		                list.add((CellularComponent)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
	}

    /**
     * getDiseaseAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the DiseaseAssociation class.
     * @throws MAException
     */	
	public List<DiseaseAssociation> getDiseaseAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<DiseaseAssociation> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        list = new ArrayList<DiseaseAssociation>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof DiseaseAssociation) {
		                list.add((DiseaseAssociation)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
	}

    /**
     * getFunctionalAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the MolecularFunction class.
     * @throws MAException
     */	
	public List<MolecularFunction> getFunctionalAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<MolecularFunction> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        list = new ArrayList<MolecularFunction>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof MolecularFunction) {
		                list.add((MolecularFunction)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
	}

    /**
     * getGeneByMicroarrayReporter method
     * @param reporterSearchCriteria The criteria containing a reporter name and a microarray design to search within.
     * @return Return Fully-populated instance(s) of Gene class.
     * @throws MAException
     */
	public List<Gene> getGeneByMicroarrayReporter(
			ReporterSearchCriteria reporterSearchCriteria) throws MAException {
		List<ArrayReporter> reporters = null;		
		List<Gene> genes = null; 
		try
		{
	        ArrayReporter reporter = this.composeArrayReporterCriteria(reporterSearchCriteria);
	        reporters = this.search(ArrayReporter.class, reporter);
	        
	        genes = new ArrayList<Gene>();
            for (ArrayReporter ar: reporters)
            {
                Collection<Gene> gs = getAssociation(ar, "geneCollection");
                genes.addAll(gs);
            }  // end of reporters loop
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return genes;
	}

    /**
     * getHomologousGene method which returns genes homologous gene in a specified organism
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of Gene class.
     * @throws MAException
     */		
	public List<Gene> getHomologousGene(Organism organism,
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<Gene> homologousGenes = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        homologousGenes = new ArrayList<Gene>();
            for (Gene g: genes)
            {
               Collection<HomologousAssociation> hac = getAssociation(g, "homologousAssociationCollection");
	           for ( HomologousAssociation ha: hac)
	           {
	                Collection<Gene> hg = getAssociation(ha, "homologousGene");
	                if (hg.size()==1)
	                    homologousGenes.add(hg.iterator().next());
	           }
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return homologousGenes;
	}

    /**
     * getStructuralVariations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the SingleNucleotidePolymorphism class.
     * @throws MAException
     */	
	public List<SingleNucleotidePolymorphism> getStructuralVariations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<SingleNucleotidePolymorphism> list = null; 
		try
		{
	        Gene gene = composeGeneCriteria(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        list = new ArrayList<SingleNucleotidePolymorphism>();
            for (Gene g: genes)
            {
                Collection<NucleicAcidSequenceVariation> msac = 
                    getAssociation(g, "nucleicAcidSequenceVariationCollection");
	           for (NucleicAcidSequenceVariation msa: msac)
	           {
		           if ( msa instanceof SingleNucleotidePolymorphism) {
		                list.add((SingleNucleotidePolymorphism)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch ( ApplicationException e)
		{
			MAException me = new MAException(e);
			throw me;
		}
		
		return list;
	}	
	
	private Gene composeGeneCriteria(GeneSearchCriteria geneSearchCriteria)
	{
        Gene gene = new Gene();
        gene.setSymbol(geneSearchCriteria.getSymbolOrAlias());
        gene.setOrganism(geneSearchCriteria.getOrganism());
        
	    return gene;
	}	

	private ArrayReporter composeArrayReporterCriteria(ReporterSearchCriteria reporterSearchCriteria)
	{
        ArrayReporter reporter = new ArrayReporter();
        reporter.setName(reporterSearchCriteria.getReporterName());
        reporter.setMicroarray(reporterSearchCriteria.getMicroarray());
        
	    return reporter;
	}	

}
