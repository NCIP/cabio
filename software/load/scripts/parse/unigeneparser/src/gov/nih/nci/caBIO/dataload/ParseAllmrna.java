package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ParseAllmrna {

	private static Map<String, String> chromosomeMap = new HashMap<String, String>();

	private static int taxonId;

	private static Connection conn;

	public static void main(String[] args) {
		if (args.length != 5) {
			System.out.println(" Parsing " + args[0]);
			System.err
					.println("Usage: java ParseAllmrna inputFileName outputFileName connectString Uname Passwd");
		} else {
			System.out.println(" Parsing " + args[0]);
			System.setProperty("gov.nih.nci.caBIO.dataload.connectString",
					args[2]);
			System.setProperty("gov.nih.nci.caBIO.dataload.user", args[3]);
			System.setProperty("gov.nih.nci.caBIO.dataload.password", args[4]);
			readData(args[0], args[1]);
		}
	}

	public static void readData(String inputFileName, String outputFileName) {

		InputStreamReader in = null;
		FileOutputStream out = null;
		FileOutputStream log = null;
		FileOutputStream bad = null;
		String outfile = outputFileName;
		String infile = inputFileName;
		String logfile = "", badfile = "";
		Boolean appendToLog = false;
		Boolean b, c;
		if ((b = infile.matches(".*est.*"))
				&& (c = infile.matches(".*human.*"))) {
			logfile = "HUMAN_EST_parser.log";
			badfile = "HUMAN_EST_parser.bad";
			appendToLog = true;
			taxonId = 5;
		} else if ((b = infile.matches(".*est.*"))
				&& (b = infile.matches(".*mouse.*"))) {
			logfile = "MOUSE_EST_parser.log";
			badfile = "MOUSE_EST_parser.bad";
			appendToLog = true;
			taxonId = 6;
		} else if ((b = infile.matches(".*mrna.*"))
				&& (b = infile.matches(".*mouse.*"))) {
			logfile = "MOUSE_MRNA_parser.log";
			badfile = "MOUSE_MRNA_parser.bad";
			taxonId = 6;
		} else if ((b = infile.matches(".*mrna.*"))
				&& (b = infile.matches(".*human.*"))) {
			logfile = "HUMAN_MRNA_parser.log";
			badfile = "HUMAN_MRNA_parser.bad";
			taxonId = 5;
		}
		System.out.println("Log file is " + logfile + " and bad file is "
				+ badfile);
		try {
			in = new InputStreamReader(new FileInputStream(infile));

		} catch (FileNotFoundException e) {

			System.out.println(" Cannot read file  " + infile);
			e.printStackTrace();
		}

		try {
			out = new FileOutputStream(outfile);
		} catch (FileNotFoundException e) {
			System.err.println("Could not write to file " + outfile);
			System.exit(1);
		}

		try {
			log = new FileOutputStream(logfile, appendToLog);
		} catch (FileNotFoundException e) {
			System.err.println("Could not write to file " + logfile);
			System.exit(1);
		}

		try {
			bad = new FileOutputStream(badfile, appendToLog);
		} catch (FileNotFoundException e) {
			System.err.println("Could not write to file " + badfile);
			System.exit(1);
		}
		BufferedReader buffReader = new BufferedReader(in);
		BufferedWriter bufWrite = new BufferedWriter(
				new OutputStreamWriter(out));
		BufferedWriter logWrite = new BufferedWriter(
				new OutputStreamWriter(log));
		BufferedWriter badWrite = new BufferedWriter(
				new OutputStreamWriter(bad));
		int i = 0, badcount = 0, recordsRead = 0;

		getChromosomeData();
		while (true) {

			String line;
			try {

				line = buffReader.readLine();
				if (line == null) {
					logWrite.write("Number of records read from " + infile
							+ ": " + recordsRead);
					logWrite.newLine();
					logWrite.write("Number of records written to file: " + i);
					logWrite.newLine();
					logWrite.write("Number of bad records: " + badcount);
					logWrite.newLine();
					logWrite.flush();
					System.exit(1);
				} else {
					recordsRead++;
					String location = parseLine(line);
					if (location == null) {
						badWrite.write(line);
						badWrite.newLine();
						badWrite.flush();
						badcount++;
					} else {
						bufWrite.write(location);
						bufWrite.newLine();
						bufWrite.flush();
						i++;
					}
				}

			} catch (IOException e1) {

				System.out.println("Could not read the line in ParseMrna");
				e1.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	/**
	 * @param line
	 */
	private static String parseLine(String line) {

		StringTokenizer dataString = new StringTokenizer(line, "\t");
		int tokenCounter = 0;
		String physicalLocation = null;
		String chrNo = "", chrId = "";
		while (dataString.hasMoreTokens()) {

			String element = dataString.nextToken();
			tokenCounter++;

			if (tokenCounter == 11) {
				physicalLocation = element + "\t";
			} else if (tokenCounter == 15) {
				physicalLocation = physicalLocation + element + "\t";
				chrNo = element.substring(3);
				chrId = chromosomeMap.get(chrNo);
			} else if (tokenCounter == 17) {
				physicalLocation = physicalLocation + element + "\t";
			} else if (tokenCounter == 18) {
				physicalLocation = physicalLocation + element + "\t";
			}

		}
		if (chrId != "") {
			physicalLocation = physicalLocation + chrNo + "\t" + chrId + "\t";
		} else {
			physicalLocation = physicalLocation + chrNo + "\t" + "" + "\t";
		}
		return physicalLocation;
	}

	private static void getChromosomeData() {
		try {
			// conn = CoreConnection.instance();
			String driverName = "oracle.jdbc.driver.OracleDriver";
			Class.forName(driverName);
			conn = DriverManager.getConnection(System
					.getProperty("gov.nih.nci.caBIO.dataload.connectString"),
					System.getProperty("gov.nih.nci.caBIO.dataload.user"),
					System.getProperty("gov.nih.nci.caBIO.dataload.password"));

			String chrId, chrNo;
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt
					.executeQuery("select trim(chromosome_id), trim(chromosome_number) from chromosome where taxon_id = "
							+ taxonId);
			while (rset.next()) {
				chrId = rset.getString(1);
				chrNo = rset.getString(2);
				chromosomeMap.put(chrNo, chrId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
