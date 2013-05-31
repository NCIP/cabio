/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import net.handle.server.*;
import java.net.*;

/**
 * @author caBIO Team
 * @version 1.0
 */

public class TestGridId {

	public static void main(String[] args) throws Exception {
		System.out.println("GridId Framework Test...");
		String configFileLocation = "conf";
		URI bigid = null;

		// Create and store a grid identifier in the handler system
		try {
			IDSvcInterface idInterface = IDSvcInterfaceFactory
					.getInterface(configFileLocation);
			String className = "GridIdClassName";
			String uniqueValue = "uniqueValue";
			System.out.println("\nGenerating grid identifier for class "
					+ className + "\tValue: " + uniqueValue);
			ResourceIdInfo rid = new ResourceIdInfo(new URI("urn://ncicb"),
					className + "|" + uniqueValue);
			bigid = idInterface.createOrGetGlobalID(rid);
			System.out.println("Grid id " + bigid
					+ " has been added to the handler system");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception("Unable to connect to the handler system");
		}

		// Retrieve a grid identifier from the handler system
		try {
			System.out
					.println("\nRetrieving grid id information from the handler system");
			IDSvcInterface idInterface = IDSvcInterfaceFactory
					.getInterface(configFileLocation);
			ResourceIdInfo info = idInterface.getBigIDInfo(bigid);
			System.out.println("Metadata for GridId " + bigid + "\t"
					+ info.resourceIdentification);

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception("Unable to connect to the handler system");
		}
	}
}