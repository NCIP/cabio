/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.ArrayReporterCytogeneticLocation;
import gov.nih.nci.cabio.domain.ArrayReporterPhysicalLocation;
import gov.nih.nci.cabio.domain.CytogeneticLocation;
import gov.nih.nci.cabio.domain.ExonArrayReporter;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneRelativeLocation;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.cabio.domain.RelativeLocation;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.domain.Transcript;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

/**
 * Unit tests for array annotations in caBIO. This suite of tests investigates
 * a single reporter from each microarray, to ensure all data is loaded 
 * correctly. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ArraysTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
    
    /**
     * Ensure data exists for reporter 205243_at on array HG-U133_Plus_2.
     * Checks all attributes, associated gene, protein domains, and locations.
     */
    public void testAffyHgu133() throws Exception {
        
        Microarray microarray = new Microarray();
        microarray.setName("HG-U133_Plus_2");
        
        ArrayReporter ar = new ArrayReporter();
        ar.setName("205243_at");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);

        assertEquals("Reporters",1,resultList.size());
        ExpressionArrayReporter reporter = (ExpressionArrayReporter)resultList.get(0);
        
        assertEquals("Gene symbol","SLC13A3",reporter.getGene().getSymbol());
        
        assertEquals("Array name","HG-U133_Plus_2",
            reporter.getMicroarray().getName());
        
        assertNotNull("Target description is null",
            reporter.getTargetDescription());
        
        assertNotNull("Target id is null",
            reporter.getTargetId());
        
        assertNotNull("Sequence source is null",
            reporter.getSequenceSource());
        
        assertNotNull("Sequence type is null",
            reporter.getSequenceType());
        
        Collection domains = reporter.getProteinDomainCollection();
        
        assertNotNull("Protein domain collection is null", domains);
        assertEquals("Protein domains",2,domains.size());

        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","20",pl.getChromosome().getNumber());
        assertEquals("Start position",44619873,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",44713505,pl.getChromosomalEndPosition().intValue());
        
        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertEquals("Locations",1,locations.size());
        CytogeneticLocation cl = clocations.iterator().next();
        assertEquals("Chromosome","20",cl.getChromosome().getNumber());
        assertEquals("Cytoband","20q12",cl.getStartCytoband().getName());
    }

    /**
     * Ensure data exists for reporter A_16_P00000090 on array 014693_D.
     * Checks all attributes, associated gene and sequence.
     */
    public void testAgilentCGH244K() throws Exception {

        Microarray microarray = new Microarray();
        microarray.setName("014693_D");
        
        ArrayReporter ar = new ArrayReporter();
        ar.setName("A_16_P00000090");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);
    
        assertEquals("Reporters",1,resultList.size());
        ExpressionArrayReporter reporter = (ExpressionArrayReporter)resultList.get(0);

        assertEquals("Array name", "014693_D",
            reporter.getMicroarray().getName());
        
        assertNotNull("Gene is null",reporter.getGene());
        assertEquals("Gene symbol","SAMD11",reporter.getGene().getSymbol());

        assertNotNull("Sequence is null",reporter.getNucleicAcidSequence());
        assertEquals("Sequence accession","NM_152486",
            reporter.getNucleicAcidSequence().getAccessionNumber());

        assertNull("Target description is not null",
            reporter.getTargetDescription());
        
        assertNull("Transcript id is not null",
            reporter.getTargetId());
        
        assertNull("Sequence source is not null",
            reporter.getSequenceSource());
        
        assertNull("Sequence type is not null",
            reporter.getSequenceType());
        
        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","1",pl.getChromosome().getNumber());
        assertEquals("Start position",853295,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",853344,pl.getChromosomalEndPosition().intValue());
        
        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertTrue("No cytogenetic locations should be present",clocations.isEmpty());

    }

    /**
     * Ensure data exists for reporter A_23_P413224 on array 014850_D.
     * Checks all attributes, associated gene, sequence, and locations.
     */
    public void testAgilent44K() throws Exception {

        Microarray microarray = new Microarray();
        microarray.setName("014850_D");

        ArrayReporter ar = new ArrayReporter();
        ar.setName("A_23_P413224");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);
    
        assertEquals("Reporters",1,resultList.size());
        ExpressionArrayReporter reporter = (ExpressionArrayReporter)resultList.get(0);

        assertEquals("Array name", "014850_D",
            reporter.getMicroarray().getName());

        assertNotNull("Gene is null",reporter.getGene());
        assertEquals("Gene symbol","NCR2",
            reporter.getGene().getSymbol());

        assertNotNull("Sequence is null",reporter.getNucleicAcidSequence());
        assertEquals("Sequence accession","NM_004828",
            reporter.getNucleicAcidSequence().getAccessionNumber());

        assertNull("Target description is not null",
            reporter.getTargetDescription());
        
        assertNull("Transcript id is not null",
            reporter.getTargetId());
        
        assertNull("Sequence source is not null",
            reporter.getSequenceSource());
        
        assertNull("Sequence type is not null",
            reporter.getSequenceType());
        
        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","6",pl.getChromosome().getNumber());
        assertEquals("Start position",41412055,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",41412114,pl.getChromosomalEndPosition().intValue());
        
        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertEquals("Locations",1,locations.size());
        CytogeneticLocation cl = clocations.iterator().next();
        assertEquals("Chromosome","6",cl.getChromosome().getNumber());
        assertEquals("Cytoband","6p21.1",cl.getStartCytoband().getName());
    }

    /**
     * Ensure data exists for reporter SNP_A-1756690 on array Mapping50K_Hind240.
     * Checks all attributes, associated SNP, population frequency count, and 
     * all locations.
     */
    public void testAffyHuMapping() throws Exception {

        Microarray microarray = new Microarray();
        microarray.setName("Mapping50K_Hind240");

        ArrayReporter ar = new ArrayReporter();
        ar.setName("SNP_A-1756690");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);
    
        assertEquals("Reporters",1,resultList.size());
        SNPArrayReporter reporter = (SNPArrayReporter)resultList.get(0);

        assertEquals("Array name","Mapping50K_Hind240",
            reporter.getMicroarray().getName());

        SNP snp = reporter.getSNP();
        assertNotNull("SNP is null",snp); 
        assertEquals("SNP","rs2302213",snp.getDBSNPID());

        assertEquals("PopulationFrequency count",3,
            snp.getPopulationFrequencyCollection().size());

        assertNotNull("ChrXPseudoAutosomalRegion is null",
            snp.getChrXPseudoAutosomalRegion());
        
        assertNotNull("Flank is null",snp.getFlank());
        
        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","16",pl.getChromosome().getNumber());
        assertEquals("Start position",7666758,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",7666758,pl.getChromosomalEndPosition().intValue());
        
        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertEquals("Locations",1,locations.size());
        CytogeneticLocation cl = clocations.iterator().next();
        assertEquals("Chromosome","16",cl.getChromosome().getNumber());
        assertEquals("Cytoband","16p13.2",cl.getStartCytoband().getName());
    }

    /**
     * Ensure data exists for reporter rs1003857 on array HumanHap550Kv3.
     * Checks all attributes, associated SNP, relative locations, and 
     * physical locations.
     */
    public void testIlluminaHumanHap() throws Exception {

        Microarray microarray = new Microarray();
        microarray.setName("HumanHap550Kv3");

        ArrayReporter ar = new ArrayReporter();
        ar.setName("rs1003857");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);
    
        assertEquals("Reporters",1,resultList.size());
        SNPArrayReporter reporter = (SNPArrayReporter)resultList.get(0);

        assertEquals("Array name", "HumanHap550Kv3",
            reporter.getMicroarray().getName());

        assertEquals("SNP", "rs1003857",
            reporter.getSNP().getDBSNPID());

        assertNotNull("Phast conservation is null",
            reporter.getPhastConservation());

        assertNotNull("Amino acid change is null",
            reporter.getSNP().getAminoAcidChange());

        assertNotNull("Coding status is null",
            reporter.getSNP().getCodingStatus());
        
        Collection<RelativeLocation> rlocations = 
            reporter.getSNP().getRelativeLocationCollection();
        assertNotNull("Locations null",rlocations);
        assertEquals("Locations",1,rlocations.size());
        
        GeneRelativeLocation grl = (GeneRelativeLocation)rlocations.iterator().next();
        assertEquals("Orientation","CDS",grl.getOrientation());
        
        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","6",pl.getChromosome().getNumber());
        assertEquals("Start position",166872254,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",166872254,pl.getChromosomalEndPosition().intValue());

        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertTrue("No cytogenetic locations should be present",clocations.isEmpty());
    }
    
    /**
     * Ensure data exists for reporter 2315101 on array HuEx-1_0-st-v2.
     * Checks all attributes, associated genes and transcript, and locations.
     */
    public void testAffyExon() throws Exception {

        Microarray microarray = new Microarray();
        microarray.setName("HuEx-1_0-st-v2");

        ArrayReporter ar = new ArrayReporter();
        ar.setName("2315101");
        ar.setMicroarray(microarray);
        List<ArrayReporter> resultList = appService.search(ArrayReporter.class, ar);
    
        assertEquals("Reporters",1,resultList.size());
        ExonArrayReporter reporter = (ExonArrayReporter)resultList.get(0);

        assertEquals("Microarray name","HuEx-1_0-st-v2", 
            reporter.getMicroarray().getName());

        assertEquals("Strand","+",reporter.getStrand());
        
        assertNotNull("PSR id is null",reporter.getProbeSelectionRegionId());
        assertEquals("PSR id",1,reporter.getProbeSelectionRegionId().intValue());
        
        assertNotNull("Exon is null",reporter.getExon());
        assertEquals("Source","Affymetrix",reporter.getExon().getSource());
                
        Collection<Gene> genes = reporter.getGeneCollection();
        assertNotNull("Genes null",genes);
        assertEquals("Genes",2,genes.size());
        
        Collection<ArrayReporterPhysicalLocation> locations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Locations",1,locations.size());
        PhysicalLocation pl = locations.iterator().next();
        assertEquals("Chromosome","1",pl.getChromosome().getNumber());
        assertEquals("Start position",1788,pl.getChromosomalStartPosition().intValue());
        assertEquals("End position",2030,pl.getChromosomalEndPosition().intValue());

        Transcript transcript = reporter.getTranscript();
        assertEquals("Affymetrix",transcript.getSource());
        
        assertEquals("Transcript","2315100",transcript.getSourceId());
        
        Collection<ArrayReporterPhysicalLocation> tlocations = 
            reporter.getPhysicalLocationCollection();
        assertEquals("Transcript Locations",1,tlocations.size());
        
        PhysicalLocation tpl = tlocations.iterator().next();
        assertNotNull("Transcript Location null",tpl);

        Collection<ArrayReporterCytogeneticLocation> clocations = 
            reporter.getCytogeneticLocationCollection();
        assertTrue("No cytogenetic locations should be present",clocations.isEmpty());
    }
}
