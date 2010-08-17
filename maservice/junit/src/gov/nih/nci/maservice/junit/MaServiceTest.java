package gov.nih.nci.maservice.junit;

import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.junit.ISOAssert;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.Allele;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.Disease;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.GeneAlias;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.MolecularSequenceAnnotation;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.domain.TherapeuticAgent;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.maservice.util.ReporterSearchCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.Test;

/**
 * Tests the various custom convenience methods in the MaApplicationService. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class MaServiceTest extends MaTestBase {
   
	@Test
	public void testGetGeneBySymbol() throws Exception {
	    String symbol = "brca";
	    
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue(symbol+"*");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		
		List<Gene> genes = getApplicationService().getGenesBySymbol(geneSearchCriteria);
		
		System.out.println("testGetGeneBySymbol returned "+genes.size()+" genes.");
		
        assertNotNull(genes);
        assertTrue("Expected at least 2 genes starting with "+symbol,genes.size()>2);
        
        for(Gene gene : genes) {
        	ISOAssert.assertConsistent(gene.getFullName());
            ISOAssert.assertConsistent(gene.getSymbol());
            ISOAssert.assertConsistent(gene.getFeatureType());
            assertNotNull(gene.getFullName().getValue());
            assertNotNull(gene.getSymbol());
            assertNotNull(gene.getSymbol().getValue());
            
            boolean found = false;
            if (gene.getSymbol().getValue().toLowerCase().startsWith(symbol)) {
                found = true;
            }
            if (!found) {
                for(GeneAlias alias : gene.getGeneAliasCollection()) {
                    if (alias.getIdentifier().getExtension().toLowerCase().startsWith(symbol)) {
                        found = true;
                        break;
                    }
                }
            }
            assertTrue(found);
        }
	}

    @Test
    public void testGetGeneBySymbolWithOrganism() throws Exception {
        String symbol = "BRCA1";
        String taxon = "human";
        
        GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
        St symbolOrAlias = new St();
        symbolOrAlias.setValue(symbol);
        St commonName = new St();
        commonName.setValue(taxon);
        Organism organism = new Organism();
        organism.setCommonName(commonName);
        geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
        geneSearchCriteria.setOrganism(organism);
        
        List<Gene> genes = getApplicationService().getGenesBySymbol(geneSearchCriteria);
        
        assertNotNull(genes);
        assertEquals(1,genes.size());
        Gene gene = genes.get(0);

        assertTrue(symbol.equalsIgnoreCase(gene.getSymbol().getValue()));
        assertEquals(taxon, gene.getOrganism().getCommonName().getValue());
    }
    
    @Test
    public void testGetGeneBySymbolWithRetrievedOrganism() throws Exception {
        String symbol = "BRCA1";
        String taxon = "mouse";
        
        Organism organism = new Organism();
        St commonName = new St();
        commonName.setValue(taxon);
        organism.setCommonName(commonName);
        
        List<Organism> results = 
            getApplicationService().search(Organism.class, organism);

        assertEquals(1,results.size());
        organism = results.get(0);
        
        GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
        St symbolOrAlias = new St();
        symbolOrAlias.setValue(symbol);
        geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
        geneSearchCriteria.setOrganism(organism);
        
        List<Gene> genes = getApplicationService().getGenesBySymbol(geneSearchCriteria);
        
        assertNotNull(genes);
        assertEquals(1,genes.size());
        Gene gene = genes.get(0);
        
        assertTrue(symbol.equalsIgnoreCase(gene.getSymbol().getValue()));
        assertEquals(taxon, gene.getOrganism().getCommonName().getValue());
    }
 

	@Test
	public void testGetAgentAssociations() throws Exception {

		GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
		List<AgentAssociation> aas = 
		    getApplicationService().getAgentAssociations(geneSearchCriteria);

        assertNotNull(aas);	
        assertTrue("Expected at least 2 agent associations",aas.size()>2);

        List<String> aaids = new ArrayList<String>();
        for(AgentAssociation aa : aas) {
            aaids.add(aa.getId().getExtension());
            ISOAssert.assertConsistent(aa.getRole());
            ISOAssert.assertConsistent(aa.getSource());
            TherapeuticAgent a = aa.getTherapeuticAgent();
            assertNotNull(a);
            ISOAssert.assertConsistent(a.getName());
            ISOAssert.assertConsistent(a.getNameCode());
            ISOAssert.assertConsistent(a.getDescription());
        }

        List<String> aaids2 = getAnnotationIds(genes, AgentAssociation.class);
        assertEquals(aaids.size(), aaids2.size());
        assertEqualElements(aaids, aaids2);
	}

	
	@Test
	public void testGetBiologicalProcesses() throws Exception{
	    
        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
        List<BiologicalProcess> bps = 
            getApplicationService().getBiologicalProcesses(geneSearchCriteria);
        
        assertNotNull(bps); 
        assertTrue("Expected at least 2 biological processes",bps.size()>2);

        List<String> bpids = new ArrayList<String>();
        for(BiologicalProcess aa : bps) {
            bpids.add(aa.getId().getExtension());
            ISOAssert.assertConsistent(aa.getSource());
            ISOAssert.assertConsistent(aa.getTerm());
            assertNotNull(aa.getTerm().getOriginalText());
        }

        List<String> bpids2 = getAnnotationIds(genes, BiologicalProcess.class);
        assertEquals(bpids.size(), bpids2.size());
        assertEqualElements(bpids, bpids2);
    }


    @Test
    public void testGetCellularLocations() throws Exception{
        
        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
        List<CellularComponent> bps = 
            getApplicationService().getCellularLocations(geneSearchCriteria);
        
        assertNotNull(bps); 
        assertTrue("Expected at least 2 cellular locations",bps.size()>2);

        List<String> bpids = new ArrayList<String>();
        for(CellularComponent aa : bps) {
            bpids.add(aa.getId().getExtension());
            ISOAssert.assertConsistent(aa.getSource());
            ISOAssert.assertConsistent(aa.getTerm());
            assertNotNull(aa.getTerm().getOriginalText());
        }

        List<String> bpids2 = getAnnotationIds(genes, CellularComponent.class);
        assertEquals(bpids.size(), bpids2.size());
        assertEqualElements(bpids, bpids2);
    }	


    @Test
    public void testGetDiseaseAssociations() throws Exception{
        
        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
        List<DiseaseAssociation> das = 
            getApplicationService().getDiseaseAssociations(geneSearchCriteria);
        
        assertNotNull(das); 
        assertTrue("Expected at least 2 disease associations",das.size()>2);

        List<String> daids = new ArrayList<String>();
        for(DiseaseAssociation aa : das) {
            daids.add(aa.getId().getExtension());
            ISOAssert.assertConsistent(aa.getSource());
            ISOAssert.assertConsistent(aa.getRole());
            Disease a = aa.getDisease();
            assertNotNull(a);
            ISOAssert.assertConsistent(a.getName());
            ISOAssert.assertConsistent(a.getNameCode());
        }

        List<String> daids2 = getAnnotationIds(genes, DiseaseAssociation.class);
        assertEquals(daids.size(), daids2.size());
        assertEqualElements(daids, daids2);
    }   


    @Test
    public void testGetFunctionalAssociations() throws Exception {
        
        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
        List<MolecularFunction> mfs = 
            getApplicationService().getFunctionalAssociations(geneSearchCriteria);
        
        assertNotNull(mfs); 
        assertTrue("Expected at least 2 functional associations",mfs.size()>2);

        List<String> mfids = new ArrayList<String>();
        for(MolecularFunction aa : mfs) {
            mfids.add(aa.getId().getExtension());
            ISOAssert.assertConsistent(aa.getSource());
            ISOAssert.assertConsistent(aa.getTerm());
            assertNotNull(aa.getTerm().getOriginalText());
        }

        List<String> mfids2 = getAnnotationIds(genes, MolecularFunction.class);
        assertEquals(mfids.size(), mfids2.size());
        assertEqualElements(mfids, mfids2);
    }   

    

	@Test
	public void testGetGeneByMicroarrayReporter() throws Exception {

	    ReporterSearchCriteria reporterSearchCriteria = getReporterSearchCriteria("214727_at", "HG-U133_Plus_2");
	    
	    List<Gene> genes = 
	        getApplicationService().getGenesByMicroarrayReporter(reporterSearchCriteria);

        assertNotNull(genes);
        assertEquals(1, genes.size());
        Gene gene = genes.get(0);
	    
        assertNotNull(gene);
        assertNotNull(gene.getSymbol());
        assertNotNull(gene.getSymbol().getValue());
        assertTrue("BRCA2".equalsIgnoreCase(gene.getSymbol().getValue()));
        assertTrue("human".equalsIgnoreCase(gene.getOrganism().getCommonName().getValue()));	    
	}

	@Test
	public void testGetHomologousGene() throws Exception{
	    
	    // get the human gene
        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");

        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);

        assertNotNull(genes);
        assertEquals(1, genes.size());
        Gene humanGene = genes.get(0);
        assertEquals("human",humanGene.getOrganism().getCommonName().getValue());
        
        // get the homologous gene in mouse
		Organism organism = new Organism();
		St commonName = new St();
		commonName.setValue("mouse");
		organism.setCommonName(commonName);
		List<Gene> genes2 = 
		    getApplicationService().getHomologousGenes(organism, geneSearchCriteria);

        assertNotNull(genes2);
        assertEquals(1, genes2.size());
        Gene mouseGene = genes2.get(0);
        assertEquals("mouse",mouseGene.getOrganism().getCommonName().getValue());
	}

	@Test
	public void testGetStructuralVariations() throws Exception{

        GeneSearchCriteria geneSearchCriteria = getCriteria("BRCA1", "human");
        List<Gene> genes = 
            getApplicationService().getGenesBySymbol(geneSearchCriteria);
        List<SingleNucleotidePolymorphism> snps = 
            getApplicationService().getStructuralVariations(geneSearchCriteria);
        
        assertNotNull(snps); 
        assertTrue("Expected at least 2 SNPs",snps.size()>2);

        List<String> snpids = new ArrayList<String>();
        for(SingleNucleotidePolymorphism snp : snps) {
            snpids.add(snp.getId().getExtension());
            ISOAssert.assertConsistent(snp.getAminoAcidChange());
            ISOAssert.assertConsistent(snp.getChrXPseudoAutosomalRegion());
            ISOAssert.assertConsistent(snp.getCodingStatus());
            ISOAssert.assertConsistent(snp.getFeatureType());
            ISOAssert.assertConsistent(snp.getFlank());
            ISOAssert.assertConsistent(snp.getValidationStatus());

            assertFalse(snp.getAlleleCollection().isEmpty());
            for(Allele allele : snp.getAlleleCollection()) {
                ISOAssert.assertConsistent(allele.getSequence());
            }
            
            assertNotNull(snp.getOrganism());
            assertEquals(geneSearchCriteria.getOrganism().getCommonName(), 
                snp.getOrganism().getCommonName());
            
        }
        
        List<String> snpids2 = new ArrayList<String>();
        for (Gene g : genes) {
            for (NucleicAcidSequenceVariation msa: 
                    g.getNucleicAcidSequenceVariationCollection()) {
                if ( msa instanceof SingleNucleotidePolymorphism) {
                    snpids2.add(msa.getId().getExtension());
                }
            } 
        }
        assertEquals(snpids.size(), snpids2.size());
        assertEqualElements(snpids, snpids2);
	}

	/**
	 * Assert that the two collections contain the same elements.
	 * @param list1
	 * @param list2
	 */
    private void assertEqualElements(Collection list1, Collection list2) {
        
        Set set1 = new HashSet(list1);
        Set set2 = new HashSet(list2);
        
        for(Object o : list1) {
            assertTrue(set2.contains(o));
        }

        for(Object o : list2) {
            assertTrue(set1.contains(o));
        }
    }
        
    /**
     * Get all the internal ids for annotations of a specific class for a list
     * of genes. 
     * @param genes
     * @param annotationClass
     * @return
     */
    private List<String> getAnnotationIds(Collection<Gene> genes, Class annotationClass) {
        List<String> ids = new ArrayList<String>();
        for (Gene g : genes) {
            Collection<MolecularSequenceAnnotation> msac = 
                g.getMolecularSequenceAnnotationCollection();
            for (MolecularSequenceAnnotation msa: msac) {
                if (annotationClass.isInstance(msa)) {
                    ids.add(msa.getId().getExtension());
                }
            } 
        } 
        return ids;
    }
}
