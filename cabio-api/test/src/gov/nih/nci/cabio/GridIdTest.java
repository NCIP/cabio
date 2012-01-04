package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.*;

public class GridIdTest extends GridIdTestBase {

    public void testAgent() throws Exception {
        testGridId(new Agent());
    }

    public void testClinicalTrialProtocol() throws Exception {
        testGridId(new ClinicalTrialProtocol());
    }

    public void testCytoband() throws Exception {
        testGridId(new Cytoband());
    }

    public void testDiseaseOntology() throws Exception {
        testGridId(new DiseaseOntology());
    }

    public void testGeneOntology() throws Exception {
        testGridId(new GeneOntology());
    }

    public void testNucleicAcidSequence() throws Exception {
        testGridId(new NucleicAcidSequence());
    }

    public void testOrganOntology() throws Exception {
        testGridId(new OrganOntology());
    }

    public void testPathway() throws Exception {
        testGridId(new Pathway());
    }

    public void testProtein() throws Exception {
        testGridId(new Protein());
    }

    public void testProtocol() throws Exception {
        testGridId(new Protocol());
    }

    public void testTarget() throws Exception {
        testGridId(new Target());
    }

    public void testTaxon() throws Exception {
        testGridId(new Taxon());
    }

    public void testVocabulary() throws Exception {
        testGridId(new Vocabulary());
    }

    public void testAnomaly() throws Exception {
        testGridId(new Anomaly());
    }

    public void testClone() throws Exception {
        testGridId(new Clone());
    }

    public void testChromosome() throws Exception {
        testGridId(new Chromosome());
    }

    public void testDiseaseOntologyRelationship() throws Exception {
        testGridId(new DiseaseOntologyRelationship());
    }

    public void testGene() throws Exception {
        testGridId(new Gene());
    }

    public void testGeneAlias() throws Exception {
        testGridId(new GeneAlias());
    }

    public void testGeneOntologyRelationship() throws Exception {
        testGridId(new GeneOntologyRelationship());
    }

    public void testHomologousAssociation() throws Exception {
        testGridId(new HomologousAssociation());
    }

    public void testLibrary() throws Exception {
        testGridId(new Library());
    }

    public void testCloneRelativeLocation() throws Exception {
        testGridId(new CloneRelativeLocation());
    }

    public void testOrganOntologyRelationship() throws Exception {
        testGridId(new OrganOntologyRelationship());
    }

    public void testProteinAlias() throws Exception {
        testGridId(new ProteinAlias());
    }

    public void testProteinSequence() throws Exception {
        testGridId(new ProteinSequence());
    }

    public void testProtocolAssociation() throws Exception {
        testGridId(new ProtocolAssociation());
    }

    public void testSNP() throws Exception {
        testGridId(new SNP());
    }

    public void testPopulationFrequency() throws Exception {
        testGridId(new PopulationFrequency());
    }

    public void testCytogeneticLocation() throws Exception {
        testGridId(new CytogeneticLocation());
    }

    public void testMicroarray() throws Exception {
        testGridId(new Microarray());
    }

    public void testExonArrayReporter() throws Exception {
        testGridId(new ExonArrayReporter());
    }

    public void testExpressionArrayReporter() throws Exception {
        testGridId(new ExpressionArrayReporter());
    }

    public void testSNPArrayReporter() throws Exception {
        testGridId(new SNPArrayReporter());
    }

    public void testExon() throws Exception {
        testGridId(new Exon());
    }

    public void testTranscript() throws Exception {
        testGridId(new Transcript());
    }

    public void testProteinDomain() throws Exception {
        testGridId(new ProteinDomain());
    }

    public void testMarker() throws Exception {
        testGridId(new Marker());
    }

    public void testGeneRelativeLocation() throws Exception {
        testGridId(new GeneRelativeLocation());
    }

    public void testMarkerRelativeLocation() throws Exception {
        testGridId(new MarkerRelativeLocation());
    }

    public static void main(String[] argv) throws Exception {
        GridIdTest test = new GridIdTest();
        test.setUp();
        test.testHomologousAssociation();
    }
}
