package gov.nih.nci.system.applicationservice;

import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.domain.DatabaseRelease;
import gov.nih.nci.maservice.errors.MAException;
import gov.nih.nci.maservice.util.GeneListSearchCriteria;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.maservice.util.ReporterSearchCriteria;
import gov.nih.nci.maservice.util.DBReleaseSearchCriteria;

import java.util.List;


/**
 * The Molecular Service extension of the ApplicationService, providing additional 
 * methods.
 * 
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public interface MaApplicationService extends ApplicationService {    
    public List<Gene> getGenesBySymbol(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<Gene> getGenesBySymbol(GeneListSearchCriteria geneListSearchCriteria) throws MAException;
    public List<AgentAssociation> getAgentAssociations(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<BiologicalProcess> getBiologicalProcesses(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<CellularComponent> getCellularLocations(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<DiseaseAssociation> getDiseaseAssociations(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<MolecularFunction> getFunctionalAssociations(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<Gene> getHomologousGenes(Organism organism, GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<SingleNucleotidePolymorphism> getStructuralVariations(GeneSearchCriteria geneSearchCriteria) throws MAException;
    public List<Gene> getGenesByMicroarrayReporter(ReporterSearchCriteria reporterSearchCriteria) throws MAException;
    public List<DatabaseRelease> getDatabaseReleases(DBReleaseSearchCriteria dbSearchCriteria) throws MAException;
}
