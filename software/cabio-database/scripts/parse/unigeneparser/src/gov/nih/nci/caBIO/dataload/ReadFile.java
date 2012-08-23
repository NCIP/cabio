package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

/**
 * Parses UniGene datafiles, then outputs data to delimited
 * 
 * text files for database loading. If certain values are missing (Taxons for
 * example) it will populate those directly in the database.
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ReadFile {

	private static Connection conn;
	private Statement stmt;
	private ResultSet rset;
	private HashMap<String, String> hugoAliasMap = new HashMap();

	/** Construct the application */
	public ReadFile(String[] arguments) {
		String logfile = "UNIGENE_parser.log";
		String badfile = "UNIGENE_parser.bad";

		int idCount = 0, geneCount = 0, seqCount = 0, cloneCount = 0;

		String filePath = arguments[0];
		System.setProperty("gov.nih.nci.caBIO.dataload.connectString",
				arguments[1]);
		System.setProperty("gov.nih.nci.caBIO.dataload.user", arguments[2]);
		System.setProperty("gov.nih.nci.caBIO.dataload.password", arguments[3]);
		conn = CoreConnection.instance();
		try {
			String keyId, val, sqlStatement;
			String sqlStmt = "select DISTINCT LOCUSLINKID, SYMBOL from ZSTG_GENEALIAS where TYPE = 'HUGO'";
			stmt = conn.createStatement();
			rset = stmt.executeQuery(sqlStmt);
			int tmpcount = 0;
			while (rset.next()) {
				hugoAliasMap.put(rset.getString(1), rset.getString(2));
			}
			rset.close();
			stmt.close();
		} catch (Exception sqle) {
			System.out.println(" Exception is " + sqle);
		}
		FileOutputStream log = null;
		FileOutputStream bad = null;
		try {
			log = new FileOutputStream(logfile);
		} catch (FileNotFoundException e) {
			System.err.println("Could not write to file " + logfile);
			System.exit(1);
		}

		try {
			bad = new FileOutputStream(badfile);
		} catch (FileNotFoundException e) {
			System.err.println("Could not write to file " + badfile);
			System.exit(1);
		}

		BufferedWriter logwrite = new BufferedWriter(
				new OutputStreamWriter(log));
		BufferedWriter badwrite = new BufferedWriter(
				new OutputStreamWriter(bad));
		try {
			/** connect to machine and get the data */
			File tempFile = new File(filePath, "Hs.data");
			FileInputStream fis = new FileInputStream(tempFile);

			InputStreamReader isr = new InputStreamReader(new FileInputStream(
					tempFile));
			BufferedReader geneFile = new BufferedReader(isr, 1280000);
			currentGene = new Gene(filePath);

			/** step through gene by gene to get data by gene */			
			logwrite.write("Parsing human Unigene data Hs.data");
			logwrite.write("Data Source: Hs.data");

			boolean hasMoreGenes = readGene(geneFile, "Homo sapiens", filePath,
					idCount, geneCount, cloneCount, seqCount);

			int i = 0;
			idCount = 0;
			while (hasMoreGenes) {
				idCount++;
				/** save gene data to delimited file */
				if (idCount % 10000 == 0) {
					logwrite.write("Finished parsing: " + idCount
							+ " records in Hs.data");
					logwrite.newLine();
				}
				currentGene.addGene();
				hasMoreGenes = readGene(geneFile, "Homo sapiens", filePath,
						idCount, geneCount, cloneCount, seqCount);
			}

			geneFile.close();
			geneFile = null;
			logwrite.write("Number of records in Hs.data: " + idCount);
			logwrite.newLine();
			logwrite.write("Number of records written to gene.dat: "
					+ geneCount);
			logwrite.newLine();
			logwrite.write("Number of records written to clone.dat: cloneCount");
			logwrite.newLine();
			logwrite.write("Number of records written to sequence.dat: "
					+ seqCount);
			logwrite.newLine();
			logwrite.newLine();

			// remove human clones from the history because human clones do
			// not (hopefully) overlap with mouse clones and its a memory hog
			ClonePersistence.instance(filePath).clearHistory();

			idCount = 0;
			geneCount = 0;
			seqCount = 0;
			cloneCount = 0;
			/** do the same for mouse */

			File tempFile1 = new File(filePath, "Mm.data");
			fis = new FileInputStream(tempFile1);
			logwrite.write("Parsing mouse Unigene data Mm.data");

			InputStreamReader Misr = new InputStreamReader(new FileInputStream(
					tempFile1));

			BufferedReader MgeneFile = new BufferedReader(Misr, 1280000);
			currentGene = new Gene(filePath);
			logwrite.write("Data Source: Mm.data");
			hasMoreGenes = readGene(MgeneFile, "Mus musculus", filePath,
					idCount, geneCount, cloneCount, seqCount);
			idCount = 0;
			while (hasMoreGenes) {
				idCount++;
				if (idCount % 10000 == 0) {
					logwrite.write("Finished parsing: " + idCount
							+ " records in Mm.data");
					logwrite.newLine();
				}
				currentGene.addGene();
				hasMoreGenes = readGene(MgeneFile, "Mus musculus", filePath,
						idCount, geneCount, cloneCount, seqCount);
			}
			logwrite.write("Number of records in Mm.data: " + idCount);
			logwrite.newLine();
			logwrite.write("Number of records written to gene.dat: "
					+ geneCount);
			logwrite.newLine();
			logwrite.write("Number of records written to clone.dat: "
					+ cloneCount);
			logwrite.newLine();
			logwrite.write("Number of records written to sequence.dat: "
					+ seqCount);
			logwrite.newLine();
			logwrite.flush();
			logwrite.close();
			badwrite.flush();
			badwrite.close();

		} catch (IOException e) {
			e.printStackTrace();
			System.err.println(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			System.err.println(ex.getMessage());
		} finally {
			/** do the clean up */
			GenePersistence saveGene = GenePersistence.instance(filePath);
			saveGene.cleanup();
			SequencePersistence saveSequence = SequencePersistence
					.instance(filePath);
			saveSequence.cleanup();
			ClonePersistence saveClone = ClonePersistence.instance(filePath);
			saveClone.cleanup();
		}
	}

	private boolean readGene(BufferedReader geneFile, String species,
			String filePath, int idCount, int geneCount, int cloneCount,
			int seqCount) {
		boolean returnValue = false;
		boolean moreGeneData = true;
		String lineItem;
		String token;
		String hugoAlias;
		currentGene.setSymbol(null);
		currentGene.setHugoAlias(null);
		currentGene.setTitle(null);
		currentGene.setCytoband(null);
		currentGene.setstartCytoband(null);
		currentGene.setendCytoband(null);
		currentGene.deleteDatabaseLinks();
		currentGene.deleteMarkerDatabaseLinks();
		currentGene.deleteSequences();
		currentGene.setChromosome(new Chromosome());
		currentGene.setProtein(new Protein());
		Taxon geneTaxon = new Taxon();
		geneTaxon.setScientificName(species);
		currentGene.setTaxon(geneTaxon);
		Sequence currentSequence;
		Hashtable databaseLinks = new Hashtable();
		Vector<String> markerdatabaseLinks = new Vector();
		Hashtable sequences = new Hashtable();
		Vector proteins = new Vector();
		String chromosomeNumber;
		String llink;
		proteins.clear();
		try {
			lineItem = geneFile.readLine();
			if (lineItem == null)
				return false;
			while (moreGeneData) {
				String geneLocation;
				String[] startEndCytobands;
				geneLocation = null;
				startEndCytobands = null;
				StringTokenizer st = new StringTokenizer(lineItem, " ");
				token = st.nextToken();
				chromosomeNumber = "";
				llink = "";
				if (token.equals("STS")) {
					String[] stsValues = new String[2];
					token = st.nextToken();
					token = st.nextToken();
					stsValues = token.split(new String("="));
					markerdatabaseLinks.add(stsValues[1]);
				} else if (token.equals("SEQUENCE")) {
					currentSequence = readSequence(st, filePath, cloneCount);
					sequences.put(currentSequence.accessionNumber,
							currentSequence);
					seqCount++;
				} else if (token.equals("ID")) {
					returnValue = true;
					token = st.nextToken();
					databaseLinks.put("UNIGENE", token.substring(3));
					idCount++;
				} else if (token.equals("LOCUSLINK")) {
					llink = st.nextToken();
					databaseLinks.put("LOCUS_LINK", llink);
					hugoAlias = hugoAliasMap.get(llink);
					if (hugoAlias != null) {
						currentGene.setHugoAlias(hugoAlias);
						hugoAlias = null;
					}
					llink = null;
				} else if (token.equals("TITLE")) {
					currentGene.setTitle(lineItem.substring(12));
				} else if (token.equals("GENE")) {
					currentGene.setSymbol(st.nextToken());
					geneCount++;
				} else if (token.equals("CHROMOSOME")) {
					chromosomeNumber = st.nextToken();
					if (chromosomeNumber.indexOf("|") > 0) {
						chromosomeNumber = chromosomeNumber.substring(0,
								chromosomeNumber.indexOf("|"));
					}
					Chromosome currentChromosome = new Chromosome();
					Taxon currentTaxon = new Taxon();
					currentTaxon.setScientificName(species);
					currentChromosome.setTaxon(currentTaxon);
					currentChromosome.setChromosomeNumber(chromosomeNumber
							.trim());
					currentGene.setChromosome(currentChromosome);
				} else if (token.equals("CYTOBAND")) {
					geneLocation = lineItem.substring(12);
					startEndCytobands = new String[2];
					if (geneLocation.indexOf('-') != -1) {
						startEndCytobands = geneLocation.split(new String("-"));
						currentGene.setstartCytoband(startEndCytobands[0]);
						currentGene.setendCytoband(startEndCytobands[0]
								.substring(0, 1) + startEndCytobands[1]);
						currentGene.setCytoband(geneLocation);
					} else {
						currentGene.setCytoband(geneLocation);
						currentGene.setstartCytoband(geneLocation);
						currentGene.setendCytoband(geneLocation);
					}
					geneLocation = null;
					startEndCytobands = null;
				}
				if (token.equals("//")) {
					moreGeneData = false;
				} else {
					lineItem = geneFile.readLine();
				}
			}

			currentGene.setDatabaseLinks(databaseLinks);
			currentGene.setMarkerDatabaseLinks(markerdatabaseLinks);
			currentGene.setSequences(sequences);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnValue;
	}

	private Sequence readSequence(StringTokenizer st, String filePath,
			int cloneCount) {
		Sequence returnSeq = new Sequence(filePath);
		Clone currentClone = new Clone(filePath);
		Hashtable databaseLinks = new Hashtable();
		String currentToken;
		String currentField;
		String currentValue;
		try {
			while (st.hasMoreTokens()) {
				currentToken = st.nextToken();
				currentField = currentToken.substring(0,
						currentToken.indexOf("="));
				if (currentToken.substring(currentToken.length() - 1,
						currentToken.length()).equals(";")) {
					currentValue = currentToken.substring(
							currentToken.indexOf("=") + 1,
							currentToken.length() - 1);
				} else {
					currentValue = currentToken.substring(currentToken
							.indexOf("=") + 1);
				}
				if (currentField.equals("ACC")) {
					returnSeq.setAccessionNumber(currentValue);
				}
				if (currentField.equals("SEQTYPE")) {
					if (currentValue.equals("EST"))
						returnSeq.setSequenceType("EST");
					else
						returnSeq.setSequenceType("MRNA");
				}
				if (currentField.equals("CLONE")) {
					cloneCount++;
					currentClone.setCloneID(currentValue);
					// returnSeq.setSequenceType("EST");
				}
				if (currentField.equals("END")) {
					currentClone.setCloneType(currentValue);
				}
				if (currentField.equals("LID")) {
					currentClone.setLibraryID(Long.parseLong(currentValue));
					// sometimes they give us a library without clone!
					if (currentClone.getCloneID() == null) {
						currentClone.setCloneID("unknown");
						// returnSeq.setSequenceType("EST");
					}
				}
				/***************************************************************
				 * not doing sequence identifiers if
				 * (currentField.equals("NID")) { databaseLinks.put("GENBANK N",
				 * currentValue.substring(1)); } if (currentField.equals("PID"))
				 * { databaseLinks.put("GENBANK P", currentValue.substring(1));
				 * }
				 **************************************************************/

			}
			returnSeq.setClone(currentClone);
			returnSeq.setDatabaseLinks(databaseLinks);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return returnSeq;
	}

	/** Main method */
	public static void main(String[] args) {
		new ReadFile(args);
	}

	private Gene currentGene;
}
