/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.caBIO.bean.CMAPOntology;
import gov.nih.nci.caBIO.bean.CMAPOntologyRelationship;
import gov.nih.nci.caBIOApp.util.CaBIOUtils;
import gov.nih.nci.caBIOApp.util.MessageLog;
import gov.nih.nci.common.search.Criterion;
import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.ncicb.webtree.WebNode;

import javax.swing.tree.DefaultMutableTreeNode;

public class CMAPOntologyTreeBuilder extends DefaultOntologyTreeBuilder
        implements TreeBuilder {

    public CMAPOntologyTreeBuilder() {
        super();
    }

    public DefaultMutableTreeNode buildTree(String ontName, String rootTerm)
            throws Exception {
        DefaultMutableTreeNode treeRoot = new DefaultMutableTreeNode();
        MessageLog.printInfo("OntologyTree.initTree(): caching tree for "
                + ontName);
        SearchCriteria sc = CaBIOUtils.newSearchCriteria(ontName);
        sc.putCriterion("name", Criterion.EQUAL_TO, rootTerm);
        Object[] results = sc.search().getResultSet();
        if (results.length == 1) {
            CMAPOntology root = (CMAPOntology) results[0];
            CMAPOntologyRelationship[] rels = (CMAPOntologyRelationship[]) root.getChildRelationships();
            CMAPOntology rootObj = rels[0].getChild();
            String id = CaBIOUtils.getProperty(rootObj, "id").toString();
            String name = rootTerm;
            treeRoot.setUserObject(new WebNode(id, name, "javascript:"
                    + _eventHandler + "('" + id + "', '" + name + "')"));
            buildTree(treeRoot, rootObj);
        }
        else if (results.length > 1) {
            throw new Exception("Found more that one root for root term: "
                    + rootTerm);
        }
        else {
            throw new Exception("Found not root for root term: " + rootTerm);
        }
        return treeRoot;
    }
}
