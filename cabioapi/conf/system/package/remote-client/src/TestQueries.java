/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.domain.Agent;
import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Clone;
import gov.nih.nci.cabio.domain.CloneRelativeLocation;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneOntology;
import gov.nih.nci.cabio.domain.Histopathology;
import gov.nih.nci.cabio.domain.Library;
import gov.nih.nci.cabio.domain.NucleicAcidSequence;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.Protein;
import gov.nih.nci.cabio.domain.ProteinAlias;
import gov.nih.nci.cabio.domain.Target;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.common.provenance.domain.InternetSource;
import gov.nih.nci.common.provenance.domain.Provenance;
import gov.nih.nci.common.provenance.domain.URLSourceReference;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * TestQueries.java demonstartes various ways to execute searches with and
 * without using Application Service Layer (convenience layer that abstracts
 * building criteria. Uncomment different scenarios below to demonstrate the
 * various types of searches.
 *
 * @author caBIO Team
 */
public class TestQueries {

    public static void main(String[] args) throws Exception {

        System.out.println("*** TestQueries...");

        CaBioApplicationService appService = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();

        /**
         * Common variables for the test cases below
         */
        // _gene0 is an empty Gene
        Gene _gene0 = new Gene();

        Taxon _taxon = new Taxon();
        _taxon.setId(new Long(5));

        // _gene1 contain a taxon.id=5 object
        Gene _gene1 = new Gene();
        _gene1.setTaxon(_taxon);

        Gene _gene2 = new Gene();
        _gene2.setId(new Long(2));

        Gene _gene3 = new Gene();
        _gene3.setSymbol("D*");

        Library _lib1 = new Library();
        _lib1.setId(new Long(22));

        Library _lib2 = new Library();
        _lib2.setId(new Long(33));

        List<Library> _libList = new ArrayList<Library>();
        _libList.add(_lib1);
        _libList.add(_lib2);

        Target _target1 = new Target();
        _target1.setId(new Long(61));

        Target _target2 = new Target();
        _target2.setId(new Long(42));

        List<Target> _targetList = new ArrayList<Target>();
        _targetList.add(_target1);
        _targetList.add(_target2);

        Chromosome _chrom = new Chromosome();
        _chrom.setNumber("11");

        Gene _gene4 = new Gene();
        _gene4.setId(new Long(20));
        _gene4.setChromosome(_chrom);

        Gene _gene5 = new Gene();
        _gene5.setTargetCollection(_targetList);

        Gene _gene6 = new Gene();
        _gene6.setSymbol("brca*");

        // _protein contains a list of genes and also with the name
        // attribute set wild card
        Protein _protein = new Protein();
        List<Gene> _geneList = new ArrayList<Gene>();
        _geneList.add(_gene2);
        _geneList.add(_gene3);
        _protein.setGeneCollection(_geneList);
        _protein.setName("*b-27*");

        List<Object> _geneList2 = new ArrayList<Object>();
        _geneList2.add(_gene2);
        _geneList2.add(_gene5);

        Target _target = new Target();
        _target.setGeneCollection(_geneList);

        Target _target3 = new Target();
        _target3.setName("CD*");

        NucleicAcidSequence _seq1 = new NucleicAcidSequence();
        _seq1.setId(new Long(1507));

        Clone _clone1 = new Clone();
        _clone1.setId(new Long(1420));
        // _clone1.setName("IMAGE:5228554");

        NucleicAcidSequence _seq2 = new NucleicAcidSequence();
        _seq2.setAccessionNumber("AA247215");

        // Test Case 1: search for the same kind of object. _gene3 has
        // certain criteria set
        try {
            System.out.println("\n\n\nTest Case 1: search for the same kind of object search(\"Gene\", _gene3), ");

            List resultList1 = appService.search("gov.nih.nci.cabio.domain.Gene",
                _gene3);

            if (resultList1.size() < 1) {
                System.out.println("(Test Case 1 ) No records found");
            }
            else {
                System.out.println("(Test Case 1 )Total # of  records = "
                        + resultList1.size());
                Iterator iterator = resultList1.iterator();
                while (iterator.hasNext()) {
                    Gene gene = (Gene) iterator.next();
                    System.out.println(" result id = " + gene.getId()
                            + " | result name = " + gene.getSymbol());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 2: have the same name in the search path
        try {
            System.out.println("\n\n\nTest Case 2: search(\"Taxon, Taxon\", gene), gene.id = 10, should have one result back.");

            List resultList2 = appService.search(
                "gov.nih.nci.cabio.domain.Taxon,gov.nih.nci.cabio.domain.Taxon",
                _gene2);

            if (resultList2.size() < 1) {
                System.out.println("(Test Case 2 ) No records found");
            }
            else {
                System.out.println("(Test Case 2 )Total # of  records = "
                        + resultList2.size());

                Iterator iterator = resultList2.iterator();
                while (iterator.hasNext()) {
                    Taxon taxon = (Taxon) iterator.next();
                    System.out.println(" result id = " + taxon.getId()
                            + " | result name = " + taxon.getAbbreviation());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 3: Query objects with an empty object(no attribute,
        // no association set)
        try {
            System.out.println("\n\n\nTest Case 3: search(\"Taxon\", gene), , should get all genes back.");
            List resultList3 = appService.search(
                "gov.nih.nci.cabio.domain.Chromosome", _gene0);
            if (resultList3.size() < 1) {
                System.out.println("(Test Case 3) No records found");
            }
            else {
                System.out.println("(Test Case 3 )Total # of  records = "
                        + resultList3.size());
                Iterator iterator = resultList3.iterator();
                while (iterator.hasNext()) {
                    Chromosome chrom = (Chromosome) iterator.next();
                    System.out.println(" result id = " + chrom.getId()
                            + " | result number = " + chrom.getNumber());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 4: Query Pathway object to test CLOB
        try {
            System.out.println("\n\n\nTest Case 4: search(\"Pathway\", gene).  Testing for CLOB datatype");
            List resultList4 = appService.search(
                "gov.nih.nci.cabio.domain.Pathway", _gene6);
            if (resultList4.size() < 1) {
                System.out.println("(Test Case 4) No records found");
            }
            else {
                System.out.println("(Test Case 4 )Total # of  records = "
                        + resultList4.size());
                Iterator iterator = resultList4.iterator();
                while (iterator.hasNext()) {
                    Pathway pathway = (Pathway) iterator.next();
                    System.out.println(" result id = " + pathway.getId()
                            + " | result name = " + pathway.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 5: Testing type 1 nested query.
        try {
            System.out.println("\n\n\nTest Case 5: search(\"ProteinAlias,Protein,Gene\", chromosome).  Testing type 1 nested Query");
            List resultList5 = appService.search(
                "gov.nih.nci.cabio.domain.ProteinAlias,"
                        + "gov.nih.nci.cabio.domain.Protein,"
                        + "gov.nih.nci.cabio.domain.Gene", _chrom);
            if (resultList5.size() < 1) {
                System.out.println("(Test Case 5) No records found");
            }
            else {
                System.out.println("(Test Case 5 )Total # of  records = "
                        + resultList5.size());
                Iterator iterator = resultList5.iterator();
                while (iterator.hasNext()) {
                    ProteinAlias proteinA = (ProteinAlias) iterator.next();
                    System.out.println(" result id = " + proteinA.getId()
                            + " | result name = " + proteinA.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 6: Nested Query combine type 1 and 2. Chromosome
        // object contains a list of Gene
        try {
            System.out.println("\n\n\nTest Case 6: search(\"Chromosome\", GeneList).  list query ... ...");
            List resultList6 = appService.search(
                "gov.nih.nci.cabio.domain.Chromosome", _geneList);
            if (resultList6.size() < 1) {
                System.out.println("(Test Case 6) No records found");
            }
            else {
                System.out.println("(Test Case 6 )Total # of  records = "
                        + resultList6.size());
                Iterator iterator = resultList6.iterator();
                while (iterator.hasNext()) {
                    Chromosome chrom = (Chromosome) iterator.next();
                    System.out.println(" result id = " + chrom.getId()
                            + " | result number = " + chrom.getNumber());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 7: Nested Query type 2. TARGET object contains a
        // list of Gene
        try {
            System.out.println("\n\n\nTest Case 7: search(\"Agent\", Target).  Testing type 2 nested Query");
            List resultList7 = appService.search("gov.nih.nci.cabio.domain.Agent",
                _target3);
            if (resultList7.size() < 1) {
                System.out.println("(Test Case 7) No records found");
            }
            else {
                System.out.println("(Test Case 7 )Total # of  records = "
                        + resultList7.size());
                Iterator iterator = resultList7.iterator();
                while (iterator.hasNext()) {
                    Agent agent = (Agent) iterator.next();
                    System.out.println(" result id = " + agent.getId()
                            + " | result name = " + agent.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 8: Combine type 2 and list query, one of gene
        // object in the list contains another collection
        try {
            System.out.println("\n\n\nTest Case 8: search(\"Protein, Gene\", Sequence) (// bi-direction (sequence m -> m gene m -> m protein).  Testing type 2 nested Query");
            List resultList9 = appService.search(
                "gov.nih.nci.cabio.domain.Protein,gov.nih.nci.cabio.domain.Gene",
                _seq1);
            if (resultList9.size() < 1) {
                System.out.println("(Test Case 8) No records found");
            }
            else {
                System.out.println("(Test Case 8 )Total # of  records = "
                        + resultList9.size());
                Iterator iterator = resultList9.iterator();
                while (iterator.hasNext()) {
                    Protein protein = (Protein) iterator.next();
                    System.out.println(" result id = " + protein.getId()
                            + " | result name = " + protein.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 9: Combine type 2 and list query, one of gene
        // object in the list contains another collection
        try {
            System.out.println("\n\n\nTest Case 9: search(\"Sequence\", Clone) (// uni-direction (clone 1 -> m sequence). ");
            List resultList10 = appService.search(
                "gov.nih.nci.cabio.domain.NucleicAcidSequence", _clone1);
            if (resultList10.size() < 1) {
                System.out.println("(Test Case 9) No records found");
            }
            else {
                System.out.println("(Test Case 9 )Total # of  records = "
                        + resultList10.size());
                Iterator iterator = resultList10.iterator();
                while (iterator.hasNext()) {
                    NucleicAcidSequence seq = (NucleicAcidSequence) iterator.next();
                    System.out.println(" result id = " + seq.getId()
                            + " | result accessionNumber = "
                            + seq.getAccessionNumber());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 10: Combine type 2 and list query, one of gene
        // object in the list contains another collection
        try {
            System.out.println("\n\n\nTest Case 10: search(\"Sequence\", Sequence), Get sequence from sequnce accession number");
            List resultList11 = appService.search("gov.nih.nci.cabio.domain.Clone",
                _clone1);
            if (resultList11.size() < 1) {
                System.out.println("(Test Case 10) No records found");
            }
            else {
                System.out.println("(Test Case 10 )Total # of  records = "
                        + resultList11.size());
                Iterator iterator = resultList11.iterator();
                while (iterator.hasNext()) {
                    Clone seq = (Clone) iterator.next();
                    System.out.println(" result id = " + seq.getId()
                            + " | result name = " + seq.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 11: uni-direction (nested) (clone 1 -> m sequence m
        // -> m gene)
        try {
            System.out.println("\n\n\nTest Case 11: search(\"Gene, Sequence\", Clone), // uni-direction (nested) (clone 1 -> m sequence m -> m gene)");
            List resultList12 = appService.search(
                "gov.nih.nci.cabio.domain.Gene, gov.nih.nci.cabio.domain.NucleicAcidSequence",
                _clone1);
            if (resultList12.size() < 1) {
                System.out.println("(Test Case 11) No records found");
            }
            else {
                System.out.println("(Test Case 11 )Total # of  records = "
                        + resultList12.size());
                Iterator iterator = resultList12.iterator();
                while (iterator.hasNext()) {
                    Gene gene = (Gene) iterator.next();
                    System.out.println(" result id = " + gene.getId()
                            + " | result symbol = " + gene.getSymbol());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 12: Many-to-Many Unidirectional relationship (Use
        // Pathway to get Histopathology)
        try {
            System.out.println("\n\n\nTest Case 12: search(\"Histopathology\", Pathway),Many-to-Many Unidirectional relationship... ...");
            Pathway _pathway1 = new Pathway();
            _pathway1.setName("h_C*");
            List resultList19 = appService.search(
                "gov.nih.nci.cabio.domain.Histopathology", _pathway1);
            if (resultList19.size() < 1) {
                System.out.println("\n(Test Case 12: many-to-many Unidirectional) No records found");
            }
            else {
                System.out.println("\n(Test Case 12: Many-to-many Unidirectional) Total # of  records = "
                        + resultList19.size());
                Iterator iterator = resultList19.iterator();
                while (iterator.hasNext()) {
                    Histopathology his = (Histopathology) iterator.next();
                    System.out.println(" result id = " + his.getId()
                            + " | result description = " + his.getComments());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 13: Two level test
        // Use Chromosome number "Y" get 290 Genes back, it will work
        // Use Chromosome number "1" get 5749 Genes back, then it will
        // NOT work to get SNP
        try {
            System.out.println("\n\n\nTest Case 13: search(\"GeneOntology, Gene\", Chromosome), two level nested query... ...");
            Chromosome _chrom2 = new Chromosome();
            _chrom2.setNumber("Y");
            List resultList20 = appService.search(
                "gov.nih.nci.cabio.domain.GeneOntology,gov.nih.nci.cabio.domain.Gene",
                _chrom2); // return total 87
            if (resultList20.size() < 1) {
                System.out.println("\n(Test Case 13: two levels Chromosome->Gene->GeneOntology) No records found");
            }
            else {
                System.out.println("\n(Test Case 13: two levels Chromosome->Gene->GeneOntology) Total # of  records = "
                        + resultList20.size());
                Iterator iterator = resultList20.iterator();
                while (iterator.hasNext()) {
                    GeneOntology go = (GeneOntology) iterator.next();
                    System.out.println(" result id = " + go.getId()
                            + " | result name = " + go.getName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 14: many-to-one relationship Bidirectional (Use
        // Gene to get Taxon)
        try {
            System.out.println("\n\n\nTest Case 14: search(\"Taxon\", Gene),many-to-one relationship Bidirectional... ...");
            List resultList14 = appService.search("gov.nih.nci.cabio.domain.Taxon",
                _gene2);
            if (resultList14.size() < 1) {
                System.out.println("\n(Test Case 14: many-to-one Bidirectional) No records found");
            }
            else {
                System.out.println("\n(Test Case 14: many-to-one Bidirectional) Total # of  records = "
                        + resultList14.size());
                Iterator iterator = resultList14.iterator();
                while (iterator.hasNext()) {
                    Taxon taxon = (Taxon) iterator.next();
                    System.out.println(" result id = " + taxon.getId()
                            + " | result name = " + taxon.getCommonName());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 15: one-to-many bidirectional relationship (Use
        // Target to get Gene)
        try {
            System.out.println("\n\n\nTest Case 15: search(\"Gene\", Target),one-to-many bidirectional relationship... ...");
            List resultList15 = appService.search("gov.nih.nci.cabio.domain.Gene",
                _target3);
            if (resultList15.size() < 1) {
                System.out.println("\n(Test case 15: one-to-many Bidirectional) No records found");
            }
            else {
                System.out.println("\n(Test case 15: one-to-many Bidirectional) Total # of  records = "
                        + resultList15.size());
                Iterator iterator = resultList15.iterator();
                while (iterator.hasNext()) {
                    Gene gene = (Gene) iterator.next();
                    System.out.println(" result id = " + gene.getId()
                            + " | result Symbol = " + gene.getSymbol());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // One-to-One relationship
        // Test Case 16: one-to-one bidirectional relationship (Use
        // CloneRelativeLocation to get NucleicAcidSequence)
        try {
            System.out.println("\n\n\nTest Case 16: search(\"NucleicAcidSequence\", CloneRelativeLocation),one-to-one bidirectional relationship... ...");
            CloneRelativeLocation _crlocation = new CloneRelativeLocation();
            _crlocation.setId(new Long(5));
            List resultList16 = appService.search(
                "gov.nih.nci.cabio.domain.NucleicAcidSequence", _crlocation);
            if (resultList16.size() < 1) {
                System.out.println("\n(Test case 16: one-to-one Bidirectional) No records found");
            }
            else {
                System.out.println("\n(Test case 16: One-to-One Bidirectional) Total # of  records = "
                        + resultList16.size());
                Iterator iterator = resultList16.iterator();
                while (iterator.hasNext()) {
                    NucleicAcidSequence seq = (NucleicAcidSequence) iterator.next();
                    System.out.println(" result id = " + seq.getId()
                            + " | result accession number = "
                            + seq.getAccessionNumber());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Grid Identifier test
        // Test Case 17: Get Grid Identifier

        try {
            Gene gene = new Gene();
            gene.setSymbol("brca*");
            System.out.println("\n\n\nTest Case 17: Search for Gene grid identifier: "
                    + gene.getSymbol());
            List results = appService.search("gov.nih.nci.cabio.domain.Gene", gene);
            for (int i = 0; i < results.size(); i++) {
                Gene g = (Gene) results.get(i);
                System.out.println("Gene: " + g.getId() + "\t" + g.getSymbol()
                        + "\t" + g.getBigid());
                try {
                    System.out.println("\tGrid Id exists: "
                            + appService.exist(g.getBigid()));
                    Gene dataObject = (Gene) appService.getDataObject(g.getBigid());
                    System.out.println("\tResult: " + dataObject.getId() + "\t"
                            + dataObject.getSymbol() + "\t" + dataObject.getBigid());
                }
                catch (Exception ex) {
                    System.out.println("\tError: " + ex.getMessage());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        // Test Case 18: Test Provence Provenance
        try {
            Protein pro = new Protein();
            pro.setName("BRCA*");
            System.out.println("\n\n\nTest Case 18: Search Provenance for Protein: "
                    + pro.getName());
            List protList = appService.search(Protein.class, pro);

            for (int i = 0; i < protList.size(); i++) {
                Protein protein = (Protein) protList.get(i);
                System.out.println("Protein " + protein.getName() + ":"
                        + protein.getId());

                // Now the Provenance
                Provenance p = new Provenance();
                p.setFullyQualifiedClassName("gov.nih.nci.cabio.domain.Protein");
                p.setObjectIdentifier(protein.getId().toString());

                List resultList = appService.search(Provenance.class, p);
                System.out.println("Returned: " + resultList.size() + " records");
                Provenance provenance = (Provenance) resultList.get(0);

                InternetSource source = (InternetSource) provenance.getSupplyingSource();
                System.out.println("Supplying: " + source.getOwnerInstitution());
                InternetSource immediateSource = (InternetSource) provenance.getImmediateSource();
                System.out.println("Immediate: "
                        + immediateSource.getOwnerInstitution());
                InternetSource originalSource = (InternetSource) provenance.getOriginalSource();
                System.out.println("Original: "
                        + originalSource.getOwnerInstitution());

                URLSourceReference sourceReference = (URLSourceReference) provenance.getSourceReference();
                System.out.println("Type: "
                        + sourceReference.getSourceReferenceType() + "\nURL: "
                        + sourceReference.getSourceURL());
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

    }
}