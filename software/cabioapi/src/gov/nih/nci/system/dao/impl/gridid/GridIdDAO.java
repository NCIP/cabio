/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.dao.impl.gridid;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.search.AbsoluteRangeQuery;
import gov.nih.nci.search.FeatureRangeQuery;
import gov.nih.nci.search.GridEntity;
import gov.nih.nci.search.GridIdQuery;
import gov.nih.nci.search.GridIdRangeQuery;
import gov.nih.nci.search.RangeQuery;
import gov.nih.nci.search.RelativeRangeQuery;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.dao.DAO;
import gov.nih.nci.system.dao.Request;
import gov.nih.nci.system.dao.Response;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import net.handle.server.IDSvcInterface;
import net.handle.server.IDSvcInterfaceFactory;
import net.handle.server.ResourceIdInfo;

import org.apache.log4j.Logger;

/**
 * Provides DAO functionality to perform Grid Id and Range queries.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GridIdDAO implements DAO {
    
	private static final Logger log = Logger.getLogger(GridIdDAO.class);

    private static final Class[] EMPTY_ARGS_TYPES = {};
    
    private static final List<String> DAO_CLASSES = new ArrayList<String>();
    static {
        DAO_CLASSES.add(GridIdQuery.class.getName());
        DAO_CLASSES.add(GridIdRangeQuery.class.getName());
        DAO_CLASSES.add(AbsoluteRangeQuery.class.getName());
        /* 
         * For every class we add above, all of its ancestor classes must be 
         * added below. This present a problem because many of these are abstract,
         * and we don't want them to show up. This is fixed in CaBioClassCache.
         */
        DAO_CLASSES.add(RangeQuery.class.getName());
        DAO_CLASSES.add(RelativeRangeQuery.class.getName());
    }

    private final Properties properties = new Properties();
    
    private ApplicationService appService = null;
    
	public void setApplicationService(ApplicationService appService) {
        this.appService = appService;
    }

    /**
	 * Constructor, which is called by Spring.
	 */
	public GridIdDAO() {
		
        String propertyFile = System.getProperty(
	        "gov.nih.nci.cacore.cacoreProperties");
        
	    log.info("Loading caCORE property file: " + propertyFile);
	    
	    FileInputStream fis = null;
	    
	    try {
	        fis = new FileInputStream(new File(propertyFile));
	        properties.load(fis);
	    }
	    catch (Exception e) {
	        log.error("Error loading caCORE property file",e);
	    }
	    finally {
	        try {
	            if (fis != null) fis.close();
	        }
	        catch (IOException e) {
	            log.error("Error closing caCORE property file",e);
	        }
	    }
	}

    /**
     * AbsoluteRangeQuery method.
     * @param targetClass type of physical locations to return
     * @param rangeQuery the query
     * @return list of physical locations
     * @throws ApplicationException
     */
    public List query(Class<? extends PhysicalLocation> targetClass, 
            AbsoluteRangeQuery rangeQuery) throws ApplicationException {
        
        Long lstart = rangeQuery.getStart();
        Long lend = rangeQuery.getEnd();
        
        // We prefer a chromosome object, but we'll take an id (intended for 
        // web interface queries)
        Long chromosomeId = rangeQuery.getChromosomeId();
        if (rangeQuery.getChromosome() != null) {
            chromosomeId = rangeQuery.getChromosome().getId();
        }
        
        log.info("rangeQuery("+lstart+","+lend+") assembly="+
            rangeQuery.getAssembly()+" partial="+rangeQuery.getAllowPartialMatches());

        List<Object> params = new ArrayList<Object>();
        params.add(rangeQuery.getAssembly());
        params.add(chromosomeId);
        params.add(lstart);
        params.add(lend);
        
        // The restriction on CHROMOSOME_ID works because it is an 
        // unambiguous column. This way we can avoid the join to Chromosome.
        StringBuffer hql = new StringBuffer(
                "from "+targetClass.getName()+" as p " +
                "where p.assembly = ? " +
                "and CHROMOSOME_ID = ? ");
        
        if (rangeQuery.getAllowPartialMatches()) {
            hql.append("and ((p.chromosomalStartPosition between ? and ?) " +
            		   "or (p.chromosomalEndPosition between ? and ?)) ");
            params.add(lstart);
            params.add(lend);
        }
        else {
            hql.append("and p.chromosomalStartPosition >= ? " +
            		   "and p.chromosomalEndPosition <= ? ");
        }
        
        String hqlQuery = hql.toString()+"order by p.chromosomalStartPosition";
        String hqlCount = "select count(*) "+hqlQuery;
        
        return appService.query(new HQLCriteria(hqlQuery, hqlCount, params));
    }

    /**
     * FeatureRangeQuery method.
     * @param targetClass type of physical locations to return
     * @param rangeQuery the query
     * @return list of physical locations
     * @throws ApplicationException
     */
    public List query(Class<? extends PhysicalLocation> targetClass, 
            FeatureRangeQuery rangeQuery) throws ApplicationException {

        final Object feature = rangeQuery.getFeature();
        // retrieve the location of the feature
        PhysicalLocation location = null;
        Long chromosomeId = null;

        if (feature instanceof PhysicalLocation) {
            location = (PhysicalLocation)feature;
            // must do a separate query to get the chromosome because this 
            // feature object has no session
            List results = appService.getAssociation(feature, "chromosome");
            Chromosome c = (Chromosome)results.get(0);
            chromosomeId = c.getId();
        }
        else {

            try {
                feature.getClass().getMethod(
                    "getPhysicalLocationCollection", EMPTY_ARGS_TYPES);
            }
            catch (NoSuchMethodException e) {
                throw new ApplicationException(
                    "The specified feature has no physicalLocationCollection");
            }
            
            String hql = "select c.id, " +
                    "min(p.chromosomalStartPosition) as start, " +
                    "max(p.chromosomalEndPosition) as end " +
                    "from "+feature.getClass().getName()+" as f " +
                    "left join f.physicalLocationCollection as p " +
                    "left join p.chromosome as c " +
                    "where f.id = ? " +
                    "and p.assembly = ? " +
                    "group by c.id";
            
            List params = new ArrayList();
            
            try {
                params.add(ReflectionUtils.get(feature, "id"));
                params.add(rangeQuery.getAssembly());
            }
            catch (Exception e) {
                throw new ApplicationException(e);
            }
            
            List results = appService.query(new HQLCriteria(hql, params));

            if (results.isEmpty()) {
                throw new IllegalStateException(
                "The specified feature has no PhysicalLocation data.");
            }

            if (results.size() > 1) {
                throw new IllegalStateException("The specified feature on " +
                    "the given assembly has locations on multiple chromosomes.");
            }

            Object[] agg = (Object[])results.get(0);
            chromosomeId = (Long)agg[0];
            location = new PhysicalLocation();
            location.setChromosomalStartPosition((Long)agg[1]);
            location.setChromosomalEndPosition((Long)agg[2]);
        }


        // calculate relative positions
        Long lstart = new Long(location.getChromosomalStartPosition().longValue() - 
            rangeQuery.getUpstreamDistance().longValue());
        Long lend = new Long(location.getChromosomalEndPosition().longValue() + 
            rangeQuery.getDownstreamDistance().longValue());

        // continue as an absolute query
        AbsoluteRangeQuery absoluteRangeQuery = new AbsoluteRangeQuery();
        absoluteRangeQuery.setAllowPartialMatches(
            rangeQuery.getAllowPartialMatches());
        absoluteRangeQuery.setChromosomeId(chromosomeId);
        absoluteRangeQuery.setStart(lstart);
        absoluteRangeQuery.setEnd(lend);
        
        return query(targetClass, absoluteRangeQuery);
    }
    
    /**
     * GridIdRangeQuery method.
     * @param targetClass type of physical locations to return
     * @param rangeQuery the query
     * @return list of physical locations
     * @throws ApplicationException
     */
    public List query(Class<? extends PhysicalLocation> targetClass, 
            GridIdRangeQuery rangeQuery) throws ApplicationException {

        // look up feature by big id
        final List gresults = query(rangeQuery);
        if (gresults == null || gresults.isEmpty()) {
            throw new ApplicationException("The specified Grid Id does not " +
                    "identify an object.");
        }
        
        // continue as a feature range query
        FeatureRangeQuery featureRangeQuery = new FeatureRangeQuery(rangeQuery);
        featureRangeQuery.setFeature(gresults.get(0));
        return query(targetClass, featureRangeQuery);
    }

    /**
     * Override DAO hook method. 
     */
    public List query(GridEntity gridIdQuery) throws ApplicationException {

        String bigId = gridIdQuery.getBigId();
        log.info("GridIdDAO: query for "+bigId);
        
        IDSvcInterface idInterface = null;
        try {
            // Resolve the classname and create the dummy object
            idInterface = IDSvcInterfaceFactory.getInterface(
                properties.getProperty("handler_path"));
        }
        catch (Exception e) {
            throw new ApplicationException(
                "Unable to connect to handler system",e);
        }
        
        String className = null;
        try {
        	ResourceIdInfo info = idInterface.getBigIDInfo(new URI(bigId));
            className = info.resourceIdentification.substring(0,
                    info.resourceIdentification.indexOf("|"));
        }
        catch (Exception e) {
        	throw new ApplicationException("Not a valid Grid Id: "+bigId, e);
        }

        try {
            Object dataObject = Class.forName(className).newInstance();
            ReflectionUtils.set(dataObject, "bigid", bigId);
            
            List results = appService.search(className, dataObject);
            log.info("bigid results: "+results);
            
            // Query the database to retrieve actual object
            if (results != null) {
                if (results.size() > 1) {
                    // In theory this could happen if 2 big ids are the same 
                    // except for case differences. In practice, we don't 
                    // currently have lowercase characters in big ids. If that
                    // ever happens, we will need to use a case-sensitive 
                    // search mechanism.
                    log.warn("Found more than one object with bigId="+bigId);
                }
                return results;
            }
            
            // Object was not found
            return null;
        }
        catch (Exception e) {
            throw new ApplicationException(
                    "Error retrieving object by Grid Id",e);
        }
	}

	public Response query(Request request) throws ApplicationException {
        
		final Object searchObject = request.getRequest(); 
		List results = null;
        
        if (searchObject instanceof RangeQuery) {
            final String targetClassName = request.getDomainObjectName();
            Class<? extends PhysicalLocation> targetClass;
            
            if ((targetClassName==null) || 
                    !targetClassName.startsWith("gov.nih.nci.cabio.domain.")) {
                targetClass = PhysicalLocation.class;
            }
            else {
                try {
                    targetClass = Class.forName(targetClassName).asSubclass(PhysicalLocation.class);
                } 
                catch (ClassNotFoundException e) {
                    throw new ApplicationException(
                        "Target class "+targetClassName+" not found.");
                } 
                catch (ClassCastException e) {
                    throw new ApplicationException(
                        "Target class must extend PhysicalLocation.");
                }
            }
            
            if (searchObject instanceof AbsoluteRangeQuery) {
                results = query(targetClass,(AbsoluteRangeQuery)searchObject);
            }
            else if (searchObject instanceof FeatureRangeQuery) {
                results = query(targetClass,(FeatureRangeQuery)searchObject);
            }
            else if (searchObject instanceof GridIdRangeQuery) {
                results = query(targetClass,(GridIdRangeQuery)searchObject);
            }
            else {
                throw new ApplicationException(
                    "GridIdDAO does not support request with "+
                    searchObject.getClass().getName());
            }
            
        }
        else if (searchObject instanceof GridEntity) {
            results = query((GridEntity)searchObject);
        }
        else {
			throw new ApplicationException(
					"GridIdDAO does not support request with "+
					searchObject.getClass().getName());
        }
        return new Response(results);
	}
    
    /**
     * Override DAO hook method. 
     */
    public List<String> getAllClassNames() {
        return DAO_CLASSES;
    }

}
