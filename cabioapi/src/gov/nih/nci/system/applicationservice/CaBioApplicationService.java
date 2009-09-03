package gov.nih.nci.system.applicationservice;

import gov.nih.nci.search.GridIdQuery;
import gov.nih.nci.search.RangeQuery;
import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.SummaryQuery;

import java.util.List;

/**
 * The caBIO extension of the ApplicationService, providing additional 
 * methods to interact with Grid Ids.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public interface CaBioApplicationService extends ApplicationService {

    /**
     * Check if the object specified by the given Grid Id exists in caBIO.
     * @param bigId Grid Identifier
     * @return true if the object exists
     * @throws Exception
     */
    public boolean exist(String bigId) throws ApplicationException;

    /**
     * Retrieve the domain object specified by the given Grid Id. 
     * @param bigId Grid Identifier
     * @return the object specified by the given Grid Id
     * @throws Exception
     */
    public Object getDataObject(String bigId) throws ApplicationException;

    /**
     * FreestyleLM search method. 
     * @param searchQuery FeeestyleLM Search Query
     * @return list of domain object results
     * @throws ApplicationException
     */
    public abstract List search(SearchQuery searchQuery) throws ApplicationException;

    /**
     * FreestyleLM summary search method. 
     * @param summaryQuery FeeestyleLM Summary Query
     * @return list of SummaryResult objects
     * @throws ApplicationException
     */
    public abstract List search(SummaryQuery summaryQuery) throws ApplicationException;
    
    /**
     * Location range search which returns PhysicalLocations.
     * @param rangeQuery Location Range Query
     * @return List of PhysicalLocation subclasses
     * @throws ApplicationException
     */
    public abstract List search(RangeQuery rangeQuery) 
            throws ApplicationException;

    /**
     * Query by Grid Id. It's usually better to use getDataObject() unless
     * you have a GridEntity object already.  
     * @param gridIdQuery Grid Id query
     * @return List of domain objects 
     * @throws ApplicationException
     */
    public abstract List search(GridIdQuery gridIdQuery) 
            throws ApplicationException;
    
    /**
     * Location range search which returns features with a specific type.
     * @param targetClass type of locations to return (must be a subclass of PhysicalLocation)
     * @param rangeQuery Location Range Query
     * @return List of PhysicalLocation subclasses
     * @throws ApplicationException
     */
    public abstract List search(Class targetClass, RangeQuery rangeQuery) 
            throws ApplicationException;
}
