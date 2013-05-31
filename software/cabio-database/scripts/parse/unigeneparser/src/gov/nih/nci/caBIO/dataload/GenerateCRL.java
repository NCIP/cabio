/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

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
public class GenerateCRL {

	private static int BUFFER_SIZE = 100000;

	private Map<String, String> cloneMap = new HashMap<String, String>();

	/** Construct the application */
	public GenerateCRL(String[] arguments) {

		String filePath;
		String fileToProcess;
		String HsmmDataFile;
	        String CloneDataFile;
		String nasRef = "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=nucleotide&cmd=search&term=";
		try {
			filePath = arguments[0];
			fileToProcess = arguments[1];
			CloneDataFile = arguments[2];

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
		String logfile = "Clone_Generator.log";
		String badfile = "Clone_Generator.bad";
		System.out.println("File Path is " + filePath + " Data File is " + CloneDataFile);

		readCloneFile(filePath, CloneDataFile);
		int file1 = 0, hsmmnasrecords = 0, clonenasrecords = 0, badRecords = 0;
		try {
			File tempFile = new File(filePath, fileToProcess);
			FileInputStream fis = new FileInputStream(tempFile);

			BufferedReader seqFile = new BufferedReader(new InputStreamReader(
					fis), BUFFER_SIZE);

			long number = 0;

			File clone_nas = new File(filePath, fileToProcess
					+ "_clone_nas_revised.dat");

			BufferedWriter clonenasfile = new BufferedWriter(new FileWriter(
					clone_nas), BUFFER_SIZE);
			BufferedWriter log = new BufferedWriter(new FileWriter(logfile,
					true));
			BufferedWriter bad = new BufferedWriter(new FileWriter(badfile,
					true));
			Runtime rt = Runtime.getRuntime();
			StringBuilder tmpBuilder = new StringBuilder();
			String tmpKey = "";
			String[] st;
			System.out.println("Starting parse of " + filePath+"/"+fileToProcess + " at "
					+ new Date());
			while ((lineItem = seqFile.readLine()) != null) {
			        //System.out.println("Line is " + lineItem);
				tmpBuilder.delete(0, tmpBuilder.length());
				lineItem.trim();
				st = lineItem.split("\\%\\|");
				number++;

				if (number % 500000 == 0) {
					clonenasfile.flush();
					rt.gc();
					System.out.println(number);
				}
					//System.out.println("***** " + st.length);
				        if(st[10] !=null) {
					//System.out.println("**st[10]***" + st[10]);
	                                st[10] = st[10].trim();
                                // check if the clone Id is there in cloneMap
                                // if so, put it in nucleicacidsequence.dat
                                if (cloneMap.containsKey(st[10])) {
                                        clonenasfile.write(lineItem);
                                        tmpBuilder.append(cloneMap.get(st[10]).toString()
                                                        + "%|");
                                        tmpBuilder.append("\n");
                                        clonenasfile.write(tmpBuilder.toString());
                                         cloneMap.remove(st[10]);
					 clonenasrecords++;

				} else {
					badRecords++;
					bad.write(lineItem);
				}

			     }
			}

			seqFile.close();
			log.write("Number of records in HashMap " + cloneMap.size());
			log.newLine();

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
			log.flush();
			bad.flush();

			log.close();
			bad.close();
			clonenasfile.close();

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


	private void readCloneFile(String filePath, String CloneDataFile) {
		try {
			 CloneDataFile = CloneDataFile.trim();
			File cloneFile = new File(filePath, CloneDataFile);
			FileInputStream cloneclone = new FileInputStream(cloneFile);
			BufferedReader clonenasfilereader = new BufferedReader(
					new InputStreamReader(cloneclone), BUFFER_SIZE);

			String lineItem;
			int counter = 0;
			Runtime rt = Runtime.getRuntime();
			while ((lineItem = clonenasfilereader.readLine()) != null) {
			String[] st;
				lineItem.trim();
				st = lineItem.split("\\%\\|");
		//		System.out.println(" line is " + lineItem + " ST[0] " + st[0]);
				if ((st.length > 4) && (st[4].length() > 0)) {
				if (st[1] == "24") {
			        	System.out.println(" Mistake happening here ");
				}
				cloneMap.put(st[1], lineItem);
				counter++;
				if (counter % 500000 == 0) {
					rt.gc();
					System.out.println("Finished reading " + counter
							+ " records");
				}
			    }

			}
			System.out.println("Number of lines read in clone file " + counter);
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

		new GenerateCRL(args);
	}
}
