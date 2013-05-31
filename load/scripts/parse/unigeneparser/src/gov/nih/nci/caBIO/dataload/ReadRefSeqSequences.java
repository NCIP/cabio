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

/**
 * The ReadFile is responsible for reading some of the unigene datafiles it
 * outputs the items of concern to delimited text files which are then loaded to
 * the database
 * 
 * @author CORE Team
 * @version 1.0
 */
public class ReadRefSeqSequences {

	private static int BUFFER_SIZE = 100000;

	private class HeaderHolder {
		String acc;

		String desc;

		String gi;


	}

	/** Construct the application */
	public ReadRefSeqSequences(String[] arguments) {

		String filePath;
		String fileToProcess;

		try {
			filePath = arguments[0];
			fileToProcess = arguments[1];

		} catch (Exception e) {
			printUsage();
			return;
		}

		String lineItem = null;
		String previousLine = null;
		String logfile = "refseq_parser.log";
		String badfile = "refseq_parser.bad";

		int file1 = 0, badRecords = 0;
		try {
			File tempFile = new File(filePath, fileToProcess);
			FileInputStream fis = new FileInputStream(tempFile);

			BufferedReader seqFile = new BufferedReader(new InputStreamReader(
					fis), BUFFER_SIZE);

			HeaderHolder holder = new HeaderHolder();
			StringBuffer ascii = new StringBuffer();

			lineItem = seqFile.readLine();
			readHeader(lineItem, holder);

			long number = 0;
			System.out.println("Starting parse of " + fileToProcess + " at "
					+ new Date());
			File processFile1 = new File(filePath, "refseq.dat");

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
					tmpBuilder.append(holder.acc);
					tmpBuilder.append("%|");
					tmpBuilder.append(holder.gi);
					tmpBuilder.append("%|");
					tmpBuilder.append(holder.desc);
					tmpBuilder.append("%|");
					tmpBuilder.append("6");
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

	}

	private void readHeader(String lineItem, HeaderHolder holder) {
		try {
			String [] items = lineItem.split("\\|");
			// get definition
			holder.desc = items[4];
            holder.gi=items[1];
    		holder.acc=items[3];

		} catch (Exception e) {
			System.err.println(e.getMessage());
		}
	}

	/** Main method */
	public static void main(String[] args) {

		new ReadRefSeqSequences(args);

		
	}
}
