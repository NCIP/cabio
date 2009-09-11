package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.search.SearchResult;
import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.util.List;

/**
 * Interface that defines the search functionality.
 * 
 * @author Shaziya Muhsin
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public interface Searchable {
    
    public List<SearchResult> query(String searchString) 
        throws FreestyleLMException;

    public List<SearchResult> query(String searchString, Sort sort) 
        throws FreestyleLMException;
    
    public List<SearchResult> query(String searchString, String className)
        throws FreestyleLMException;
    
    public List<SearchResult> query(String searchString, String className, 
        Sort sort) throws FreestyleLMException; 
}
