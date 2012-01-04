package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIO.bean.ConceptSearch;
import gov.nih.nci.caBIO.bean.ConceptSearchCriteria;
import gov.nih.nci.caBIO.evs.Concept;
import gov.nih.nci.caBIOApp.ui.tree.TreeBuilder;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;
import gov.nih.nci.caBIOApp.util.OntologyInfo;
import gov.nih.nci.ncicb.webtree.WebTree;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

import javax.swing.tree.DefaultMutableTreeNode;

public class OntologyTree extends WebTree {

    private static boolean _initialized = false;
    private static HashMap _trees = new HashMap();

    public OntologyTree() {
        super();
        if (!_initialized) {
            init();
            _initialized = true;
        }
    }

    private void init() {
        try {
            InputStream in = Thread.currentThread().getContextClassLoader().getSystemResourceAsStream(
                "ApplicationResources.properties");
            if (in == null) {
                in = this.getClass().getClassLoader().getResourceAsStream(
                    "ApplicationResources.properties");
            }
            if (in == null) {
                in = this.getClass().getClassLoader().getSystemResourceAsStream(
                    "ApplicationResources.properties");
            }
            Properties props = new Properties();
            props.load(in);
            AppConfig config = AppConfig.getInstance();
            List ontologies = config.getOntologyInfo();
            for (Iterator i = ontologies.iterator(); i.hasNext();) {
                OntologyInfo ontInfo = (OntologyInfo) i.next();
                String serFilename = props.getProperty("gov.nih.nci.caBIOApp.ui.OntologyTree.cacheDir")
                        + "/" + ontInfo.getSerializationFilename();
                File serFile = new File(serFilename);
                DefaultMutableTreeNode tree = null;
                String ontName = ontInfo.getOntologyName();
                if (serFile.exists()) {
                    tree = deserializeTree(serFile);
                }
                else {
                    TreeBuilder tb = (TreeBuilder) Class.forName(
                        ontInfo.getTreeBuilder()).newInstance();
                    tree = tb.buildTree(ontName, ontInfo.getRootTerm());
                    serializeTree(tree, serFile);
                }
                _trees.put(ontName, tree);
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new RuntimeException("Error initializing OntologyTree: "
                    + ex.getMessage());
        }
    }

    public DefaultMutableTreeNode getTree(Hashtable params) throws Exception {
        String beanName = (String) params.get("beanName");
        MessageLog.printInfo("OntologyTree.getTree(): looking for " + beanName);
        DefaultMutableTreeNode tree = (DefaultMutableTreeNode) _trees.get(beanName);
        MessageLog.printInfo("...tree is " + (tree == null ? "" : "not")
                + " null");
        return tree;
    }

    public Vector getSynonyms(String term) throws Exception {
        Vector results = new Vector();
        try {
            ConceptSearchCriteria csc = new ConceptSearchCriteria();
            csc.setSearchTerm(term);
            Concept[] concepts = (new ConceptSearch()).search(csc);
            if (concepts != null) {
                for (int i = 0; i < concepts.length; i++) {
                    String[] synonyms = concepts[i].getSynonyms();
                    if (synonyms != null) {
                        for (int j = 0; j < synonyms.length; j++) {
                            results.add(synonyms[j]);
                        }
                    }
                }
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
        }
        return results;
    }

    private void serializeTree(DefaultMutableTreeNode tree, File file)
            throws Exception {
        ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(
                file));
        out.writeObject(tree);
        out.flush();
        out.close();
    }

    private DefaultMutableTreeNode deserializeTree(File file) throws Exception {
        ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
        DefaultMutableTreeNode tree = (DefaultMutableTreeNode) in.readObject();
        if (tree == null) {
            throw new Exception("Couldn't deserialize " + file.getName());
        }
        in.close();
        return tree;
    }

    public static void main(String[] args) {
        try {
            if (args.length > 0 && "-r".equals(args[0])) {
                ObjectInputStream ois = new ObjectInputStream(
                        new FileInputStream(args[1]));
                DefaultMutableTreeNode node = (DefaultMutableTreeNode) ois.readObject();
                Enumeration e = node.preorderEnumeration();
                while (e.hasMoreElements()) {
                    System.out.println(((DefaultMutableTreeNode) e.nextElement()).getUserObject());
                }
            }
            else {
                OntologyTree ot = new OntologyTree();
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            System.exit(1);
        }
        System.exit(0);
    }
}
