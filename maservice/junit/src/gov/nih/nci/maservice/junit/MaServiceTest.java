package gov.nih.nci.maservice.junit;

import gov.nih.nci.maservice.util.*;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.FunctionalAssociation;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.domain.GeneIdentifier;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Cd;
import java.util.List;
import java.io.PrintStream;


import static org.junit.Assert.*;

import org.junit.Test;

public class MaServiceTest extends MaTestBase {

	@Test
	public void testGetGeneBySymbol() throws Exception {
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<Gene> genes = this.getApplicationService().getGeneBySymbol(geneSearchCriteria);
		
        assertNotNull(genes);
        
        if ( genes.size() > 0)
        {
        	System.out.println("Total genes found: " + genes.size());
        	System.out.println("Gene Full Name:" + genes.get(0).getFullName().getValue() 
        			           + " id:" + genes.get(0).getId().getExtension());
            for(GeneIdentifier id : genes.get(0).getGeneIdentifierCollection()) {
                System.out.println("----------");
                System.out.println("  identifier.root: "+id.getIdentifier().getRoot());
                System.out.println("  identifier.extension: "+id.getIdentifier().getExtension());
                System.out.println(" databaseName: ");
                printCD(id.getDatabaseName(), System.out);
            } // for
        }
	}

	@Test
	public void testGetAgentAssociations() throws Exception {
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<AgentAssociation> aas = this.getApplicationService().getAgentAssociations(geneSearchCriteria);
		
        assertNotNull(aas);	
        
        if ( aas.size() > 0)
        {
        	System.out.println("Total AgentAssociationFound: " + aas.size());
        	System.out.println("AgentAssociation[0]: Source: " + aas.get(0).getSource().getValue());
        	System.out.println(" Role object: " );
        	printCD(aas.get(0).getRole(), System.out);
        }
	}

	@Test
	public void testGetBiologicalProcesses() throws Exception{
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<BiologicalProcess> bp = this.getApplicationService().getBiologicalProcesses(geneSearchCriteria);
		
        assertNotNull(bp);	
        
        if ( bp.size() > 0)
        {
        	System.out.println("Total BiologicalProcesses Found: " + bp.size());
        	System.out.println("BiologicalProcess[0]: Source: " + bp.get(0).getSource().getValue());
        	System.out.println(" Term object: " );
        	printCD(bp.get(0).getTerm(), System.out);
        }

	}

	@Test
	public void testGetCellularLocations() throws Exception {
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<CellularComponent> cc = this.getApplicationService().getCellularLocations(geneSearchCriteria);
		
        assertNotNull(cc);	
        
        if ( cc.size() > 0)
        {
        	System.out.println("Total CellularComponents Found: " + cc.size());
        	System.out.println("CellularComponent[0]: Source: " + cc.get(0).getSource().getValue());
        	System.out.println(" Term object: " );
        	printCD(cc.get(0).getTerm(), System.out);
        }
	}

	@Test
	public void testGetDiseaseAssociations() throws Exception {
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<DiseaseAssociation> da = this.getApplicationService().getDiseaseAssociations(geneSearchCriteria);
		
        assertNotNull(da);	
        
        if ( da.size() > 0)
        {
        	System.out.println("Total DiseaseAssociations Found: " + da.size());
        	System.out.println("DiseaseAssociation[0]: Source: " + da.get(0).getSource().getValue());
        	System.out.println(" Role object: " );
        	printCD(da.get(0).getRole(), System.out);
        }
	}

	@Test
	public void testGetFunctionalAssociations() throws Exception{
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<MolecularFunction> fa = this.getApplicationService().getFunctionalAssociations(geneSearchCriteria);
		
        assertNotNull(fa);	
        
        if ( fa.size() > 0)
        {
        	System.out.println("Total MolecularFunctions Found: " + fa.size());
        	System.out.println("MolecularFunction[0]: Source: " + fa.get(0).getSource().getValue());
        	System.out.println(" Role object: " );
        	printCD(fa.get(0).getTerm(), System.out);
        }
	}

	@Test
	public void testGetGeneByMicroarrayReporter() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetHomologousGene() throws Exception{
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		Organism organism = new Organism();
		St scientificName = new St();
		scientificName.setValue("Homo sapiens");
		organism.setScientificName(scientificName);		
		
		List<Gene> genes = this.getApplicationService().getHomologousGene(organism, geneSearchCriteria);
		
        assertNotNull(genes);
        
        if ( genes.size() > 0)
        {
        	System.out.println("Total Homologous Genes found: " + genes.size());
        	System.out.println("Gene Full Name:" + genes.get(0).getFullName().getValue() 
        			           + " id:" + genes.get(0).getId().getExtension());
            for(GeneIdentifier id : genes.get(0).getGeneIdentifierCollection()) {
                System.out.println("----------");
                System.out.println("  identifier.root: "+id.getIdentifier().getRoot());
                System.out.println("  identifier.extension: "+id.getIdentifier().getExtension());
                System.out.println(" databaseName: ");
                printCD(id.getDatabaseName(), System.out);
            } // for
        }
	}

	@Test
	public void testGetStructuralVariations() throws Exception{
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<SingleNucleotidePolymorphism> snp = this.getApplicationService().getStructuralVariations(geneSearchCriteria);
		
        assertNotNull(snp);	
        
        if ( snp.size() > 0)
        {
        	System.out.println("Total SNPs Found: " + snp.size());
        	System.out.println("SNP[0]: + Id.extension: " + snp.get(0).getId().getExtension()
        			           + ",FeatureType: " + snp.get(0).getFeatureType().getValue()
        			           + ",CodingStatus: " + snp.get(0).getCodingStatus().getValue()
        			           + ",Flank: " + snp.get(0).getFlank().getValue()
        			           + ",ValidationStatus: " + snp.get(0).getValidationStatus().getValue()
        			           + ",ChrXPseudoAutosomalRegion: " + snp.get(0).getChrXPseudoAutosomalRegion().getValue()        			           
        			           + ",AminoAcidChange: " + snp.get(0).getAminoAcidChange().getValue());
        }
	}

	private void printCD(Cd cd, PrintStream out)
	{
		if ( cd!= null)
		{
			out.println(" Code: " + cd.getCode()
					    + ", CodeSystem: " + cd.getCodeSystem()
					    + ", CodeSystemName: " + cd.getCodeSystemName()
					    + ", CodeSystemVersion: " + cd.getCodeSystemName()
					    + ", OriginalText: " + cd.getOriginalText().getValue());
		}
	}
}
