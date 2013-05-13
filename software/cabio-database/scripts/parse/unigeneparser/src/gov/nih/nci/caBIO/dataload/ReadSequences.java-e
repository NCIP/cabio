package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.util.Date;

/**
 * The ReadFile is responsible for reading some of the unigene datafiles it
 * outputs the items of concern to delimited text files which are then loaded to
 * the database
 *
 * @author CORE Team
 * @version 1.0
 */
public class ReadSequences {

	private static int BUFFER_SIZE = 100000;

	private class HeaderHolder {
		StringBuffer gb = new StringBuffer();

		String desc;

		Long len;

		long isMRNA = 1;
	}

	/** Construct the application */
	public ReadSequences(String[] arguments) {

		String filePath;
		String fileToProcess;

		try {
			filePath = arguments[0];
			fileToProcess = arguments[1];

			System.setProperty("gov.nih.nci.caBIO.dataload.connectString",
					arguments[2]);

			System.setProperty("gov.nih.nci.caBIO.dataload.user", arguments[3]);

			System.setProperty("gov.nih.nci.caBIO.dataload.password",
					arguments[4]);

		} catch (Exception e) {
			printUsage();
			return;
		}

		String lineItem = null;
		String previousLine = null;
		String logfile = "UNIGENE_seq_parser.log";
		String badfile = "UNIGENE_seq_parser.bad";

		int file1 = 0, badRecords = 0;
		try {
			File tempFile = new File(filePath, fileToProcess);
			FileInputStream fis = new FileInputStream(tempFile);

			BufferedReader seqFile = new BufferedReader(new InputStreamReader(
					fis), BUFFER_SIZE);

			HeaderHolder holder = new HeaderHolder();
			StringBuffer ascii = new StringBuffer();

			lineItem = seqFile.readLine();
			lineItem = seqFile.readLine();
			lineItem = seqFile.readLine();
			readHeader(lineItem, holder);

			long number = 0;
			System.out.println("Starting parse of " + fileToProcess + " at "
					+ new Date());
			File processFile1 = new File(filePath, "nas.dat");

			BufferedWriter tmpWriter1 = new BufferedWriter(new FileWriter(
					processFile1, true), BUFFER_SIZE);
			BufferedWriter log = new BufferedWriter(new FileWriter(logfile,
					true));
			BufferedWriter bad = new BufferedWriter(new FileWriter(badfile,
					true));
			Runtime rt = Runtime.getRuntime();
			StringBuilder tmpBuilder, nasBuilder;

			while ((lineItem = seqFile.readLine()) != null) {
				tmpBuilder = new StringBuilder();

				char firstChar;
				if (lineItem.length() > 1) {
					firstChar = lineItem.charAt(0);
				} else {
					firstChar = ' ';
				}

				// new sequence header
				if (firstChar == '>') {
					number++;

					if (number % 500000 == 0) {
						tmpWriter1.flush();
						rt.gc();
						System.out.println(number);
					}
					int asciiLen = ascii.length();

					// save off previous sequence
					tmpBuilder.append(holder.gb);
					tmpBuilder.append("%|");
					tmpBuilder.append(holder.isMRNA);
					tmpBuilder.append("%|");
					tmpBuilder.append(holder.desc);
					tmpBuilder.append("%|");
					tmpBuilder.append(holder.len);
					tmpBuilder.append("%|");
					tmpBuilder.append(ascii);
					tmpBuilder.append("\n");
					if (tmpBuilder.toString().length() == 0) {
						badRecords++;
						bad.write(previousLine);
					}

					tmpWriter1.write(tmpBuilder.toString());
					file1++;

					// Clearing the previous sequence
					ascii.delete(0, ascii.length());
					readHeader(lineItem, holder);
				} else if (firstChar == '#') {
					// Comments do nothing
				} else {
					// Not a header line or comment so we assume it's a sequence
					// line
					ascii.append(lineItem.trim());
				}
			}
			seqFile.close();
			tmpWriter1.flush();

			log.write("Number of records in " + fileToProcess + ": " + number);
			log.newLine();
			log.write("Number of records written to " + fileToProcess
					+ "_proc.dat: " + file1);
			log.newLine();
			log.write("Number of records skipped: " + badRecords);
			log.newLine();
			log.newLine();
			log.newLine();
			log.flush();
			bad.flush();

			tmpWriter1.close();
			log.close();
			bad.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("Done parse of " + fileToProcess + " at "
				+ new Date());
	}

	private void printUsage() {
		System.out.println("Usage:");
		System.out.println("arguments[0]=working directory");
		System.out.println("arguments[1]=name of sequence file to process");
		System.out.println("arguments[2]=connect string for database");
		System.out.println("arguments[3]=database user");
		System.out.println("arguments[4]=database password");
	}

	private void readHeader(String lineItem, HeaderHolder holder) {
		try {
			holder.isMRNA = 1;
			holder.gb.delete(0, holder.gb.length());

			// get definition
			int startPos = lineItem.indexOf(" ");
			int endPos = lineItem.indexOf("/", startPos) - 1;
			holder.desc = lineItem.substring(startPos, endPos).trim();

			// get accession number
			startPos = lineItem.indexOf("gb=") + 3;
			endPos = lineItem.indexOf("/", startPos) - 1;
			holder.gb.append(lineItem.substring(startPos, endPos).trim());

			// get length
			startPos = lineItem.indexOf("len=") + 4;
			endPos = lineItem.length();
			holder.len = Long.parseLong(lineItem.substring(startPos, endPos)
					.trim());

			if (lineItem.indexOf("complete cds") > 0)
				holder.isMRNA = 2;

		} catch (Exception e) {
			System.err.println(e.getMessage());
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

		new ReadSequences(args);
	}
}
