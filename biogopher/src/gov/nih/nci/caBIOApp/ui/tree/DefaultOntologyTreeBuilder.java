package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.caBIO.bean.Ontologable;
import gov.nih.nci.caBIO.bean.Relationable;
import gov.nih.nci.caBIOApp.util.CaBIOUtils;
import gov.nih.nci.caBIOApp.util.MessageLog;
import gov.nih.nci.common.domain.Ontology;
import gov.nih.nci.common.domain.Relationship;
import gov.nih.nci.common.search.Criterion;
import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.ncicb.webtree.WebNode;

import java.io.InputStream;
import java.util.Properties;

import javax.swing.tree.DefaultMutableTreeNode;

public class DefaultOntologyTreeBuilder implements TreeBuilder {

    protected String _eventHandler = null;

    public DefaultOntologyTreeBuilder() {
        try {
            InputStream in = Thread.currentThread().getContextClassLoader().getSystemResourceAsStream(
                "otb.properties");
            if (in == null) {
                in = this.getClass().getClassLoader().getResourceAsStream(
                    "otb.properties");
            }
            if (in == null) {
                in = this.getClass().getClassLoader().getSystemResourceAsStream(
                    "otb.properties");
            }
            Properties props = new Properties();
            props.load(in);
            _eventHandler = props.getProperty("DefaultOntologyTreeBuilder.eventHandler");
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error getting properties: "
                    + ex.toString());
        }
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
            Object rootObj = results[0];
            String id = CaBIOUtils.getProperty(rootObj, "id").toString();
            String name = (String) CaBIOUtils.getProperty(rootObj, "name");
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

    protected void buildTree(DefaultMutableTreeNode parentNode, Object parentObj)
            throws Exception {
        if (parentObj instanceof Ontology) {
            Ontology parentOnt = (Ontology) parentObj;
            Relationship[] childRels = parentOnt.getChildRelationships();
            for (int i = 0; i < childRels.length; i++) {
                Relationship childRel = childRels[i];
                Ontology childOnt = childRel.getChild();
                if (childOnt != null) {
                    DefaultMutableTreeNode childNode = buildNode(childRel,
                        childOnt);
                    parentNode.add(childNode);
                    buildTree(childNode, childOnt);
                }
            }
        }
        else {
            Ontologable parentOnt = (Ontologable) parentObj;
            Relationable[] childRels = parentOnt.getChildRelationships();
            for (int i = 0; i < childRels.length; i++) {
                Relationable childRel = childRels[i];
                Ontologable[] childOnts = childRel.getOntologies();
                if (childOnts.length > 0) {
                    Ontologable childOnt = (Ontologable) childOnts[1];
                    if (childOnt != null) {
                        DefaultMutableTreeNode childNode = buildNode(childRel,
                            childOnt);
                        parentNode.add(childNode);
                        buildTree(childNode, childOnt);
                    }
                }
            }
        }
    }

    protected DefaultMutableTreeNode buildNode(Object rel, Object ont)
            throws Exception {
        String id = (String) CaBIOUtils.getProperty(ont, "id").toString();
        String name = (String) CaBIOUtils.getProperty(ont, "name");
        DefaultMutableTreeNode node = new DefaultMutableTreeNode(new WebNode(
                id, name, "javascript:" + _eventHandler + "('" + id + "', '"
                        + name + "')"));
        return node;
    }
}
