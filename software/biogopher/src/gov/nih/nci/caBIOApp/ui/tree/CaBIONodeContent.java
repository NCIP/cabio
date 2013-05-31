/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.tree;

import gov.nih.nci.caBIOApp.ui.ObjectTree;

public class CaBIONodeContent implements NodeContent {

    private String _id = null;
    private String _content = null;
    private String _description = null;
    private String _target = null;
    private String _link = null;
    private boolean _expanded = false;
    private Object _contentModel = null;
    private boolean _extraContentFirst = false;
    private String _extraContent = null;
    private boolean _active = false;
    private ObjectTree _tree = null;

    public CaBIONodeContent(ObjectTree tree) {
        _tree = tree;
    }

    public CaBIONodeContent(CaBIONodeContent orig) {
        if (orig != null) {
            _id = orig.getId();
            _content = orig.getContent();
            _description = orig.getDescription();
            _target = orig.getTarget();
            _link = orig.getLink();
            _expanded = orig.isExpanded();
            _contentModel = orig.getContentModel();
            _tree = orig.getTree();
        }
    }

    public CaBIONodeContent(String id, String content, String description,
            String target, String link, boolean expanded, Object model) {
        _id = id;
        _content = content;
        _description = description;
        _target = target;
        _link = link;
        _expanded = expanded;
        _contentModel = model;
    }

    public void setId(String s) {
        _id = s;
    }

    public String getId() {
        return _id;
    }

    /**
     * Gets the value of content
     * 
     * @return the value of content
     */
    public String getContent() {
        return this._content;
    }

    /**
     * Sets the value of content
     * 
     * @param argContent Value to assign to this._content
     */
    public void setContent(String argContent) {
        this._content = argContent;
    }

    /**
     * Gets the value of description
     * 
     * @return the value of description
     */
    public String getDescription() {
        return this._description;
    }

    /**
     * Sets the value of description
     * 
     * @param argDescription Value to assign to this._description
     */
    public void setDescription(String argDescription) {
        this._description = argDescription;
    }

    /**
     * Gets the value of target
     * 
     * @return the value of target
     */
    public String getTarget() {
        return this._target;
    }

    /**
     * Sets the value of target
     * 
     * @param argTarget Value to assign to this._target
     */
    public void setTarget(String argTarget) {
        this._target = argTarget;
    }

    /**
     * Gets the value of link
     * 
     * @return the value of link
     */
    public String getLink() {
        return this._link;
    }

    /**
     * Sets the value of link
     * 
     * @param argLink Value to assign to this._link
     */
    public void setLink(String argLink) {
        this._link = argLink;
    }

    /**
     * Gets the value of expanded
     * 
     * @return the value of expanded
     */
    public boolean isExpanded() {
        return this._expanded;
    }

    /**
     * Sets the value of expanded
     * 
     * @param argExpanded Value to assign to this._expanded
     */
    public void setExpanded(boolean argExpanded) {
        this._expanded = argExpanded;
        if (argExpanded && _tree != null) {
            _tree.expanded(this);
        }
    }

    /**
     * Gets the value of contentModel
     * 
     * @return the value of contentModel
     */
    public Object getContentModel() {
        return this._contentModel;
    }

    /**
     * Sets the value of contentModel
     * 
     * @param argContentModel Value to assign to this._contentModel
     */
    public void setContentModel(Object argContentModel) {
        this._contentModel = argContentModel;
    }

    public void setExtraContentFirst(boolean b) {
        _extraContentFirst = b;
    }

    public boolean isExtraContentFirst() {
        return _extraContentFirst;
    }

    public void setExtraContent(String s) {
        _extraContent = s;
    }

    public String getExtraContent() {
        return _extraContent;
    }

    public boolean hasExtraContent() {
        return _extraContent != null;
    }

    public void setActive(boolean b) {
        _active = b;
    }

    public boolean isActive() {
        return _active;
    }

    ObjectTree getTree() {
        return _tree;
    }
}
