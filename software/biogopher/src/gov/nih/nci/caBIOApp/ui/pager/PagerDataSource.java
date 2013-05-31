/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.pager;public interface PagerDataSource {    public int getItemCount() throws Exception;    public PagerItem[] getItems(int startIdx, int numItems) throws Exception;    public String[] getHeaders();}