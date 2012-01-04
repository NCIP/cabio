package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Evidence;
import gov.nih.nci.cabio.domain.EvidenceCode;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

/**
 * Unit tests for Cancer Gene Index in caBIO.
 */
public class CGDCTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();

    public void testEvidenceCode() throws Exception {

        EvidenceCode ecode = new EvidenceCode();
        ecode.setEvidenceCode("EV-EXP-IEP");
        List resultList = appService.search(EvidenceCode.class, ecode);

        assertEquals("EvidenceCode", 1, resultList.size());
        ecode = (EvidenceCode) resultList.get(0);

        assertNotNull("Evidence collection is null",
            ecode.getEvidenceCollection());

        assertFalse("Evidence collection is empty",
            ecode.getEvidenceCollection().isEmpty());
    }

    public void testEvidence() throws Exception {

        Evidence evd = new Evidence();
        evd.setPubmedId(10493949);
        List resultList = appService.search(Evidence.class, evd);
        assertNotNull("Evidence", resultList);
        assertFalse("Evidence", resultList.isEmpty());
        
        evd = (Evidence) resultList.get(0);
        assertNotNull("Evidence Code", evd.getEvidenceCodeCollection());
    }

    public void testGeneDisease() throws Exception {

        Gene g = new Gene();
        g.setSymbol("PLK1");
        List resultList = appService.search(Gene.class, g);

        assertFalse("Gene", resultList.isEmpty());
        g = (Gene) resultList.get(0);
        
        assertNotNull("Gene Function Collection",
            g.getGeneFunctionAssociationCollection());
        Collection<GeneFunctionAssociation> gfac = g.getGeneFunctionAssociationCollection();

        int ac = 0;
        int dc = 0;
        for(GeneFunctionAssociation gfa : gfac) {
            if (gfa instanceof GeneAgentAssociation) {
                ac++;
            }
            if (gfa instanceof GeneDiseaseAssociation) {
                dc++;
            }
        }
        
        assertTrue("No associations to agents",ac>0);
        assertTrue("No associations to diseases",dc>0);
    }
}
