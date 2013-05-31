/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.report.Table;
import gov.nih.nci.caBIOApp.sod.Association;
import gov.nih.nci.caBIOApp.sod.PathItem;
import gov.nih.nci.caBIOApp.sod.SearchableObject;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.swing.tree.DefaultMutableTreeNode;

public class SearchCriteriaNode extends DefaultMutableTreeNode {

    private boolean _isEdited = false;
    private boolean _isMergeCriterionNode = false;
    private Table _table = null;
    private int _sourceColNum = -1;

    public SearchCriteriaNode(CriterionValue val) {
        super(val);
    }

    public void setEdited(boolean b) {
        _isEdited = b;
    }

    public boolean getEdited() {
        return _isEdited;
    }

    public boolean isEdited() {
        return getEdited();
    }

    public List getPropertyNodes() {
        List propNodes = new ArrayList();
        if (children != null) {
            for (Iterator i = children.iterator(); i.hasNext();) {
                SearchCriteriaNode child = (SearchCriteriaNode) i.next();
                if (((CriterionValue) child.getUserObject()).getType() != CriterionValue.OBJECT_TYPE) {
                    propNodes.add(child);
                }
            }
        }
        return propNodes;
    }

    public List getObjectNodes() {
        List objNodes = new ArrayList();
        if (children != null) {
            for (Iterator i = children.iterator(); i.hasNext();) {
                SearchCriteriaNode child = (SearchCriteriaNode) i.next();
                if (((CriterionValue) child.getUserObject()).getType() == CriterionValue.OBJECT_TYPE) {
                    objNodes.add(child);
                }
            }
        }
        return objNodes;
    }

    public boolean isProperty() {
        return ((CriterionValue) userObject).getType() != CriterionValue.OBJECT_TYPE;
    }

    public boolean isObject() {
        return ((CriterionValue) userObject).getType() == CriterionValue.OBJECT_TYPE;
    }

    public void setIsMergeCriterionNode(boolean b) {
        _isMergeCriterionNode = b;
    }

    public boolean getIsMergeCriterionNode() {
        return _isMergeCriterionNode;
    }

    public boolean isMergeCriterionNode() {
        return getIsMergeCriterionNode();
    }

    public String getObjectName() {
        return ((CriterionValue) userObject).getObjectName();
    }

    public String getPropertyName() {
        return ((CriterionValue) userObject).getPropertyName();
    }

    public void setTable(Table t) {
        _table = t;
    }

    public Table getTable() {
        return _table;
    }

    public void setSourceColumnNumber(int n) {
        _sourceColNum = n;
    }

    public int getSourceColumnNumber() {
        return _sourceColNum;
    }

    public String getId() {
        return ((CriterionValue) userObject).getId();
    }

    public String toXML() {
        return null;
    }

    public boolean isEmpty() {
        boolean empty = true;
        CriterionValue val = (CriterionValue) userObject;
        if (val.getType() == CriterionValue.OBJECT_TYPE) {
            // then this is an object node
            if (userObject != null
                    && ((CriterionValue) userObject).isSelectAll()) {
                empty = false;
            }
            else if (children != null) {
                for (Iterator i = children.iterator(); i.hasNext();) {
                    if (!((SearchCriteriaNode) i.next()).isEmpty()) {
                        empty = false;
                    }
                }
            }
        }
        else {
            // then this is a property node
            List vals = val.getValues();
            if (vals != null && vals.size() > 0) {
                empty = false;
            }
        }
        return empty;
    }

    public SearchCriteriaNode findNonEmptyParent() {
        SearchCriteriaNode theParent = null;
        if (parent != null) {
            SearchCriteriaNode aParent = (SearchCriteriaNode) parent;
            if (!aParent.isEmpty()) {
                theParent = aParent.findNonEmptyParent();
            }
        }
        return theParent;
    }

    public void removeEmptyChildren() {
        for (Enumeration nodes = postorderEnumeration(); nodes.hasMoreElements();) {
            SearchCriteriaNode node = (SearchCriteriaNode) nodes.nextElement();
            if (node.isEmpty()) {
                node.removeFromParent();
            }
        }
    }

    public boolean isPathItem() {
        boolean isPI = false;
        if (isObject() && parent != null) {
            CriterionValue cv = (CriterionValue) ((DefaultMutableTreeNode) parent).getUserObject();
            if (cv != null) {
                SearchableObject so = cv.getSearchableObject();
                List assocs = so.getAssociations();
                search: for (Iterator i = assocs.iterator(); i.hasNext();) {
                    Association assoc = (Association) i.next();
                    List pis = assoc.getPathItems();
                    for (Iterator j = pis.iterator(); j.hasNext();) {
                        PathItem pi = (PathItem) j.next();
                        MessageLog.printInfo("pi.getClassname() = "
                                + pi.getClassname()
                                + ", this.getObjectName() = "
                                + this.getObjectName());
                        if (pi.getClassname().equals(this.getObjectName())) {
                            isPI = true;
                            break search;
                        }
                    }
                }
            }
        }
        return isPI;
    }

    public SearchCriteriaNode getPathEndPointNode() {
        SearchCriteriaNode endPointNode = null;
        if (!this.isPathItem()) {
            endPointNode = this;
        }
        else {
            if (children != null) {
                for (Iterator i = children.iterator(); i.hasNext();) {
                    endPointNode = ((SearchCriteriaNode) i.next()).getPathEndPointNode();
                }
            }
        }
        return endPointNode;
    }

    public SearchCriteriaNode getPathBeginPointNode() {
        SearchCriteriaNode beginPointNode = null;
        if (!this.isPathItem()) {
            beginPointNode = this;
        }
        else {
            if (parent != null) {
                beginPointNode = ((SearchCriteriaNode) parent).getPathBeginPointNode();
            }
        }
        return beginPointNode;
    }

    public boolean isOntological() {
        boolean isOnt = false;
        if (userObject != null) {
            if (((CriterionValue) userObject).getType() == CriterionValue.ONTOLOGICAL_TYPE) {
                isOnt = true;
            }
        }
        return isOnt;
    }
}
