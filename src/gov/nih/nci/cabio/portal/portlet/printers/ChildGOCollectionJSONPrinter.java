package gov.nih.nci.cabio.portal.portlet.printers;

import gov.nih.nci.cabio.domain.GeneOntology;
import gov.nih.nci.cabio.domain.GeneOntologyRelationship;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Prints a ontology term collection in JSON format. 
 * @see GeneCollectionJSONPrinter
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ChildGOCollectionJSONPrinter extends ParentGOCollectionJSONPrinter {

    protected Collection<GeneOntology> getTerms(Object obj) {
        Collection<GeneOntologyRelationship> collection = 
            (Collection<GeneOntologyRelationship>)obj;
        List<GeneOntology> terms = new ArrayList<GeneOntology>();
        for(GeneOntologyRelationship gor : collection) {
            terms.add(gor.getChildGeneOntology());
        }
        return terms;
    }
    
}
