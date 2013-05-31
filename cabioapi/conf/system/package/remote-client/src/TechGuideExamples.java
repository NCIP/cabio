/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.cabio.domain.ProteinSequence;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;


/**
 * Query examples from the caBIO Technical Guide.
 *
 * For CQL examples, see the CQLTest class.
 *
 * @author caBIO Team
 */
public class TechGuideExamples {

    public static void main(String[] args) throws Exception {

        System.out.println("*** Tech Guide Examples");

        ApplicationService appService =
            ApplicationServiceProvider.getApplicationService();

        /** Examples used in Developer Guide */

        try {
            System.out.println("\nExample One: Simple Search (Single Criteria Object)");
            Gene gene = new Gene();
            // searching for all genes whose symbol starts with brca
            gene.setSymbol("brca*");

            List resultList = appService.search(Gene.class, gene);

            for (Iterator resultsIterator = resultList.iterator(); resultsIterator.hasNext();) {
                Gene returnedGene = (Gene) resultsIterator.next();
                System.out.println("Symbol: " + returnedGene.getSymbol()
                        + "\tTaxon:"+ returnedGene.getTaxon().getScientificName()
                        + "\tName " + returnedGene.getFullName());
            }
        }
        catch (RuntimeException e) {
            e.printStackTrace();
        }

        try  {
            System.out.println("\nExample Two: Simple Search (Criteria Object Collection)");
            Taxon taxon1 = new Taxon();
            taxon1.setAbbreviation("hs");       // Homo sapiens
            Taxon taxon2 = new Taxon();
            taxon2.setAbbreviation("m");        // Mus musculus
            List<Taxon> taxonList = new ArrayList<Taxon>();
            taxonList.add(taxon1);
            taxonList.add(taxon2);
            List resultList = appService.search(Gene.class, taxonList);
            System.out.println("Total # of records = " + resultList.size());

        }
        catch (Exception e) {
            e.printStackTrace();
        }

        try {
            System.out.println("\nExample Three: Simple Search (Compound Criteria Object)");
            Taxon taxon = new Taxon();
            taxon.setAbbreviation("hs");         // Homo sapiens
            Gene gene = new Gene();
            gene.setTaxon(taxon);
            gene.setSymbol("IL5");               // Interleukin 5
            List<Gene> geneList = new ArrayList<Gene>();
            geneList.add(gene);
            Pathway pathway = new Pathway();
            pathway.setGeneCollection(geneList);
            List resultList = appService.search("gov.nih.nci.cabio.domain.Pathway", pathway);
            for (Iterator resultsIterator = resultList.iterator(); resultsIterator.hasNext();)
            {
                Pathway returnedPathway = (Pathway)resultsIterator.next();
                System.out.println("Name: "+returnedPathway.getName()
                    + "\tDisplayValue: " + returnedPathway.getDisplayValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try  {
            System.out.println("\nExample Four: Nested Search");
            Gene gene = new Gene();
            gene.setSymbol("TP53"); // Tumor protein p53 (Li-Fraumeni syndrome)
            List resultList = appService.search(
                "gov.nih.nci.cabio.domain.ProteinSequence,gov.nih.nci.cabio.domain.Protein",
                gene);
            for (Iterator resultsIterator = resultList.iterator(); resultsIterator.hasNext();)
            {
                ProteinSequence returnedProtSeq = (ProteinSequence)resultsIterator.next();
                System.out.println("Id: " + returnedProtSeq.getId() +
                    "\tLength: " + returnedProtSeq.getLength() );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            System.out.println("\nExample Five: Detached Criteria Search");
            DetachedCriteria criteria = DetachedCriteria.forClass(PhysicalLocation.class);
            criteria = criteria.add(Restrictions.gt("chromosomalStartPosition", new Long(86851632)));
            criteria = criteria.add(Restrictions.lt("chromosomalEndPosition",   new Long(86861632)));
            criteria = criteria.add(Restrictions.ilike("assembly", "reference"));
            criteria = criteria.createCriteria("chromosome").add(Restrictions.eq("number", "1"));
            List resultList = appService.query(criteria);
            System.out.println("Total # of  records = " + resultList.size());
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        try {
            System.out.println("\nExample Six: HQL Search");
            String hqlString = "FROM gov.nih.nci.cabio.domain.Gene g WHERE g.symbol LIKE ?";
            List<String> params = new ArrayList<String>();
            params.add("BRCA%");
            HQLCriteria hqlC = new HQLCriteria(hqlString, params);
            List resultList = appService.query(hqlC);
            System.out.println("Total # of records = " + resultList.size());
        }
        catch (Exception e) {
            e.printStackTrace();
        }

    }
}