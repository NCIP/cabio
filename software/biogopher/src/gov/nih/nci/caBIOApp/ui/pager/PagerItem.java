/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.pager;public interface PagerItem {    public String getId();    public String[] getValues();    public void setSelected(boolean b);    public boolean isSelected();}