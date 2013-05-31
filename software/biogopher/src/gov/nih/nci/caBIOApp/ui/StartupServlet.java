/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui;

import gov.nih.nci.caBIOApp.util.AppConfig;

import java.io.IOException;

import javax.servlet.GenericServlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class StartupServlet extends GenericServlet {

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            AppConfig wac = AppConfig.getInstance();
        }
        catch (Exception ex) {
            log("StartupServlet.init(): caught " + ex.getClass().getName()
                    + ": " + ex.getMessage());
            throw new ServletException("Error initializing ui config. ", ex);
        }
    }

    public void service(ServletRequest req, ServletResponse res)
            throws ServletException, IOException {
        // nothing
    }
}
