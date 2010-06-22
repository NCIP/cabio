package gov.nih.nci.maservice.util;

import gov.nih.nci.maservice.domain.Microarray;
import gov.nih.nci.iso21090.St;

/**
 * @author Jim Sun
 * @version 1.0
 * @created 09-Jun-2010 2:21:47 PM
 */
public class ReporterSearchCriteria extends SearchCriteria {

	private St reporterName;
	private Microarray microarray;

	public ReporterSearchCriteria(){

	}

	public St getReporterName() {
		return reporterName;
	}

	public void setReporterName(St reporterName) {
		this.reporterName = reporterName;
	}

	public Microarray getMicroarray() {
		return microarray;
	}

	public void setMicroarray(Microarray microarray) {
		this.microarray = microarray;
	}
}