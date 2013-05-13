package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * The ReadFile is responsible for reading some of the unigene datafiles it
 * outputs the items of concern to delimited text files which are then loaded to
 * the database
 *
 * @author CORE Team
 * @version 1.0
 */
public class GenerateNas {

	private static int BUFFER_SIZE = 100000;

	private Map<String, String> hsmmMap = new HashMap<String, String>();

	/** Construct the application */
	public GenerateNas(String[] arguments) {

		String filePath;
		String fileToProcess;
		String HsmmDataFile;
		String nasRef = "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=nucleotide&cmd=search&term=";
		try {
			filePath = arguments[0];
			fileToProcess = arguments[1];
			HsmmDataFile = arguments[2];

			System.setProperty("gov.nih.nci.caBIO.dataload.connectString",
					arguments[3]);

			System.setProperty("gov.nih.nci.caBIO.dataload.user", arguments[4]);

			System.setProperty("gov.nih.nci.caBIO.dataload.password",
					arguments[5]);

		} catch (Exception e) {
			printUsage();
			return;
		}

		String lineItem = null;
		String previousLine = null;
		String logfile = "NAS_Generator.log";
		String badfile = "NAS_Generator.bad";

		readHsmmFile(filePath, HsmmDataFile);
		int file1 = 0, hsmmnasrecords = 0, badRecords = 0;
		try {
			File tempFile = new File(filePath, fileToProcess);
			FileInputStream fis = new FileInputStream(tempFile);

			BufferedReader seqFile = new BufferedReader(new InputStreamReader(
					fis), BUFFER_SIZE);

			long number = 0;
			File hsmm_nas = new File(filePath, fileToProcess
					+ "_nas_hsmm_revised.dat");

			BufferedWriter hsmmnasfile = new BufferedWriter(new FileWriter(
					hsmm_nas), BUFFER_SIZE);
			BufferedWriter log = new BufferedWriter(new FileWriter(logfile,
					true));
			BufferedWriter bad = new BufferedWriter(new FileWriter(badfile,
					true));
			Runtime rt = Runtime.getRuntime();
			StringBuilder tmpBuilder = new StringBuilder();
			String tmpKey = "";
			String[] st;
			System.out.println("Starting parse of " + fileToProcess + " at "
					+ new Date());
			log.write("Number of records in HashMap " + hsmmMap.size());
			log.newLine();
			while ((lineItem = seqFile.readLine()) != null) {
				tmpBuilder.delete(0, tmpBuilder.length());
				lineItem.trim();
				st = lineItem.split("\\%\\|");
				number++;

				if (number % 500000 == 0) {
					hsmmnasfile.flush();
					rt.gc();
					System.out.println(number);
				}
				st[0] = st[0].trim();
				// check if the accession is there in hsmmMap
				// if so, put it in nucleicacidsequence.dat
				if (hsmmMap.containsKey(st[0])) {
					hsmmnasfile.write(lineItem);
					tmpBuilder.append("%|" + hsmmMap.get(st[0]).toString()
							+ "%|" + nasRef + st[0] + "%|" + nasRef + st[0]
							+ "%|");
					tmpBuilder.append("\n");
					hsmmnasfile.write(tmpBuilder.toString());
					hsmmnasrecords++;
					hsmmMap.remove(st[0]);
				} else {
					badRecords++;
					bad.write(lineItem);
				}

			}
			seqFile.close();
			hsmmnasfile.flush();

			log.write("Number of records in " + fileToProcess + ": " + number);
			log.newLine();
			log.write("Number of records skipped: " + badRecords);
			log.newLine();
			log.write("Number of records written to nucleicacidsequence.dat: "
					+ hsmmnasrecords);
			log.newLine();
			log.newLine();
			log.newLine();
			log.write("Done parse of " + fileToProcess + " at " + new Date());
			log.newLine();
			log.write("Number of records in hsmm seq stg31 left " + hsmmMap.size());
			log.newLine();
			log.flush();
			bad.flush();

			hsmmnasfile.close();
			log.close();
			bad.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void printUsage() {
		System.out.println("Usage:");
		System.out.println("arguments[0]=working directory");
		System.out.println("arguments[1]=name of sequence file to process");
		System.out.println("arguments[2]=connect string for database");
		System.out.println("arguments[3]=database user");
		System.out.println("arguments[4]=database password");
	}

	private void readHsmmFile(String filePath, String HsmmDataFile) {
		try {
			File hsmmFile = new File(filePath, HsmmDataFile);
			FileInputStream hsmmhsmm = new FileInputStream(hsmmFile);
			BufferedReader hsmmnasfilereader = new BufferedReader(
					new InputStreamReader(hsmmhsmm), BUFFER_SIZE);

			String lineItem;
			String[] st;
			int counter = 0;
			Runtime rt = Runtime.getRuntime();
			while ((lineItem = hsmmnasfilereader.readLine()) != null) {
				lineItem.trim();
				st = lineItem.split("\\%\\|");
				hsmmMap.put(st[1], lineItem);
				counter++;
				if (counter % 500000 == 0) {
					rt.gc();
					System.out.println("Finished reading " + counter
							+ " records");
				}
			}
			System.out.println("Number of lines read in file " + counter);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/** Main method */
	public static void main(String[] args) {

		// args = new String[9];
		// /repository/UniGene/Homo_sapiens
		// ftp.ncbi.nih.gov anonymous gustafss@mail.nih.gov
		// ../data/ncbi_unigene Hs.seq.all.gz
		// jdbc:oracle:thin:@cbiodb2-d.nci.nih.gov:1521:CBDEV cabiodev31

		// /repository/UniGene/Mus_musculus ftp.ncbi.nih.gov anonymous
		// gustafss@mail.nih.gov ../data/ncbi_unigene Mm.seq.all.gz
		// jdbc:oracle:thin:@cbiodb2-d.nci.nih.gov:1521:CBDEV cabiodev31
		/*
		 * args[0] = "/repository/UniGene/Mus_musculus"; args[1] =
		 * "ftp.ncbi.nih.gov"; args[2] = "anonymous"; args[3] =
		 * "gustafss@mail.nih.gov"; args[4] = "C:/cabio21/database/test/";
		 * args[5] = "Mm.seq.all.gz"; args[6] =
		 * "jdbc:oracle:thin:@cbiodb2-d.nci.nih.gov:1521:CBDEV"; args[7] =
		 * "cabiodev31"; args[8] = "";
		 */

		new GenerateNas(args);
	}
}
