/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import java.util.Iterator;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class GenePersistence {

	final private static String TERMINATOR = "%|";

	private static Writer out;
	private static Writer sequenceOut;

    private static Writer linksOut;
    
    private static Writer geneTvOut;
    
    private static Writer geneMarkerOut;
    
    private static Writer geneIdDs2;

    private static Connection conn;

    private static long geneCounter = -1;

    private static GenePersistence onlyInstance = null; // singleton

    private GenePersistence(String filePath) {
        try {
            geneCounter = 1;
            conn = CoreConnection.instance();
            File geneFile = new File(filePath, "gene.dat");
            out = new BufferedWriter(new FileWriter(geneFile));
            File sequenceFile = new File(filePath, "genesequence.dat");
            sequenceOut = new BufferedWriter(new FileWriter(sequenceFile));
            File geneLinkFile = new File(filePath, "genelink.dat");
            linksOut = new BufferedWriter(new FileWriter(geneLinkFile));
            File geneTvFile = new File(filePath, "geneTv.dat");
            geneTvOut = new BufferedWriter(new FileWriter(geneTvFile));
            File geneIdDs2File = new File(filePath, "geneIdDs2.dat");
            geneIdDs2 = new BufferedWriter(new FileWriter(geneIdDs2File));
  
            File geneMarkerFile = new File(filePath, "geneMarker.dat");
            geneMarkerOut = new BufferedWriter(new FileWriter(geneMarkerFile));
      } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Static factory method that makes a single instance of this class.
     */
    public static GenePersistence instance(String filePath) {
        if (onlyInstance == null) {
            onlyInstance = new GenePersistence(filePath);
        }
        return onlyInstance;
    }

    public void addGeneDatabaseLinks(Gene geneToSave, boolean deleteExisting, String myBuffGeneDat, String tax) {
        try {
            Hashtable databaseLinks = geneToSave.getDatabaseLinks();
            long geneID = geneToSave.getGeneDBID();
            Enumeration keys = databaseLinks.keys();
            DataSource currentDataSource = new DataSource();
            if (deleteExisting) {
                Statement stmt = conn.createStatement();
                stmt.execute("delete from zstg_gene_identifiers where gene_id = " + geneID);
                stmt.close();
            }
            while (keys.hasMoreElements()) {
                String key = (String) keys.nextElement();
                String myBuff = "" + geneID + TERMINATOR;
		String tmpVal = "";
                currentDataSource.setDataSourceName(key);
                myBuff = myBuff + currentDataSource.getDataSourceIDByName()+ TERMINATOR;
		tmpVal  = (String)databaseLinks.get(key);
                myBuff = myBuff + tmpVal + TERMINATOR;
                linksOut.write(myBuff + "\n");
	        
	        myBuffGeneDat = myBuffGeneDat.toString() + myBuff + "http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi?ORG="+tax+"&CID="+tmpVal+TERMINATOR+ "http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi?ORG="+tax+"&CID="+tmpVal+TERMINATOR;

		if(currentDataSource.getDataSourceIDByName() == 1)
		geneTvOut.write(myBuffGeneDat.toString() + "\n");
		
		if(currentDataSource.getDataSourceIDByName() == 2)
		geneIdDs2.write(myBuff.toString() + "\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addMarkerDatabaseLinks(Gene geneToSave, boolean deleteExisting, String myBuffGeneDat, String tax) {
        try {
            Vector markerLinks = geneToSave.getmarkerDatabaseLinks();
            long geneID = geneToSave.getGeneDBID();
            Iterator i = markerLinks.iterator();
            if (deleteExisting) {
                Statement stmt = conn.createStatement();
                stmt.execute("delete from zstg_gene_markers where gene_id = " + geneID);
                stmt.close();
            }
            while (i.hasNext()) {
                String myBuff = "" + geneID + TERMINATOR;
                myBuff = myBuff + TERMINATOR + (String)i.next();
		geneMarkerOut.write(myBuff.toString() + "\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addGeneSequences(Gene geneToSave, boolean deleteExisting,
            String taxonName) {

        try {
            Hashtable sequences = geneToSave.getSequences();
            long geneID = geneToSave.getGeneDBID();
            Enumeration keys = sequences.keys();
            Sequence currentSequence;
            if (deleteExisting) {
                Statement stmt = conn.createStatement();
                stmt.execute(
                        "delete from gene_nucleic_acid_sequence where gene_id = "
                        + geneID);
                stmt.close();
            }

            while (keys.hasMoreElements()) {
                String key = (String) keys.nextElement();
                currentSequence = (Sequence) sequences.get(key);
                long seqId = currentSequence.addSequence(taxonName);
                String myBuff = "" + geneID + TERMINATOR + seqId + TERMINATOR;
                sequenceOut.write(myBuff + "\n");

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void getGeneAlias(Gene geneToGet) {
        try {
            Vector alias = new Vector();
            Statement stmt = conn.createStatement();
            String sqlStatement = "select alias from gene_alias ";
            sqlStatement = sqlStatement + " where gene_id = "
                    + geneToGet.getGeneDBID();
            ResultSet rset = stmt.executeQuery(sqlStatement);
            while (rset.next()) {
                alias.add(rset.getString(1));
            }
            rset.close();
            stmt.close();
            geneToGet.setAlias(alias);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void getGeneDatabaseLinks(Gene geneToGet) {
        try {
            Hashtable databaseLinks = new Hashtable();
            Statement stmt = conn.createStatement();
            String sqlStatement = "select data_source_name, identifier from zstg_gene_identifiers gi, data_source ds ";
            sqlStatement = sqlStatement
                    + " where gi.data_source = ds.data_source_id ";
            sqlStatement = sqlStatement + " and gene_id = "
                    + geneToGet.getGeneDBID();
            ResultSet rset = stmt.executeQuery(sqlStatement);
            while (rset.next()) {
                databaseLinks.put(rset.getString(1), rset.getString(2));
            }
            rset.close();
            stmt.close();
            geneToGet.setDatabaseLinks(databaseLinks);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

/*    public void getmarkerDatabaseLinks(Gene geneToGet) {
        try {
            Hashtable markerdatabaseLinks = new Hashtable();
            Statement stmt = conn.createStatement();
            String sqlStatement = "select marker_id from zstg_gene_markers gi where ";
            sqlStatement = sqlStatement + " gene_id = "
                    + geneToGet.getGeneDBID();
            ResultSet rset = stmt.executeQuery(sqlStatement);
            while (rset.next()) {
                markerdatabaseLinks.put(rset.getString(1), rset.getString(2));
            }
            rset.close();
            stmt.close();
            geneToGet.setMarkerDatabaseLinks(markerdatabaseLinks);
        } catch (Exception e) {
            e.printStackTrace();
        }

    } */
    /**
     * Flush and close the output files.
     */
    public void cleanup() {
        try {
            out.flush();
            out.close();
            linksOut.flush();
            linksOut.close();
            sequenceOut.flush();
            sequenceOut.close();
	    geneTvOut.flush();
	    geneTvOut.close();
	    geneIdDs2.flush();
	    geneIdDs2.close();
	    geneMarkerOut.flush();
	    geneMarkerOut.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addGene(Gene geneToSave) {
        try {
            geneCounter++;
            /* check to make sure chromosome exists */
            Chromosome currentChromosome = geneToSave.getChromosome();
            geneToSave.setGeneDBID(geneCounter);
            String myBuff = "" + geneCounter + TERMINATOR;
            String symbol = geneToSave.getSymbol();
            String title = geneToSave.getTitle();
            String hAlias =  geneToSave.getHugoAlias();
	    if ( (geneCounter >=232) && (geneCounter <=235) ) {
	         System.out.println("Hugo Alias is " + hAlias); 
	         System.out.println("Gene Symbol is " + symbol); 
	         System.out.println("Gene title is " + title); 
	         System.out.println("Gene Id is " + geneCounter); 
	    
		 } 	
            if(hAlias !=null)
            	myBuff = myBuff + geneToSave.getHugoAlias() + TERMINATOR;
            else
                myBuff = myBuff + TERMINATOR;
	    hAlias = null;	
            if (symbol != null)
                myBuff = myBuff + geneToSave.getSymbol() + TERMINATOR;
            else
                myBuff = myBuff + TERMINATOR;
            if (title != null)
                myBuff = myBuff + geneToSave.getTitle() + TERMINATOR;
            else
                myBuff = myBuff + TERMINATOR;
            if (currentChromosome.getChromosomeNumber() != null) {
                long chromosomeID = currentChromosome.addChromosome();
                String temp = String.valueOf(chromosomeID);
                myBuff = myBuff + temp + TERMINATOR;
            } else {
                myBuff = myBuff + TERMINATOR;
            }

            // hard code taxon id as 5 for human and 6 for mouse
            Taxon taxonToSave = geneToSave.getTaxon();
            String taxonName = taxonToSave.getScientificName();
            String tax="";
            if (taxonName.equals("Homo sapiens")){
                myBuff = myBuff + "5" + TERMINATOR;
		tax = "Hs";
            } else if (taxonName.equals("Mus musculus"))
             {   myBuff = myBuff + "6" + TERMINATOR;
		tax = "Mm";
             }
            String cytoband = geneToSave.getCytoband();
	String startCyt = geneToSave.getStartCytoband();
	String endCyt = geneToSave.getEndCytoband();
            if (cytoband != null)
                myBuff = myBuff + cytoband + TERMINATOR;
            else
                myBuff = myBuff + TERMINATOR;
	    if (startCyt != null)
		myBuff = myBuff + startCyt + TERMINATOR;
  	    else
		myBuff = myBuff + TERMINATOR;
	if (endCyt != null)
		myBuff = myBuff + endCyt + TERMINATOR;
	else
		myBuff = myBuff + TERMINATOR;

            out.write(myBuff + "\n");
            addGeneDatabaseLinks(geneToSave, false, myBuff.toString(), tax);
            addMarkerDatabaseLinks(geneToSave, false, myBuff.toString(), tax);
            addGeneSequences(geneToSave, false, taxonName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

