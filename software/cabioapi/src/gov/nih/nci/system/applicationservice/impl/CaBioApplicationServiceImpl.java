/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.applicationservice.impl;

import gov.nih.nci.search.GridIdQuery;
import gov.nih.nci.search.RangeQuery;
import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.dao.Request;
import gov.nih.nci.system.dao.impl.gridid.GridIdDAO;
import gov.nih.nci.system.util.ClassCache;

import java.util.List;

import org.apache.log4j.Logger;

/**
 * Implementation of the ApplicationService for caBIO. Adds methods for Grid Id 
 * and FreestyleLM searching to the default ORM implementation.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
@SuppressWarnings("deprecation")
public class CaBioApplicationServiceImpl extends ApplicationServiceImpl
        implements CaBioApplicationService {

    private static final Logger log = Logger.getLogger(CaBioApplicationServiceImpl.class);
    
    private final GridIdDAO gridIdDAO;
    
    private final ClassCache classCache;
    
    
    public CaBioApplicationServiceImpl(ClassCache classCache) {
        super(classCache);
        
        // hold onto this so that we can do our own DAO queries
        this.classCache = classCache;
        
        // since this is a circular dependency it must be completed here 
        // rather than in the Spring config
        gridIdDAO = (GridIdDAO)classCache.getDAOForClass(GridIdQuery.class.getName());
        gridIdDAO.setApplicationService(this);
    }

    public boolean exist(String bigId) throws ApplicationException {
        return (getDataObject(bigId) != null);
    }

    public Object getDataObject(String bigId) throws ApplicationException {
        GridIdQuery gridIdQuery = new GridIdQuery();
    	gridIdQuery.setBigId(bigId);
    	List results = search(gridIdQuery);
    	if (results == null || results.isEmpty()) return null;
    	return results.get(0);
    }

    public List search(SearchQuery searchQuery) throws ApplicationException {
        if (searchQuery.getKeyword() == null) throw new ApplicationException(
            "You must specify a search string (keyword).");
        Request request = new Request(searchQuery);
        request.setDomainObjectName(searchQuery.getClass().getName());
        return (List)super.query(request).getResponse();
    }

    public List search(RangeQuery rangeQuery) throws ApplicationException {
        return search(RangeQuery.class, rangeQuery);
    }
    
    public List search(Class targetClass, RangeQuery rangeQuery) throws ApplicationException {
        Request request = new Request(rangeQuery);
        request.setDomainObjectName(targetClass.getName());
        request.setClassCache(classCache);
        return (List)gridIdDAO.query(request).getResponse();
    }
    
    public List search(GridIdQuery gridIdQuery) throws ApplicationException {
        if (gridIdQuery.getBigId() == null) throw new ApplicationException(
            "You must specify a grid identifier (bigId).");
        Request request = new Request(gridIdQuery);
        request.setDomainObjectName(gridIdQuery.getClass().getName());
        request.setClassCache(classCache);
        return (List)gridIdDAO.query(request).getResponse();
    }
    
    public List search(String path, Object criteria) throws ApplicationException {
        if (criteria instanceof SearchQuery) {
            return search((SearchQuery)criteria);
        }
        else if (criteria instanceof RangeQuery) {
            log.info("criteria is RangeQuery("+path+")");
            try {
                return search(Class.forName(path),(RangeQuery)criteria);
            }
            catch (ClassNotFoundException e) {
                throw new ApplicationException(e);
            }
        }
        else if (criteria instanceof GridIdQuery) {
            log.info("criteria is GridIdQueryImpl");
            return search((GridIdQuery)criteria);
        }
        return super.search(path, criteria);
    }
}
