package gov.nih.nci.caBIO.dataload;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class HomologousProtein extends Protein {

	protected long alignmentAmount;

	protected long alignmentPercent;

	public void setAlignmentPercent(long alignmentPercentIn) {
		alignmentPercent = alignmentPercentIn;
	}

	public void setAlignmentAmount(long alignmentAmountIn) {
		alignmentAmount = alignmentAmountIn;
	}

	public long getAlignmentAmount() {
		return alignmentAmount;
	}

	public long getAlignmentPercent() {
		return alignmentPercent;
	}
}