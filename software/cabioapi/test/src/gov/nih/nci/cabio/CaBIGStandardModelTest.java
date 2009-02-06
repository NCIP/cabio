package gov.nih.nci.cabio;

import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import junit.framework.TestCase;

import gov.nih.nci.cabio.domain.MessengerRNA;
import gov.nih.nci.cabio.domain.ExpressedSequenceTag;
import gov.nih.nci.cabio.domain.NucleicAcidSequence;
import java.util.List;

public class CaBIGStandardModelTest extends TestCase {
	private final CaBioApplicationService appService = AllTests.getService();
	 
	/**
	 * test searching MessengerRNA object using accession numbers (NM_000015, CR407631,  BC015878, etc)
	 * @throws Exception
	 */
	public void testMessengerRNAQuery() throws Exception {		
		MessengerRNA mRNA = new MessengerRNA();
		mRNA.setAccessionNumber("NM_000015");
		
		List mRNAs = appService.search(MessengerRNA.class, mRNA);
		assertNotNull(mRNAs);
		assertTrue("Expect at least 1 mRNA", mRNAs.size()>=1);
	}

	/**
	 * test searching ExpressedSequenceTag object using accession numbers (AI733799, AV684197, EG327340, etc)
	 * @throws Exception
	 */
	public void testESTQuery() throws Exception {
		ExpressedSequenceTag est = new ExpressedSequenceTag();
		est.setAccessionNumber("AV684197");
		
		List ests = appService.search(ExpressedSequenceTag.class, est);
		assertNotNull(ests);
		assertTrue("Expect at least 1 EST", ests.size()>=1);
	}

	/**
	 * test searching NucleicAcidSequence object using accession numbers (AI733799, AV684197, EG327340, etc)
	 * @throws Exception
	 */
	public void testNASQuery() throws Exception {
		NucleicAcidSequence nas = new NucleicAcidSequence();
		nas.setAccessionNumber("EG327340");
		
		List nases = appService.search(NucleicAcidSequence.class, nas);
		assertNotNull(nases);
		assertTrue("Expect at least 1 NucleicAcidSequence.", nases.size()>=1);
	}
	
    //Test associations such as getGenes, getExpressionArrayReporterCollection, etc as applicable	
}
