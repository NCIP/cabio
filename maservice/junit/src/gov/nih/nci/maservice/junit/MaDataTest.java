package gov.nih.nci.maservice.junit;

import gov.nih.nci.iso21090.Cd;
import gov.nih.nci.iso21090.EdText;
import gov.nih.nci.iso21090.IdentifierScope;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.junit.ISOAssert;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.Allele;
import gov.nih.nci.maservice.domain.Chromosome;
import gov.nih.nci.maservice.domain.Disease;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.GeneIdentifier;
import gov.nih.nci.maservice.domain.Genome;
import gov.nih.nci.maservice.domain.HomologousAssociation;
import gov.nih.nci.maservice.domain.Microarray;
import gov.nih.nci.maservice.domain.MolecularSequenceAnnotation;
import gov.nih.nci.maservice.domain.NucleicAcidPhysicalLocation;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceFeature;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation;
import gov.nih.nci.maservice.domain.OntologyAnnotation;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.TherapeuticAgent;
import gov.nih.nci.maservice.domain.TherapeuticAgentIdentifier;

import java.util.Collection;
import java.util.List;

import org.junit.Test;

/**
 * Tests the MA information model. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class MaDataTest extends MaTestBase {

    @Test
    public void testMicroarrays() throws Exception {
        
        List<Microarray> results = 
            getApplicationService().search(Microarray.class, new Microarray());
        
        for(Microarray microarray : results) {
            ISOAssert.assertConsistent(microarray.getAnnotationVersion());
            ISOAssert.assertConsistent(microarray.getDbSNPVersion());
            ISOAssert.assertConsistent(microarray.getDescription());
            ISOAssert.assertConsistent(microarray.getGenomeVersion());
            ISOAssert.assertConsistent(microarray.getLSID());
            // "If the root is not a complete unique identifier, and the 
            // extension is not known, then the II shall have a nullFlavor 
            // even if the root is populated."
            assertTrue("LSID must have extension or NullFlavor",
                microarray.getLSID().getNullFlavor() != null ||
                microarray.getLSID().getExtension() != null);
            ISOAssert.assertConsistent(microarray.getManufacturer());
            ISOAssert.assertConsistent(microarray.getName());
            ISOAssert.assertConsistent(microarray.getType());
            ISOAssert.assertConsistent(microarray.getAnnotationDate());
            
            // TODO: can't run this because of the 
            // "Failed to write element to disk" SDK problem
//            int i=0;
//            for(ArrayReporter reporter : microarray.getArrayReporterCollection()) {
//                ISOAssert.assertConsistent(reporter.getName());
//                if (++i > 10) break;
//            }
            
        }
    }

    @Test
    public void testVariations() throws Exception {

        Gene gene = getHumanGene("BRCA1");

        Collection<NucleicAcidSequenceVariation> variations = 
            gene.getNucleicAcidSequenceVariationCollection();
      
        for(NucleicAcidSequenceVariation variation : variations) {

            ISOAssert.assertConsistent(variation.getAminoAcidChange());
            ISOAssert.assertConsistent(variation.getCodingStatus());
            ISOAssert.assertConsistent(variation.getFeatureType());
            ISOAssert.assertConsistent(variation.getFlank());
            ISOAssert.assertConsistent(variation.getChrXPseudoAutosomalRegion());
            assertNotNull(variation.getOrganism());
            ISOAssert.assertConsistent(variation.getValidationStatus());
            
            for(Allele allele : variation.getAlleleCollection()) {
                ISOAssert.assertConsistent(allele.getSequence());
            }
            
        }
    }
    
    @Test
    public void testTherapeuticAgent() throws Exception {

        TherapeuticAgent criteria = new TherapeuticAgent();
        Cd name = new Cd();
        EdText originalText = new EdText();
        originalText.setValue("Sorafenib");
        name.setOriginalText(originalText);
        criteria.setName(name);

        List<TherapeuticAgent> results = 
            getApplicationService().search(TherapeuticAgent.class, criteria);

        assertEquals(1,results.size());
        
        TherapeuticAgent agent = (TherapeuticAgent)results.get(0);

        ISOAssert.assertConsistent(agent.getName());
        ISOAssert.assertConsistent(agent.getNameCode());
        ISOAssert.assertConsistent(agent.getDescription());
        
        for(TherapeuticAgentIdentifier id : agent.getTherapeuticAgentIdentifierCollection()) {
            ISOAssert.assertConsistent(id.getDatabaseName());
            ISOAssert.assertConsistent(id.getIdentifier());
            assertEquals(id.getIdentifier().getScope(), IdentifierScope.OBJ);
        }
        
    }
    
	@Test
	public void testGeneIdentifier() throws Exception {
	    
        Gene gene = getHumanGene("BRCA1");
    
        ISOAssert.assertConsistent(gene.getSymbol());
        ISOAssert.assertConsistent(gene.getFullName());
        // TODO: Should feature type be not null?
        //assertNotNull(gene.getFeatureType());
        assertNotNull(gene.getOrganism());
        
        for(GeneIdentifier id : gene.getGeneIdentifierCollection()) {
            ISOAssert.assertConsistent(id.getDatabaseName());
            ISOAssert.assertConsistent(id.getIdentifier());
            assertEquals(id.getIdentifier().getScope(), IdentifierScope.OBJ);
        }
	}

    @Test
    public void testLocations() throws Exception {

        Gene gene = getHumanGene("BRCA1");
        
        Collection<NucleicAcidPhysicalLocation> locations = 
            gene.getNucleicAcidPhysicalLocationCollection();
        
        for(NucleicAcidPhysicalLocation location : locations) {
            ISOAssert.assertConsistent(location.getOrientation());
            ISOAssert.assertConsistent(location.getStartCoordinate());
            ISOAssert.assertConsistent(location.getEndCoordinate());
            assertNotNull(location.getChromosome());
        }
    }

    @Test
    public void testFeatureHeirarchy() throws Exception {

        Gene gene = getHumanGene("BRCA1");
        
        Collection<NucleicAcidSequenceFeature> children = 
            gene.getChildFeatureCollection();
        
        // TODO: initial release will not have child features
        //assertFalse("Test gene has no child features",children.isEmpty());
        
        for(NucleicAcidSequenceFeature child : children) {
            ISOAssert.assertConsistent(child.getFeatureType());
        }
    }
    
    @Test
    public void testHomologousAssociation() throws Exception {

        Gene gene = getHumanGene("BRCA1");
        
        Collection<HomologousAssociation> haCollection = 
            gene.getHomologousAssociationCollection();
        
        assertEquals(1,haCollection.size());
        HomologousAssociation assoc = haCollection.iterator().next();
        
        assertNotNull(assoc);
        assertNotNull(assoc.getSimilarityPercentage());
        
        Gene hgene = assoc.getHomologousGene();
        assertNotNull(hgene);
        assertEquals("brca1",
            hgene.getSymbol().getValue().toLowerCase());
        assertEquals("mouse",
            hgene.getOrganism().getCommonName().getValue().toLowerCase());
        
    }

    @Test
    public void testOrganism() throws Exception {
        
        List<Organism> results = 
            getApplicationService().search(Organism.class, new Organism());
        
        for(Organism organism : results) {
            ISOAssert.assertConsistent(organism.getCommonName());
            ISOAssert.assertConsistent(organism.getNcbiTaxonomyId());
            ISOAssert.assertConsistent(organism.getScientificName());
            ISOAssert.assertConsistent(organism.getTaxonomyRank());
        }
    }
    
    @Test
    public void testGenome() throws Exception {
        
        List<Genome> results = 
            getApplicationService().search(Genome.class, new Genome());
        
        for(Genome genome : results) {
            ISOAssert.assertConsistent(genome.getAssemblySource());
            ISOAssert.assertConsistent(genome.getAssemblyVersion());

            for(Chromosome chromo : genome.getChromosomeCollection()) {
                ISOAssert.assertConsistent(chromo.getName());
            }
        }
    }
    
    @Test
    public void testAnnotations() throws Exception {

        Gene gene = getHumanGene("BRCA1");
        
        for(MolecularSequenceAnnotation msa : gene.getMolecularSequenceAnnotationCollection()) {
            ISOAssert.assertConsistent(msa.getSource());
            
            if (msa instanceof DiseaseAssociation) {
                DiseaseAssociation da = (DiseaseAssociation)msa;
                ISOAssert.assertConsistent(da.getSource());
                ISOAssert.assertConsistent(da.getRole());
                assertNotNull(da.getDisease());
                Disease disease = da.getDisease();
                ISOAssert.assertConsistent(disease.getName());
                ISOAssert.assertConsistent(disease.getNameCode());
            }
            else if (msa instanceof AgentAssociation) {
                AgentAssociation aa = (AgentAssociation)msa;
                ISOAssert.assertConsistent(aa.getSource());
                ISOAssert.assertConsistent(aa.getRole());
                assertNotNull(aa.getTherapeuticAgent());
                TherapeuticAgent agent = aa.getTherapeuticAgent();
                ISOAssert.assertConsistent(agent.getName());
                ISOAssert.assertConsistent(agent.getNameCode());
                ISOAssert.assertConsistent(agent.getDescription());
            }
            else if (msa instanceof OntologyAnnotation) {
                OntologyAnnotation oa = (OntologyAnnotation)msa;
                ISOAssert.assertConsistent(oa.getSource());
                ISOAssert.assertConsistent(oa.getTerm());
            }
        }
    }

    private Gene getHumanGene(String symbolValue) throws Exception {

        Gene criteria = new Gene();
        St symbol = new St();
        symbol.setValue(symbolValue);
        criteria.setSymbol(symbol);
        
        Organism organism = new Organism();
        St commonName = new St();
        commonName.setValue("human");
        organism.setCommonName(commonName);
        criteria.setOrganism(organism);
        
        List<Gene> results = 
            getApplicationService().search(Gene.class, criteria);
        
        assertEquals(1,results.size());
        
        return results.get(0);
    }
	
}
