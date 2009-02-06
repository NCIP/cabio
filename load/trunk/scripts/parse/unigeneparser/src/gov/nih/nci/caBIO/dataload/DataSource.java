package gov.nih.nci.caBIO.dataload;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class DataSource {
	protected String dataSourceName;

	protected long dataSourceID;

	public DataSource() {
	}

	public void setDataSourceName(String dataSourceNameIn) {
		dataSourceName = dataSourceNameIn.toUpperCase();
	}

	public void setDataSourceID(long dataSourceIDIn) {
		dataSourceID = dataSourceIDIn;
	}

	public String getDataSourceName() {
		return dataSourceName.toUpperCase();
	}

	public long getDataSourceID() {
		return dataSourceID;
	}

	// looks up DataSource id by the current name
	public long getDataSourceIDByName() {
		DataSourcePersistence currentDataSource = DataSourcePersistence
				.instance();
		dataSourceID = currentDataSource.getDataSourceID(dataSourceName
				.toUpperCase());
		return dataSourceID;
	}

	public void addDataSource() {
		DataSourcePersistence saveDataSource = DataSourcePersistence.instance();
		setDataSourceID(saveDataSource.addDataSource(this));
	}
}
