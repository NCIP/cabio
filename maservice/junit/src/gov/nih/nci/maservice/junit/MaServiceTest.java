package gov.nih.nci.maservice.junit;

import gov.nih.nci.maservice.util.*;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.iso21090.St;
import java.util.List;

import static org.junit.Assert.*;

import org.junit.Test;

public class MaServiceTest extends MaTestBase {

	@Test
	public void testGetGeneBySymbol() throws Exception {
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("BRCA1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<Gene> genes = this.getApplicationService().getGeneBySymbol(geneSearchCriteria);
		
        assertNotNull(genes);		
	}

	@Test
	public void testGetAgentAssociations() {
		fail("Not yet implemented");
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
