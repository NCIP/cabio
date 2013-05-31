/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIO.bean.Ontologable;
import gov.nih.nci.caBIOApp.report.Table;
import gov.nih.nci.caBIOApp.sod.Attribute;
import gov.nih.nci.caBIOApp.sod.AttributeType;
import gov.nih.nci.caBIOApp.sod.SODUtils;
import gov.nih.nci.caBIOApp.sod.SearchableObject;
import gov.nih.nci.caBIOApp.util.CaBIOUtils;
import gov.nih.nci.caBIOApp.util.MessageLog;
import gov.nih.nci.common.search.OntologicalCriterion;
import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.util.COREUtilities;

import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

public class QueryDesign {

    private String _id = null;
    private String _label = null;
    private SearchCriteriaNode _tree = null;
    private SODUtils _sod = null;
    private SearchableObject _so = null;

    public QueryDesign(String id, String label, String objectName)
            throws InvalidCriterionException {
        _id = id;
        _label = label;
        _sod = SODUtils.getInstance();
        _so = _sod.getSearchableObject(objectName);
        if (_so == null) {
            throw new InvalidCriterionException(
                    "searchable object not found for: " + objectName);
        }
        _tree = initTree(_so);
    }

    private SearchCriteriaNode initTree(SearchableObject so) {
        String shortName = _sod.getBeanName(so.getClassname());
        CriterionValue rootVal = new CriterionValue(so, shortName);
        rootVal.setExpanded(true);
        SearchCriteriaNode root = new SearchCriteriaNode(rootVal);
        return root;
    }

    /**
     * The id passed to this will always point to a property of some caBIO
     * object. The id is in this form:
     * <objectName>.<objectName>... <propertyName>
     * This method checks to see if a node with the given id exists. If not,
     * it creates it (and, if needed, the object node).
     */
    public CriterionValue selectCriterion(String id)
            throws InvalidCriterionException {
        MessageLog.printInfo("entering selectCriterion, id: " + id);
        String errorMsg = validateSelection(id);
        if (errorMsg != null) {
            throw new InvalidCriterionException(errorMsg);
        }
        SearchCriteriaNode node = findNode(id);
        if (node == null) {
            String lastPart = id.substring(id.lastIndexOf(".") + 1);
            if (isObjectName(lastPart)) {
                node = createObjectNode(id);
            }
            else {
                String objectPart = id.substring(0, id.lastIndexOf("."));
                //see if object node exists
                SearchCriteriaNode objNode = findNode(objectPart);
                if (objNode == null) {
                    //have to create a new one
                    objNode = createObjectNode(objectPart);
                }
                //now create the property node
                node = createPropertyNode(objNode, lastPart);
            }
        }
        //return a copy, not the real thing
        CriterionValue val = (CriterionValue) ((CriterionValue) node.getUserObject()).clone();
        MessageLog.printInfo("selectCriterion, returning val.getId() = "
                + val.getId() + ", node.getId() = " + node.getId());
        return val;
    }

    public void updateCriterion(CriterionValue newVal)
            throws InvalidCriterionException {
        updateCriterion(newVal, null, -1);
    }

    public void updateCriterion(CriterionValue newVal, Table datasource,
            int sourceColNum) throws InvalidCriterionException {
        SearchCriteriaNode node = findNode(newVal.getId());
        if (node == null) {
            throw new InvalidCriterionException(
                    "Couldn't find criterion with id: " + newVal.getId());
        }
        StringBuffer sb = new StringBuffer();
        sb.append("vals in newVal are: ");
        List vals = newVal.getValues();
        if (vals != null) {
            for (Iterator i = vals.iterator(); i.hasNext();) {
                sb.append(((ValueLabelPair) i.next()).getValue());
                if (i.hasNext()) {
                    sb.append(", ");
                }
            }
        }
        MessageLog.printInfo("QueryDesign.updateCriterion(newVal,datasource,sourceColNum): "
                + sb.toString());
        node.setUserObject(newVal);
        if (datasource != null) {
            node.setTable(datasource);
            node.setSourceColumnNumber(sourceColNum);
            //fill with vals
            Set valSet = new HashSet(newVal.getValues());
            for (int i = 0; i < datasource.getRowCount(); i++) {
                String val = datasource.getStringValueAt(i, sourceColNum);
                valSet.add(new ValueLabelPair(val, val));
            }
            newVal.setValues(new ArrayList(valSet));
        }
        if (node.isEmpty()) {
            MessageLog.printInfo("NODE IS EMPTY");
            SearchCriteriaNode parent = (SearchCriteriaNode) node.findNonEmptyParent();
            if (parent == null) {
                parent = _tree;
            }
            parent.removeEmptyChildren();
        }
    }

    public void removeCriterion(CriterionValue valToRemove)
            throws InvalidCriterionException {
        SearchCriteriaNode node = findNode(valToRemove.getId());
        if (node == null) {
            throw new InvalidCriterionException(
                    "Couldn't find criterion with id: " + valToRemove.getId());
        }
        SearchCriteriaNode theParent = (SearchCriteriaNode) node.getParent();
        if (theParent == null) {
            throw new InvalidCriterionException("Cannot remove root criterion.");
        }
        else {
            node.removeFromParent();
            if (theParent.isEmpty()) {
                SearchCriteriaNode aParent = (SearchCriteriaNode) theParent.findNonEmptyParent();
                if (aParent == null) {
                    aParent = _tree;
                }
                aParent.removeEmptyChildren();
            }
        }
    }

    public void emptyCriterion(CriterionValue valToEmpty)
            throws InvalidCriterionException {
        SearchCriteriaNode node = findNode(valToEmpty.getId());
        if (node == null) {
            throw new InvalidCriterionException(
                    "Couldn't find criterion with id: " + valToEmpty.getId());
        }
        node.removeAllChildren();
    }

    public void setMergeCriterion(String id) throws InvalidCriterionException {
        SearchCriteriaNode node = findNode(id);
        if (node == null) {
            throw new InvalidCriterionException(
                    "Couldn't find criterion with id: " + id);
        }
        //unset the current merge criterion
        SearchCriteriaNode mergeNode = getMergeCriterionNode();
        if (mergeNode != null) {
            mergeNode.setIsMergeCriterionNode(false);
        }
        node.setIsMergeCriterionNode(true);
    }

    public SearchCriteriaNode getMergeCriterionNode() {
        SearchCriteriaNode theNode = null;
        Enumeration nodes = _tree.preorderEnumeration();
        while (nodes.hasMoreElements()) {
            SearchCriteriaNode aNode = (SearchCriteriaNode) nodes.nextElement();
            if (aNode.isMergeCriterionNode()) {
                theNode = aNode;
                break;
            }
        }
        return theNode;
    }

    /**
     * Uses SODUtils to determine if the object and attribute
     * are valid given the main object of this design.
     */
    private String validateSelection(String id) {
        return null;
    }

    public SearchCriteriaNode findNode(String id) {
        SearchCriteriaNode theNode = null;
        Enumeration nodes = _tree.preorderEnumeration();
        while (nodes.hasMoreElements()) {
            SearchCriteriaNode aNode = (SearchCriteriaNode) nodes.nextElement();
            if (aNode.getId().equals(id)) {
                theNode = aNode;
                break;
            }
        }
        return theNode;
    }

    public SearchCriteriaNode createObjectNode(String id)
            throws InvalidCriterionException {
        SearchCriteriaNode theParent = _tree;
        SearchCriteriaNode theChild = null;
        //We know we're starting with the root. So trim root obj name.
        StringTokenizer st = new StringTokenizer(
                id.substring(id.indexOf(".") + 1), ".");
        String shortName = null;
        String currId = theParent.getId(); //to keep track of the id string
        //Traverse till child not found.
        while (st.hasMoreTokens()) {
            shortName = st.nextToken();
            currId += ("." + shortName);
            theChild = getChildWithId(theParent, currId);
            if (theChild == null) {
                break;
            }
            else {
                theParent = theChild;
            }
        }
        //Start inserting children till tokens exhausted.
        boolean exhausted = false;
        do {
            MessageLog.printInfo("QueryDesign.createObjectNode(), trying to insert: "
                    + currId);
            String beanName = _sod.getBeanNameFromPath(currId);
            SearchableObject so = _sod.getSearchableObject(beanName);
            if (so == null) {
                throw new InvalidCriterionException(
                        "QueryDesign.createObjectNode(): couldn't "
                                + "find searchable object for: " + beanName);
            }
            CriterionValue val = new CriterionValue(so, currId);
            val.setExpanded(true);
            theChild = new SearchCriteriaNode(val);
            theParent.add(theChild);
            theParent = theChild;
            if (st.hasMoreTokens()) {
                shortName = st.nextToken();
                currId += ("." + shortName);
            }
            else {
                exhausted = true;
            }
        } while (!exhausted);
        return theChild;
    }

    public SearchCriteriaNode createPropertyNode(SearchCriteriaNode theParent,
            String propName) {
        /*
        MessageLog.printInfo( "in createPropertyNode" );
        MessageLog.printInfo( "theParent " + (theParent==null?"is":"is not") + " null"  );
        MessageLog.printInfo( "theParent.getObjectName(): " + theParent.getObjectName() +
        		  " propName: " + propName );
        */
        SearchableObject so = _sod.getSearchableObject(theParent.getObjectName());
        Attribute att = _sod.getAttribute(so, propName);
        CriterionValue val = new CriterionValue(so, att, theParent.getId()
                + "." + propName);
        SearchCriteriaNode propNode = new SearchCriteriaNode(val);
        theParent.add(propNode);
        return propNode;
    }

    public SearchCriteriaNode getChildWithId(SearchCriteriaNode theParent,
            String id) {
        SearchCriteriaNode theChild = null;
        Enumeration children = theParent.children();
        while (children.hasMoreElements()) {
            SearchCriteriaNode n = (SearchCriteriaNode) children.nextElement();
            if (n.getId().equals(id)) {
                theChild = n;
                break;
            }
        }
        return theChild;
    }

    private String stripPackageName(String classname) {
        return classname.substring(classname.lastIndexOf(".") + 1);
    }

    public SearchCriteria toSearchCriteria() throws InvalidCriterionException {
        return toSearchCriteria(_tree, null);
    }

    public SearchCriteria toSearchCriteria(String mergeValue)
            throws InvalidCriterionException {
        return toSearchCriteria(_tree, mergeValue);
    }

    public SearchCriteria toSearchCriteria(SearchCriteriaNode node,
            String mergeValue) throws InvalidCriterionException {
        //Create a new SearchCriteria
        SearchCriteria criteria = null;
        try {
            String objName = node.getObjectName();
            MessageLog.printInfo("QueryDesign.toSearchCriteria(node,mergeValue): "
                    + "objName = " + objName + ", mergeValue = " + mergeValue);
            //criteria = (SearchCriteria)Class.forName( objName + "SearchCriteria" ).newInstance();
            String beanName = null;
            if (objName.indexOf(".") != -1) {
                beanName = objName.substring(objName.lastIndexOf(".") + 1);
            }
            else {
                beanName = objName;
            }
            String scClassName = COREUtilities.getSCPackageName(objName) + "."
                    + beanName + "SearchCriteria";
            //MessageLog.printInfo( "######### Instantiating: " + scClassName );
            criteria = (SearchCriteria) Class.forName(scClassName).newInstance();
            //To fix WebCriteriaInterpreter bug:
            //criteria.setClassName( objName.substring( objName.lastIndexOf( "." ) + 1 ) );
            //Cycle through properties, adding as appropriate
            List propNodes = node.getPropertyNodes();
            for (Iterator i = propNodes.iterator(); i.hasNext();) {
                SearchCriteriaNode propNode = (SearchCriteriaNode) i.next();
                //add criterion based on type
                CriterionValue cv = (CriterionValue) propNode.getUserObject();
                //if( cv.getType() == CriterionValue.ONTOLOGICAL_TYPE ){
                if ("id".equals(cv.getPropertyName())
                        && _sod.isOntological(((SearchCriteriaNode) propNode.getParent()).getObjectName())
                        || "ontological".equals(cv.getPropertyName())) {
                    addOntologicalCriterion(criteria, cv);
                }
                else {
                    addAttributeCriterion(criteria, cv, mergeValue,
                        propNode.isMergeCriterionNode());
                }
            }
            //Recurse on objects, adding to this SearchCriteria
            List objNodes = node.getObjectNodes();
            for (Iterator i = objNodes.iterator(); i.hasNext();) {
                SearchCriteriaNode objNode = (SearchCriteriaNode) i.next();
                SearchCriteria subCriteria = toSearchCriteria(objNode,
                    mergeValue);
                /*
                MessageLog.printInfo( "putting " + subCriteria.getClass().getName() +
                		      " into " + criteria.getClass().getName() );
                */
                //criteria.putSearchCriteria( subCriteria, CriteriaElement.AND );
                String assocName = getAssocNameFromPath(objNode.getId());
                MessageLog.printInfo("Adding association " + assocName);
                criteria.putCriterion(assocName, subCriteria);
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new InvalidCriterionException(
                    "error creating SearchCriteria: " + ex.getMessage());
        }
        //Return this SearchCriteria
        return criteria;
    }

    private void addOntologicalCriterion(SearchCriteria criteria,
            CriterionValue cv) throws Exception {
        //convert to simple Strings
        List vals = new ArrayList();
        List vlps = cv.getValues();
        for (Iterator i = vlps.iterator(); i.hasNext();) {
            vals.add(((ValueLabelPair) i.next()).getValue());
        }
        /*
        OntologySearchCriteria ontCrit = (OntologySearchCriteria)criteria;
        ontCrit.setIncludeChildren( new Boolean( true ) );
        ontCrit.putCriteria( "id", vals );
        */
        criteria.putCriterion(new OntologicalCriterion("includeChildren", vals));
    }

    private void addAttributeCriterion(SearchCriteria criteria,
            CriterionValue cv, String mergeValue, boolean isMergeCriterion)
            throws InvalidCriterionException {
        SearchableObject so = cv.getSearchableObject();
        SODUtils sod = SODUtils.getInstance();
        Attribute att = sod.getAttribute(so, cv.getPropertyName());
        if (att == null) {
            throw new InvalidCriterionException("Couldn't find Attribute for "
                    + cv.getPropertyName());
        }
        List vals = new ArrayList();
        //check if we are merging
        if (isMergeCriterion && mergeValue != null) {
            MessageLog.printInfo("QueryDesign.addAttributeCriterion(): mergeValue = "
                    + mergeValue);
            vals.add(mergeValue);
        }
        else {
            //convert to simple Strings
            List vlps = cv.getValues();
            for (Iterator i = vlps.iterator(); i.hasNext();) {
                vals.add(((ValueLabelPair) i.next()).getValue());
            }
        }
        List convertedVals = convertVals(att, vals);
        StringBuffer sb = new StringBuffer();
        sb.append("QueryDesign.addAttributeCriterion(): values being put into "
                + criteria.getClass().getName() + " for property "
                + att.getCriterionName() + " are: ");
        if (convertedVals != null) {
            for (Iterator i = convertedVals.iterator(); i.hasNext();) {
                sb.append(i.next().toString());
                if (i.hasNext()) {
                    sb.append(", ");
                }
            }
        }
        MessageLog.printInfo(sb.toString());
        //criteria.putCriteria( cv.getPropertyName(), convertedVals );
        criteria.putCriteria(att.getCriterionName(), convertedVals);
    }

    private List convertVals(Attribute att, List origVals)
            throws InvalidCriterionException {
        //MessageLog.printInfo( "QueryDesign.convertVals()" );
        List convertedVals = new ArrayList();
        if (att == null) {
            throw new RuntimeException("att is null");
        }
        if (origVals == null) {
            throw new RuntimeException("origVals is null");
        }
        for (Iterator i = origVals.iterator(); i.hasNext();) {
            String strVal = (String) i.next();
            try {
                if (att.getType().toString().equals(
                    AttributeType.ALPHANUMERIC.toString())) {
                    //MessageLog.printInfo( "...ALPHANUMERIC" );
                    convertedVals.add(strVal);
                }
                else if (att.getType().toString().equals(
                    AttributeType.NUMERIC.toString())) {
                    //MessageLog.printInfo( "...NUMERIC" );
                    convertedVals.add(new Long(strVal));
                }
                else if (att.getType().toString().equals(
                    AttributeType.BOOLEAN.toString())) {
                    //MessageLog.printInfo( "...BOOLEAN" );
                    convertedVals.add(new Boolean(strVal));
                }
                else if (att.getType().toString().equals(
                    AttributeType.DATE.toString())) {
                    //MessageLog.printInfo( "...DATE" );	  
                    convertedVals.add(DateFormat.getInstance().parse(strVal));
                }
                else if (att.getType().toString().equals(
                    AttributeType.FLOAT.toString())) {
                    convertedVals.add(new Float(strVal));
                }
                else {
                    throw new Exception("unknown data type: " + att.getType());
                }
            }
            catch (Exception ex) {
                MessageLog.printStackTrace(ex);
                String msg = null;
                if (ex instanceof NumberFormatException) {
                    msg = strVal + " couldn't be parsed to Long";
                }
                else if (ex instanceof ParseException) {
                    msg = strVal + " couldn't be parsed to Date";
                }
                else {
                    msg = ex.getMessage();
                }
                throw new InvalidCriterionException(msg, ex);
            }
        }
        return convertedVals;
    }

    public SearchCriteriaNode getRootSearchCriteriaNode() {
        return _tree;
    }

    public boolean isCriterionEmpty(CriterionValue val) {
        List vals = val.getValues();
        return (vals == null || vals.size() == 0);
    }

    public CriterionValue findNonEmptyChildCriterion(CriterionValue val)
            throws InvalidCriterionException {
        CriterionValue theVal = null;
        SearchCriteriaNode node = findNode(val.getId());
        if (node == null) {
            throw new InvalidCriterionException(
                    "Couldn't find criterion with id: " + val.getId());
        }
        SearchCriteriaNode foundNode = findNonEmptyChildSearchCriteriaNode(node);
        if (foundNode != null) {
            theVal = (CriterionValue) foundNode.getUserObject();
        }
        return theVal;
    }

    public SearchCriteriaNode findNonEmptyChildSearchCriteriaNode(
            SearchCriteriaNode node) {
        SearchCriteriaNode theNode = null;
        if (node != null) {
            List propNodes = node.getPropertyNodes();
            for (Iterator i = propNodes.iterator(); i.hasNext();) {
                SearchCriteriaNode aNode = (SearchCriteriaNode) i.next();
                CriterionValue val = (CriterionValue) aNode.getUserObject();
                if (!isCriterionEmpty(val)) {
                    theNode = aNode;
                    break;
                }
            }//-- end for
            if (theNode == null) {
                List objNodes = node.getObjectNodes();
                for (Iterator i = objNodes.iterator(); i.hasNext();) {
                    SearchCriteriaNode aNode = findNonEmptyChildSearchCriteriaNode((SearchCriteriaNode) i.next());
                    if (aNode != null) {
                        theNode = aNode;
                        break;
                    }
                }//-- end for
            }
        }//-- end if( node != null )
        return theNode;
    }

    public String getId() {
        return _id;
    }

    public void setLabel(String s) {
        _label = s;
    }

    public void setId(String s) {
        _id = s;
    }

    public String getLabel() {
        return _label;
    }

    public String getObjectName() {
        return _so.getClassname();
    }

    public Ontologable getOntologyRoot(String classname) throws Exception {
        /*
        OntologySearchCriteria sc = 
          (OntologySearchCriteria)Class.forName( classname + "SearchCriteria" ).newInstance();
        sc.setMaxRecordset( new Integer( "1" ) );
        Ontologable ont =
          (Ontologable)Class.forName( classname ).newInstance();
        Ontologable[] results = ont.searchOntologys( sc );
        if( results == null || results.length == 0 ){
          throw new Exception( "No instances of " + classname + " found." );
        }
        return findOntologyRoot( results[0] );
        */
        return CaBIOUtils.getOntologyRoot(classname);
    }

    /*
    public Ontologable findOntologyRoot( Ontologable bean )
      throws Exception
    {
      Ontologable root = null;
      String classname = bean.getClass().getName();
      RelationshipSearchCriteria rsc = 
        (RelationshipSearchCriteria)Class.forName( classname + 
    					 "RelationshipSearchCriteria" ).newInstance();
      rsc.setRelationshipChildId( bean.getId() );
      Relationable rel = 
        (Relationable)Class.forName( classname + 
    			   "Relationship" ).newInstance();
      Relationable[] rels = rel.searchRelationships( rsc );
      if( rels != null && rels.length > 0 ){

        if( rels.length > 1 ){
    throw new Exception( classname + ":" + bean.getId() + " has more than one parent." );
        }

        Ontologable[] onts = rels[0].getOntologies();
        if( onts == null || onts.length == 0 ){
    MessageLog.printInfo( "QueryDesign.findOntologyRoot(): " + classname + 
    		      ":" + bean.getId() + " has no parent." );
    root = bean;
    //throw new Exception( "No ontologies found for " + classname + ":" + bean.getId() );
        }else if( onts.length > 1 ){
    throw new Exception( "More than on Ontologable found for " + classname + ":" + bean.getId() );
        }else{
    if( bean.getId().equals( onts[0].getId() ) ){
      root = bean;
    }else{
      root = findOntologyRoot( onts[0] );
    }
        }
      }else{
        throw new Exception( "No relationships found for " + classname + ":" + bean.getId() );
      }

      return root;
    }
    */
    private boolean isObjectName(String name) {
        return (_sod.getSearchableObject(name) != null);
    }

    private String getAssocNameFromPath(String path) {
        String name = null;
        if (path != null) {
            if (path.indexOf(".") != -1) {
                name = path.substring(path.lastIndexOf(".") + 1);
            }
            else {
                name = path;
            }
        }
        return name;
    }
}
