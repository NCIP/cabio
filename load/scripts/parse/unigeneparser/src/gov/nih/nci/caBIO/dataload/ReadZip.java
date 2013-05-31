/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.zip.GZIPInputStream;

import oracle.jdbc.driver.OraclePreparedStatement;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

/**
 * The ReadFile is responsible for reading some of the unigene datafiles it
 * outputs the items of concern to delimited text files which are then loaded to
 * the database
 * 
 * @author CORE Team
 * @version 1.0
 */
public class ReadZip {

	private static PreparedStatement ustmt;

	private static Connection conn;

	/** Construct the application */
	public ReadZip(String[] arguments) {
		/** variables that tell us how to connect to ftp server */
		String directoryName;
		String machineName;
		String loginName;
		String pwd;
		/** our ftp client */
		FTPClient ftp;
		directoryName = "/rmi/caBIO";
		machineName = "ncicbdev102.nci.nih.gov";
		loginName = "gustafss";
		pwd = "lpgsco";

		try {
			ftp = new FTPClient();
			ftp.connect(machineName, 21);
			ftp.login(loginName, pwd);
			ftp.changeWorkingDirectory(directoryName);
			System.out.println("the dir-" + ftp.printWorkingDirectory());

			// InputStreamReader Misr = new
			// InputStreamReader(ftp.retrieveFileStream("Mm.data"));

			conn = CoreConnection.instance();
			ustmt = conn
					.prepareStatement("UPDATE SEQUENCE SET LENGTH=?, ASCII_STRING=? WHERE ACCESSION_NUMBER = ?");
			((OraclePreparedStatement) ustmt).setExecuteBatch(100);
			// FileInputStream fis = new FileInputStream ("C:\\Hs.seq.all.gz");
			ftp.setFileTransferMode(FTPClient.COMPRESSED_TRANSFER_MODE);
			InputStream fis = ftp.retrieveFileStream("Hs.seq.all.gz");

			GZIPInputStream gz = new GZIPInputStream(fis);
			BufferedReader br = new BufferedReader(new InputStreamReader(gz));
			for (int i = 0; i < 50; i++) {
				// gz.read(chunk);
				// String theString = new String(chunk);
				System.out.println(br.readLine());
			}
			// InputStreamReader isr = new InputStreamReader(fis);
			// BufferedReader br = new BufferedReader(isr);
			// System.out.println(br.readLine());
			// System.out.println(br.readLine());

		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getMessage());
		}
	}

	/** Main method */
	public static void main(String[] args) {
		new ReadZip(args);
	}
}
