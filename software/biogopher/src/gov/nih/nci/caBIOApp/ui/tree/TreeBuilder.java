/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.tree;

import javax.swing.tree.DefaultMutableTreeNode;

public interface TreeBuilder {

    public DefaultMutableTreeNode buildTree(String ontName, String rootTerm)
            throws Exception;
}
