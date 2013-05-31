/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.sod.SODUtils;
import gov.nih.nci.caBIOApp.sod.SearchableObject;
import gov.nih.nci.caBIOApp.ui.QueryDesign;
import gov.nih.nci.caBIOApp.ui.ValueLabelPair;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

public class CreateQueryForm extends ActionForm {

    private List _SOVLs = null;
    private String _selectedObjectName = null;
    private boolean _callingSubAction = false;
    private String _selectedQueryDesignId = null;
    private HashMap _queryDesigns = new HashMap();
    private List _qdVLs = new ArrayList();
    private String _label = null;

    public CreateQueryForm() {
        try {
            SODUtils sod = SODUtils.getInstance();
            _SOVLs = new ArrayList();
            List sos = sod.getSearchableObjects();
            for (Iterator i = sos.iterator(); i.hasNext();) {
                SearchableObject so = (SearchableObject) i.next();
                if (so.getDisplayable()) {
                    _SOVLs.add(new ValueLabelPair(so.getClassname(),
                            so.getLabel()));
                }
            }
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new RuntimeException("error getting searchable objects: "
                    + ex.getMessage());
        }
    }

    public List getSOVLs() {
        return _SOVLs;
    }

    public void setSelectedObjectName(String s) {
        _selectedObjectName = s;
    }

    public String getSelectedObjectName() {
        return _selectedObjectName;
    }

    public void setCallingSubAction(boolean b) {
        _callingSubAction = b;
    }

    public boolean getCallingSubAction() {
        return _callingSubAction;
    }

    public void setQueryDesigns(HashMap dqs) {
        _selectedObjectName = null;
        _selectedQueryDesignId = null;
        if (dqs != null) {
            _queryDesigns = dqs;
            _qdVLs = new ArrayList();
            for (Iterator i = _queryDesigns.keySet().iterator(); i.hasNext();) {
                QueryDesign qd = (QueryDesign) _queryDesigns.get((String) i.next());
                _qdVLs.add(new ValueLabelPair(qd.getId(), qd.getLabel()));
            }
        }
        else {
            _queryDesigns = new HashMap();
        }
    }

    public List getQDVLs() {
        return _qdVLs;
    }

    public void setSelectedQueryDesignId(String s) {
        _selectedQueryDesignId = s;
    }

    public String getSelectedQueryDesignId() {
        return _selectedQueryDesignId;
    }

    public QueryDesign rename() throws ServletException {
        QueryDesign qd = select();
        if (qd == null) {
            throw new ServletException("Couldn't find selected query design.");
        }
        qd.setLabel(_label);
        ValueLabelPair vlp = FormUtils.getVLP(_qdVLs, qd.getId());
        vlp.setLabel(_label);
        return qd;
    }

    public QueryDesign remove() throws ServletException {
        if (_selectedQueryDesignId == null) {
            throw new ServletException("No query design selected.");
        }
        _qdVLs.remove(new ValueLabelPair(_selectedQueryDesignId, null));
        return (QueryDesign) _queryDesigns.remove(_selectedQueryDesignId);
    }

    public QueryDesign create() throws ServletException {
        QueryDesign design = buildQueryDesign(_selectedObjectName, _label);
        _queryDesigns.put(design.getId(), design);
        _qdVLs.add(new ValueLabelPair(design.getId(), design.getLabel()));
        return design;
    }

    public QueryDesign select() throws ServletException {
        if (_selectedQueryDesignId == null) {
            throw new ServletException("Query design id is null.");
        }
        return (QueryDesign) _queryDesigns.get(_selectedQueryDesignId);
    }

    /*
    public QueryDesign getSelectedQueryDesign()
    throws ServletException
    {
    QueryDesign design = null;
    design = (QueryDesign)_queryDesigns.get( _selectedQueryDesignId );
    if( design == null && _selectedObjectName != null ){
      design = buildQueryDesign( _selectedObjectName );
      _queryDesigns.put( design.getId(), design );
      _qdVLs.add( new ValueLabelPair( design.getId(), design.getLabel() ) );
    }
    if( design == null ){
      throw new ServletException( "Error selecting query design: object name = " + 
    			  _selectedObjectName + ", query ID = " + 
    			  _selectedQueryDesignId );
    }
    return design;
    }
    */
    public QueryDesign buildQueryDesign(String classname, String label)
            throws ServletException {
        QueryDesign design = null;
        //SODUtils sod = SODUtils.getInstance();
        //SearchableObject so = sod.getSearchableObject( classname );
        //String time = DateFormat.getTimeInstance( DateFormat.SHORT ).format( new Date() );
        //String id = classname + "_" + System.currentTimeMillis();
        try {
            //design = new QueryDesign( id, so.getLabel() + " " + time, classname );
            design = new QueryDesign(label, label, classname);
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new ServletException("error creating new query design: "
                    + ex.getMessage());
        }
        return design;
    }

    public void setLabel(String s) {
        _label = s;
    }

    public String getLabel() {
        return _label;
    }

    public ActionErrors validate(ActionMapping mapping,
            HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        String nextStep = request.getParameter("nextStep");
        if (nextStep != null) {
            if ("create".equals(nextStep) || "rename".equals(nextStep)) {
                ActionError error = FormUtils.validateRequiredName(_label,
                    "createQueryForm.errors.queryLabelRequired", new String[0]);
                if (error == null) {
                    error = FormUtils.validateUniqueName(_label,
                        _queryDesigns.keySet(),
                        "createQueryForm.errors.uniqueLabelRequired");
                }
                if (error != null) {
                    errors.add("label", error);
                }
            }
        }
        return errors;
    }

    public void reset() {
        _label = null;
    }
}
