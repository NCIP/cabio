/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.SocketException;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class GetFTPFile {

	static FTPClient ftpClient;

	static String serverName;

	static String userID;

	static String password;

	static String serverWorkingDirectory;

	static String localWorkingDirectory;

	static String dataFile;

	static String mylogFile;

	static Date date;

	static Calendar calender;

	static long setTime;

	static long timeStamp;

	static File logFile;

	static File log;

	// java -classpath
	// ".;..\src;..\lib\commons-httpclient-3.0-rc2.jar;;..\lib\NetComponents.jar"
	// src.GetFTPFile hgdownload.cse.ucsc.edu anonymous tibriwaa@mail.nih.gov
	// goldenPath/hg17/database/ chrM_gap.txt.gz C:/dataupload3.1/data
	// chrM_gap.log

	public static void main(String[] args) {

		if (args.length != 7) {
			System.out.println(" the args are " + args[0] + "  " + args[1]);
			System.err
					.println("Usage: java GetFTPFile serverName userID  password ServerWorkingDirectory dataFile localWorkingDirectory mylogFile");
		} else {
			setValues(args);
		}
	}

	public static void setValues(String[] fileValues) {

		ftpClient = new FTPClient();

		serverName = fileValues[0];
		userID = fileValues[1];
		password = fileValues[2];
		serverWorkingDirectory = fileValues[3];
		dataFile = fileValues[4];
		localWorkingDirectory = fileValues[5];
		mylogFile = fileValues[6];
		connectFTPServer();

	}

	public static void connectFTPServer() {
		try {

			// System.out.println("the server is " + serverName);
			ftpClient.connect(serverName, 21);
			ftpClient.login(userID, password);

			System.out.println("Connected to " + serverName + "."
					+ ftpClient.getReplyString());

			ftpClient.changeWorkingDirectory(serverWorkingDirectory);
			// System.out.println(ftpClient.printWorkingDirectory());
			ftpClient.enterLocalPassiveMode();

			checkTimeStamp();

		} catch (SocketException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * 
	 */
	public static void checkTimeStamp() {

		FileInputStream localLogFile = null;
		DataInputStream longData = null;

		try {
			log = new File(localWorkingDirectory + "/" + mylogFile);
			if (!log.exists()) {
				System.out.println("Log file does not exist");
				createLogFile(mylogFile);
				localLogFile = new FileInputStream(logFile);
			}

			else {
				localLogFile = new FileInputStream(log);
				longData = new DataInputStream(localLogFile);

				try {
					while (true) {
						timeStamp = longData.readLong();
						System.out
								.println("The time stamp on local log file is "
										+ timeStamp);
					}
				} catch (EOFException e) {
					System.out.println("End of file");
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Could not find the log file" + e);
		}

		try {

			System.out.println("before calling listFiles");

			FTPFile fileList[] = ftpClient.listFiles();

			int m = fileList.length;
			System.out.println(" the number of files in the directory are  "
					+ m);

			for (FTPFile element : fileList) {

				if (element.getName().equals(dataFile)) {

					calender = (element.getTimestamp());

					Date date = calender.getTime();
					System.out.println("the server file calender.getTime() is "
							+ date.getTime());
					setTime = date.getTime();
					System.out.println("the time for seTime for server file is"
							+ setTime);

					if (timeStamp != setTime) {
						System.out
								.println("The ftp server file has different timestamp");
						getFile();
					} else {
						System.out
								.println("The ftp server file and local files have same timestamp");
					}
				}

			}
		} catch (FileNotFoundException e) {
			System.out.println("Could not find the file" + e.toString() + " "
					+ dataFile + "on the ftp server");
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	/**
	 * Get the data file from the FTP server
	 * 
	 */
	public static void getFile() {

		try {

			File file = new File(localWorkingDirectory, dataFile);
			FileOutputStream out = new FileOutputStream(file);
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
			boolean returnCode = ftpClient.retrieveFile(dataFile, out);
			System.out.println("return code: " + returnCode);
			System.out.println("Data file is downloaded from the ftp server "
					+ dataFile);

			out.close();
			out.flush();

			log.delete();

			File newlogFile = new File(localWorkingDirectory, mylogFile);
			try {
				newlogFile.createNewFile();
				FileOutputStream out1 = new FileOutputStream(newlogFile);
				DataOutputStream dout = new DataOutputStream(out1);
				dout.writeLong(setTime);
				System.out.println("New log file created");
			} catch (IOException e1) {

				System.out.println("Could not create new log file");
				e1.printStackTrace();
			}

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	/**
	 * Creates a log file which stores the timestamp of the data file
	 * 
	 * @param fileName
	 */
	public static void createLogFile(String fileName) {

		try {

			logFile = new File(localWorkingDirectory, mylogFile);
			logFile.createNewFile();
			if (logFile.exists()) {
				System.out.println("New log file is created");
			}

		} catch (Exception e) {
			System.out.println("Could not create log file  "
					+ logFile.toString());
		}

	}

}
