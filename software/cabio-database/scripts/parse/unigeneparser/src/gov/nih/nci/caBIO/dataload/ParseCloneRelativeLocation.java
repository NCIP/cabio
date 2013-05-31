/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.StringTokenizer;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ParseCloneRelativeLocation {

	public static void main(String[] args) {

		if (args.length != 2) {
			// System.out.println(" the args are " + args[0] + " " + args[1]);
			System.err
					.println("Usage: java ParseClonerelativeLocation inputFileName outputFileName");
		} else {
			parseData(args[0], args[1]);
		}

	}

	/**
	 * Takes the input data file and parses the file to the outFileName
	 * 
	 * @param inputFileName
	 * @param outputFileName
	 */
	public static void parseData(String inputFileName, String outputFileName) {

		InputStreamReader in = null;
		FileOutputStream out = null;
		String outfile = outputFileName;
		String infile = inputFileName;

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

		BufferedReader buffReader = new BufferedReader(in);
		BufferedWriter bufWrite = new BufferedWriter(
				new OutputStreamWriter(out));
		int i = 0;
		while (true) {

			String line;
			try {

				line = buffReader.readLine();
				if (line == null) {
					System.out.println("Parsed the file " + infile);
					System.out
							.println("The total number of records written to file "
									+ outfile + " = " + i);
					System.exit(1);
				}

				else if (!line.equals("//")) {
					String location = parseLine(line);
					if (location != null) {
						bufWrite.write(location);
						bufWrite.newLine();
						bufWrite.flush();
						i++;
					}
				}

			} catch (IOException e1) {

				System.out.println(" could not read the line");
				e1.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	/**
	 * Parses each line of the data file to get the accesion number,Image clone
	 * id and the end location
	 * 
	 * @param line
	 * @return
	 */
	public static String parseLine(String line) {

		StringTokenizer dataString = new StringTokenizer(line, " ");
		String location = null;
		String acc_num = null;
		String image_name = null;
		String end_loc = null;

		while (dataString.hasMoreTokens()) {

			String element = dataString.nextToken();

			if (element.startsWith("ACC=")) {
				String temp = element.substring(4);

				// System.out.println(" the temp string is " + temp);

				if (temp.indexOf(".") > 0) {
					// System.out.println(" index of ." + temp.indexOf("."));
					acc_num = temp.substring(0, temp.indexOf("."));

				} else {
					acc_num = temp;
				}

			}

			if (element.startsWith("CLONE=IMAGE")) {

				String id = element.substring(6);
				String[] ids = id.split(";");

				if (ids.length > 0) {
					image_name = ids[0];
				}
			}

			if (element.startsWith("END")) {

				String end = element.substring(4);
				String[] ends = end.split(";");
				if (ends.length > 0) {
					end_loc = ends[0];
				}

			}
		}
		if (acc_num != null && image_name != null && end_loc != null) {
			location = acc_num + "," + image_name + "," + end_loc;
		}

		return location;
	}

}
