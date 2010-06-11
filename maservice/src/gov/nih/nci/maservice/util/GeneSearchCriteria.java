package gov.nih.nci.maservice.util;

import gov.nih.nci.iso21090.St;

/**
 * @author Jim Sun
 * @version 1.0
 * @created 09-Jun-2010 2:21:39 PM
 */
public class GeneSearchCriteria extends SearchCriteria {

	private St symbolOrAlias;
	public OrganismCriteria organismCriteria;

	public GeneSearchCriteria(){

	}

	public St getSymbolOrAlias() {
		return symbolOrAlias;
	}

	public void setSymbolOrAlias(St symbolOrAlias) {
		this.symbolOrAlias = symbolOrAlias;
	}

}