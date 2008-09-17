package gov.nih.nci.cabio.portal.portlet;

public enum GenomicFeature {

    GenePhysicalLocation("Gene"),
    SNPPhysicalLocation("SNP"),
    NucleicAcidPhysicalLocation("Nucleic Acid Sequence"),
    MarkerPhysicalLocation("Genomic Marker"),
    TranscriptPhysicalLocation("Transcript"),
    CytobandPhysicalLocation("Cytoband"),
    ArrayReporterPhysicalLocation("Microarray Reporter");

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