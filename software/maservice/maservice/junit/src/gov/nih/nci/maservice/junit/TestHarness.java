package gov.nih.nci.maservice.junit;

import gov.nih.nci.iso21090.St;
import gov.nih.nci.maservice.domain.ArrayReporter;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.GeneIdentifier;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.VariationIdentifier;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.List;

public class TestHarness {

    public static void main(String[] args) throws Exception {

        String url = "http://localhost:8080/maservice";
        MaApplicationService appService = 
            (MaApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(url);
        
        GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
        St symbolOrAlias = new St();
        symbolOrAlias.setValue("BRCA1");
        St commonName = new St();
        commonName.setValue("human");
        Organism organism = new Organism();
        organism.setCommonName(commonName);
        geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
        geneSearchCriteria.setOrganism(organism);
        
        List<Gene> genes = appService.getGenesBySymbol(geneSearchCriteria);
        
        for(Gene gene : genes) {
            System.out.println("Gene: "+gene.getSymbol().getValue());
            System.out.println("Identifiers:");
            for(GeneIdentifier id : gene.getGeneIdentifierCollection()) {
                System.out.println("----------");
                System.out.println("  identifier.root: "+id.getIdentifier().getRoot());
                System.out.println("  identifier.extension: "+id.getIdentifier().getExtension());
                System.out.println("  databaseName.originalText: "+id.getDatabaseName().getOriginalText().getValue());
                System.out.println("  databaseName.codeSystem: "+id.getDatabaseName().getCodeSystem());
                System.out.println("  databaseName.codeSystemName: "+id.getDatabaseName().getCodeSystemName());
            }
            System.out.println("Variations:");
            for(NucleicAcidSequenceVariation variation : gene.getNucleicAcidSequenceVariationCollection()) {
                System.out.println("----------");
                System.out.println("  "+variation.getClass().getSimpleName());
                
                for(VariationIdentifier id : variation.getVariationIdentifierCollection()) {
                    System.out.println("  ----------");
                    System.out.println("    identifier.root: "+id.getIdentifier().getRoot());
                    System.out.println("    identifier.extension: "+id.getIdentifier().getExtension());
                    System.out.println("    databaseName.originalText: "+id.getDatabaseName().getOriginalText().getValue());
                    System.out.println("    databaseName.codeSystem: "+id.getDatabaseName().getCodeSystem());
                    System.out.println("    databaseName.codeSystemName: "+id.getDatabaseName().getCodeSystemName());
                }
            }
            System.out.println("Reporters:");
            for(ArrayReporter ar : gene.getArrayReporterCollection()) {
                System.out.println("----------");
                System.out.println("  id: "+ar.getId().getExtension());
                System.out.println("  name: "+ar.getName().getValue());
                System.out.println("  microarray.name: "+ar.getMicroarray().getName().getValue());
            }
        }
    }
}
