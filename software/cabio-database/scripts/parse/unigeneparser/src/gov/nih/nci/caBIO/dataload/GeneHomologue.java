/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.net.URL;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class GeneHomologue extends Gene {
	protected long alignmentPercent;

	protected URL urlOfSource;

	public GeneHomologue(String filePath) {
		super(filePath);
	}

	public void setAlignmentPercent(long alignmentPercentIn) {
		alignmentPercent = alignmentPercentIn;
	}

	public void setUrlOfSource(URL urlOfSourceIn) {
		urlOfSource = urlOfSourceIn;
	}

	public URL getUrlOfSource() {
		return urlOfSource;
	}

	public long getAlignmentPercent() {
		return alignmentPercent;
	}
}
