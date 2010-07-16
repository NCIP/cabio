package gov.nih.nci.maservice.junit;

import gov.nih.nci.maservice.util.*;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.iso21090.St;
import java.util.List;

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
        	System.out.println("AgentAssociation[0]: Source: " + aas.get(0).getSource().getValue()
        			           + ", Role.code: " + aas.get(0).getRole().getCode()
        			           + ", Role.codeSystem: " + aas.get(0).getRole().getCodeSystem()
        			           + ", Role.codeSystemName: " + aas.get(0).getRole().getCodeSystemName()
        			           + ", Role.codeSystemVersion: " + aas.get(0).getRole().getCodeSystemVersion()
        			           + ", Role.originalText: " + aas.get(0).getRole().getOriginalText().getValue()
        			           );
        }
	}

	@Test
	public void testGetBiologicalProcesses() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetCellularLocations() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetDiseaseAssociations() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetFunctionalAssociations() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetGeneByMicroarrayReporter() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetHomologousGene() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetStructuralVariations() {
		fail("Not yet implemented");
	}

}
