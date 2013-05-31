/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.CytogeneticLocation;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.common.domain.DatabaseCrossReference;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.ArrayList;
import java.util.Collection;

/**
 * Examples of Array Annotation API usage.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class TestAnnotationAPI {

    public static void main(String[] args) throws Exception {
        
        CaBioApplicationService appService = 
            (CaBioApplicationService)ApplicationServiceProvider.getApplicationService();

        // The ArrayAnnotationService is a client-side convienence API on top
        // of the CaBioApplicationService.
        ArrayAnnotationService am = new ArrayAnnotationServiceImpl(appService);

        Collection<String> reporterIds = new ArrayList<String>();
        reporterIds.add("1552566_at");
        reporterIds.add("1554235_at");
        reporterIds.add("1553169_at");
        
        Collection<ExpressionArrayReporter> reps = 
            am.getExpressionReporterAnnotations("HG-U133_Plus_2", reporterIds);

        Collection<String> geneSymbols = new ArrayList<String>();
        
        System.out.println("\nReporter annotations");
        for(ExpressionArrayReporter rep : reps) {

            // Some associations have been preloaded.
            // The next few lines do not run any additional queries.

            CytogeneticLocation cloc = rep.getCytogeneticLocationCollection().iterator().next();
            PhysicalLocation loc = rep.getPhysicalLocationCollection().iterator().next();
            String chrom = loc.getChromosome().getNumber();
            Gene gene = rep.getGene();
            
            System.out.println(rep.getName()+"\tChromosome:"+chrom+
                "\tCytoband:"+cloc.getStartCytoband().getName()+
                "\tLocation:"+loc.getChromosomalStartPosition()+
                "-"+loc.getChromosomalEndPosition()+
                "\tGene:"+gene.getHugoSymbol());
           
            geneSymbols.add(gene.getHugoSymbol());   
        }

        System.out.println("\nGene annotations");
        Collection<Gene> genes = am.getGeneAnnotations(geneSymbols);
        for(Gene gene : genes) {
            
            // only one DatabaseCrossReference (LOCUS_LINK_ID) has been 
            // preloaded, so we can be sure it's the first and only one in there
            DatabaseCrossReference locusRef = 
                gene.getDatabaseCrossReferenceCollection().iterator().next();
            
            System.out.println("HUGO:"+gene.getHugoSymbol()+
                "\t"+locusRef.getDataSourceName()+
                ":"+locusRef.getCrossReferenceId()+
                "\tName:"+gene.getFullName());
        }
    }
}