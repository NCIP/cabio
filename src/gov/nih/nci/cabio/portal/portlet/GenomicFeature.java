package gov.nih.nci.cabio.portal.portlet;

/**
 * Enumeration of caBIO domain classes which are genomic features. A class 
 * is a genomic feature if it has a physicalLocationCollection. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public enum GenomicFeature {

    GenePhysicalLocation("Genes"),
    SNPPhysicalLocation("SNPs"),
    NucleicAcidPhysicalLocation("Nucleic Acid Sequences"),
    MarkerPhysicalLocation("Genomic Markers"),
    TranscriptPhysicalLocation("Transcripts"),
    CytobandPhysicalLocation("Cytobands"),
    ArrayReporterPhysicalLocation("Microarray Reporters");

    private static final String PACKAGE = "gov.nih.nci.cabio.domain.";
            
    private String label;
    
    private GenomicFeature(String label) {
        this.label = label;
    }

    public String getValue() {
        return PACKAGE+toString();
    }
    
    public String getLabel() {
        return label;
    }
    
}