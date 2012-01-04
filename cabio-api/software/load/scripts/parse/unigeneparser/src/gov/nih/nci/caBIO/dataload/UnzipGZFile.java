package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPInputStream;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class UnzipGZFile {

	/**
	 * 
	 * @param args
	 */
	public static void main(String[] args) {

		if (args.length != 1) {
			System.err.println("Usage: java UnzipGZFile gzipfile");
		} else {
			ungzFile(args[0]);

		}

	}

	/**
	 * Takes the .gz file and uncompresses it
	 * 
	 * @param inputFileName
	 */
	private static void ungzFile(String inputFileName) {

		try {

			if (!getFileType(inputFileName).equalsIgnoreCase("gz")) {
				System.err.println("File must have extension of \".gz\"");
				System.exit(1);
			}

			System.out.println("Opening the gz file." + inputFileName);
			GZIPInputStream in = null;
			try {
				in = new GZIPInputStream(new FileInputStream(inputFileName));

			} catch (FileNotFoundException e) {
				System.err.println("File not found. " + inputFileName);
				System.exit(1);
			}

			System.out.println("Open the output file.");
			String outFileName = getFileName(inputFileName);
			FileOutputStream out = null;

			try {
				out = new FileOutputStream(outFileName);
			} catch (FileNotFoundException e) {
				System.err.println("Could not write to file " + outFileName);
				System.exit(1);
			}

			System.out
					.println("Transfering bytes from compressed file to the output file."
							+ outFileName);
			BufferedReader buffRead = new BufferedReader(new InputStreamReader(
					in));

			BufferedWriter bufWrite = new BufferedWriter(
					new OutputStreamWriter(out));

			try {
				while (true) {

					String line = buffRead.readLine();
					// System.out.println(" the line is " + line);

					if (line == null) {
						System.out.println("Reached the end of file "
								+ inputFileName);
						in.close();
						out.close();
						System.exit(1);

					} else {
						bufWrite.write(line);
						bufWrite.newLine();
						bufWrite.flush();
					}

				}
			} catch (IOException e) {

				System.out.println("End of file ");
				e.printStackTrace();
			}

			System.out.println("Closing the file and stream");
			buffRead.close();
			in.close();
			out.close();

		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);
		}

	}

	/**
	 * Takes the input filename and returns its extension
	 * 
	 * @param f
	 * @return
	 */

	public static String getFileType(String fileName) {
		String ext = "";
		int i = fileName.lastIndexOf('.');

		if (i > 0 && i < fileName.length() - 1) {
			ext = fileName.substring(i + 1);
		}
		return ext;
	}

	/**
	 * Takes the file name and returns the file name without extension
	 * 
	 * @param fileName
	 * @return
	 */

	public static String getFileName(String fileName) {
		String fname = "";
		int i = fileName.lastIndexOf('.');

		if (i > 0 && i < fileName.length() - 1) {
			fname = fileName.substring(0, i);
		}
		return fname;
	}

}
