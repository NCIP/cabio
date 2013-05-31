/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.pager;

import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PagerEventHandler extends HttpServlet {

    /**
     * The request scope key under which the datasource will be initially found.
     */
    private String _dataSourceKeyName = null;
    /**
     * The session scope key under which the selection of PagerItems elements
     * will be maintained.
     */
    private String _selectedItemsKeyName = null;
    /**
     * The request scope key under which the selection mode may initially be
     * found.
     * Valid values are "true" or "false", defaults to "true".
     */
    private String _allowSelectionKeyName = null;
    /**
     * The request scope key under which the default display size will initially
     * be found.
     * Defaults to 25.
     */
    private String _defaultDisplaySizeKeyName = null;
    /**
     * The request scope key under which the classname of the PagerBean may be
     * found.
     */
    private String _pagerBeanClassnameKeyName = null;
    private String _pagerBeanClassname = null;
    /**
     * The session scope key under which the PagerBean instance will be cached.
     */
    private String _pagerBeanKeyName = null;
    private String _selectedIdsKeyName = null;
    private String _scrollDirectionKeyName = null;
    private String _pagerActionKeyName = null;
    private String _initialForward = null;
    private String _scrollForward = null;
    private String _selectForward = null;
    private String _deselectForward = null;
    private String _finishForward = null;
    private String _dataSourceKeyNameKeyName = null;
    private String _pagerBeanKeyNameKeyName = null;
    private String _selectedItemsKeyNameKeyName = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        _dataSourceKeyName = config.getInitParameter("dataSourceKeyName");
        if (_dataSourceKeyName == null) {
            _dataSourceKeyName = "gov.nih.nci.caBIOApp.ui.pager.dataSource";
        }
        _dataSourceKeyNameKeyName = config.getInitParameter("dataSourceKeyNameKeyName");
        if (_dataSourceKeyNameKeyName == null) {
            _dataSourceKeyNameKeyName = "gov.nih.nci.caBIOApp.ui.pager.dataSourceKeyName";
        }
        _selectedItemsKeyName = config.getInitParameter("selectedItemsKeyName");
        if (_selectedItemsKeyName == null) {
            _selectedItemsKeyName = "gov.nih.nci.caBIOApp.ui.pager.selectedItems";
        }
        _selectedItemsKeyNameKeyName = config.getInitParameter("selectedItemsKeyNameKeyName");
        if (_selectedItemsKeyNameKeyName == null) {
            _selectedItemsKeyNameKeyName = "gov.nih.nci.caBIOApp.ui.pager.selectedItemsKeyName";
        }
        _selectedIdsKeyName = config.getInitParameter("selectedIdsKeyName");
        if (_selectedIdsKeyName == null) {
            _selectedIdsKeyName = "selectedIds";
        }
        _allowSelectionKeyName = config.getInitParameter("allowSelectionKeyName");
        if (_allowSelectionKeyName == null) {
            _allowSelectionKeyName = "gov.nih.nci.caBIOApp.ui.pager.selectionMode";
        }
        _defaultDisplaySizeKeyName = config.getInitParameter("defaultDisplaySize");
        if (_defaultDisplaySizeKeyName == null) {
            _defaultDisplaySizeKeyName = "gov.nih.nci.caBIOApp.ui.pager.defaultDisplaySize";
        }
        _pagerBeanClassname = config.getInitParameter("pagerBeanClassname");
        if (_pagerBeanClassname == null) {
            _pagerBeanClassname = "gov.nih.nci.caBIOApp.ui.pager.PagerBeanImpl";
        }
        _pagerBeanClassnameKeyName = config.getInitParameter("pagerBeanClassnameKeyName");
        if (_pagerBeanClassnameKeyName == null) {
            _pagerBeanClassnameKeyName = "gov.nih.nci.caBIOApp.ui.pager.pagerBeanClassname";
        }
        _pagerBeanKeyName = config.getInitParameter("pagerBeanKeyName");
        if (_pagerBeanKeyName == null) {
            _pagerBeanKeyName = "pagerBean";
        }
        _pagerBeanKeyNameKeyName = config.getInitParameter("pagerBeanKeyNameKeyName");
        if (_pagerBeanKeyNameKeyName == null) {
            _pagerBeanKeyNameKeyName = "gov.nih.nci.caBIOApp.ui.pager.pagerBeanKeyName";
        }
        _pagerActionKeyName = config.getInitParameter("pagerActionKeyName");
        if (_pagerActionKeyName == null) {
            _pagerActionKeyName = "pagerAction";
        }
        _scrollDirectionKeyName = config.getInitParameter("scrollDirectionKeyName");
        if (_scrollDirectionKeyName == null) {
            _scrollDirectionKeyName = "scrollDirection";
        }
        _initialForward = config.getInitParameter("initialForward");
        _scrollForward = config.getInitParameter("scrollForward");
        _selectForward = config.getInitParameter("selectForward");
        _deselectForward = config.getInitParameter("deselectForward");
        _finishForward = config.getInitParameter("finishForward");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String forward = null;
        boolean isInitialEntry = false;
        String action = null;
        HttpSession session = request.getSession();
        String dataSourceKeyName = request.getParameter(_dataSourceKeyNameKeyName);
        if (dataSourceKeyName == null) {
            dataSourceKeyName = _dataSourceKeyName;
        }
        String pagerBeanKeyName = request.getParameter(_pagerBeanKeyNameKeyName);
        if (pagerBeanKeyName == null) {
            pagerBeanKeyName = _pagerBeanKeyName;
        }
        String selectedItemsKeyName = request.getParameter(_selectedItemsKeyNameKeyName);
        if (selectedItemsKeyName == null) {
            selectedItemsKeyName = _selectedItemsKeyName;
        }
        PagerBean bean = null;
        MessageLog.printInfo("PagerEventHandler.doGet(): looking for datasource under "
                + dataSourceKeyName);
        PagerDataSource dataSource = (PagerDataSource) request.getAttribute(dataSourceKeyName);
        if (dataSource != null) {
            MessageLog.printInfo("PageEventHandler: dataSource is not null. Calling initBean()...");
            bean = initBean(dataSource, request);
            MessageLog.printInfo("PageEventHandler: putting pagerBean in session under "
                    + pagerBeanKeyName);
            session.setAttribute(pagerBeanKeyName, bean);
            //request.setAttribute( pagerBeanKeyName, bean );
            isInitialEntry = true;
        }
        else {
            MessageLog.printInfo("PageEventHandler: dataSource is null. Calling populateBean()...");
            bean = (PagerBean) session.getAttribute(pagerBeanKeyName);
            if (bean == null) {
                throw new ServletException("No pager bean found under "
                        + pagerBeanKeyName);
            }
            populateBean(bean, request);
            action = request.getParameter(_pagerActionKeyName);
        }
        if (isInitialEntry) {
            bean.setScrollDirection("begin");
            try {
                bean.scroll();
            }
            catch (Exception ex) {
                throw new ServletException("Error scrolling.", ex);
            }
            forward = _initialForward;
        }
        else if ("scroll".equals(action)) {
            try {
                bean.scroll();
            }
            catch (Exception ex) {
                throw new ServletException("Error scrolling.", ex);
            }
            forward = _scrollForward;
        }
        else if ("select".equals(action)) {
            bean.select();
            session.setAttribute(selectedItemsKeyName, bean.getSelectedItems());
            forward = _selectForward;
        }
        else if ("deselect".equals(action)) {
            bean.deselect();
            session.setAttribute(selectedItemsKeyName, bean.getSelectedItems());
            forward = _deselectForward;
        }
        else if ("finish".equals(action)) {
            session.setAttribute(selectedItemsKeyName, bean.getSelectedItems());
            session.removeAttribute(pagerBeanKeyName);
            forward = _finishForward;
        }
        else {
            throw new ServletException("Unknown operation: " + action);
        }
        forward(request, response, forward);
    }

    private PagerBean initBean(PagerDataSource dataSource,
            HttpServletRequest request) throws ServletException {
        String classname = request.getParameter(_pagerBeanClassnameKeyName);
        if (classname == null) {
            classname = _pagerBeanClassname;
        }
        PagerBean bean = null;
        MessageLog.printInfo("PB.init: instantiating " + classname);
        try {
            bean = (PagerBean) Class.forName(classname).newInstance();
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException("Couldn't instantiate: " + classname, ex);
        }
        try {
            bean.setPagerDataSource(dataSource);
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException("Error setting data source on bean.", ex);
        }
        String allowSelection = request.getParameter(_allowSelectionKeyName);
        if (allowSelection == null) {
            allowSelection = "true";
        }
        if ("true".equals(allowSelection)) {
            bean.setAllowSelection(true);
        }
        else {
            bean.setAllowSelection(false);
        }
        try {
            String s = request.getParameter(_defaultDisplaySizeKeyName);
            if (s != null) {
                bean.setDefaultDisplaySize(Integer.parseInt(s));
            }
        }
        catch (Exception ex) {
            throw new ServletException("Error setting default display size.",
                    ex);
        }
        return bean;
    }

    private void populateBean(PagerBean bean, HttpServletRequest request) {
        bean.setSelectedIds(request.getParameterValues(_selectedIdsKeyName));
        bean.setScrollDirection(request.getParameter(_scrollDirectionKeyName));
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void forward(HttpServletRequest request,
            HttpServletResponse response, String forward)
            throws ServletException, IOException {
        MessageLog.printInfo("PagerEventHandler: forwarding to " + forward);
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(
            forward);
        if (dispatcher == null) {
            throw new ServletException("Couldn't get dispatcher for: "
                    + forward);
        }
        dispatcher.forward(request, response);
    }
}
