package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.util.URL2SC;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ObjectCacheLoaderServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errMsg = null;
        try {
            String url = createURL(request);
            SearchCriteria sc = URL2SC.map(url);
            ObjectCacheLoader loader = new ObjectCacheLoader(sc);
            loader.start();
            response.getWriter().println("Caching " + url);
        }
        catch (Exception ex) {
            ex.printStackTrace();
            errMsg = "Error caching: " + ex.getMessage();
        }
        if (errMsg != null) {
            try {
                response.getWriter().println(errMsg);
            }
            catch (Exception ex) {
                ex.printStackTrace();
                throw new ServletException("Error writing error message.", ex);
            }
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    public static String createURL(HttpServletRequest request) throws Exception {
        StringBuffer sb = new StringBuffer();
        sb.append("http://").append(request.getServerName()).append(":").append(
            request.getServerPort()).append(request.getRequestURI()).append("?");
        for (Enumeration paramNames = request.getParameterNames(); paramNames.hasMoreElements();) {
            String paramName = (String) paramNames.nextElement();
            String[] paramValues = null;
            if ("fillInObjects".equalsIgnoreCase(paramName)) {
                //Ignore. That is handled by this.getFillInObjects.
            }
            else {
                paramValues = request.getParameterValues(paramName);
            }
            if (paramValues != null) {
                for (int j = 0; j < paramValues.length; j++) {
                    sb.append(paramName + "=" + paramValues[j]);
                    if (j < paramValues.length - 1) {
                        sb.append("&");
                    }
                }
            }
            if (paramNames.hasMoreElements() && sb.length() > 0) {
                sb.append("&");
            }
        }
        return sb.toString();
    }
}
