/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class Map {

	protected String mapType;

	protected String mapLocation;

	protected long mapID;

	public Map() {
		mapID = -1;
	}

	public void setMapType(String mapTypeIn) {
		mapType = mapTypeIn;
	}

	public void setMapLocation(String mapLocationIn) {
		mapLocation = mapLocationIn;
	}

	public void setMapID(long mapIDIn) {
		mapID = mapIDIn;
	}

	public String getMapType() {
		return mapType;
	}

	public String getMapLocation() {
		return mapLocation;
	}

	public long getMapID() {
		return mapID;
	}

	public long addMap() {
		MapPersistence saveMap = MapPersistence.instance();
		long returnVal = saveMap.addMap(this);
		return returnVal;
	}
}