package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.indexgen.SearchAPIProperties;
import gov.nih.nci.system.dao.DAOException;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.hibernate.JDBCException;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.query.FullTextQueryImpl;

/**
 * HibernateSearch performs text based queries by synchronizing the document index with the database, 
 * and returns domain objects back to the user. This class implements the Hibernate search engine.
 * 
 * @author Shaziya Muhsin
 */
public class HibernateSearch implements Searchable {
    
    private static Logger log = Logger.getLogger(HibernateSearch.class);
    private SearchAPIProperties properties;
    
    /**
     * Default constructor
     */
    public HibernateSearch() throws Exception {
    	properties = SearchAPIProperties.getInstance();
    }

    /**
     * Performs queries on the underlying database
     * @param queryString
     * @return
     * @throws FreestyleLMException
     */
    public List query(String queryString, gov.nih.nci.search.Sort sort) throws FreestyleLMException{        
        List resultList = null;
        FullTextSession fullTextSession;

        try {
            fullTextSession = org.hibernate.search.Search.createFullTextSession(SearchAPIProperties.getSession());
            if(fullTextSession == null){
                log.error("Cannot create full text session......");
            }
        }
        catch(Exception e) {
            log.error("Unable to open session " + e);
            throw new FreestyleLMException("Unable to open session  " + e);
        }
      try{
          String keyword = queryString;          
          org.apache.lucene.queryParser.QueryParser parser = new MultiFieldQueryParser(getIndexedFields(), new StandardAnalyzer());
          org.apache.lucene.search.Query luceneQuery = parser.parse( keyword );
          FullTextQueryImpl fullTextQuery = (FullTextQueryImpl)fullTextSession.createFullTextQuery(luceneQuery);
          
          if(sort!=null){
              if(sort.getSortByClassName()){
                  SortField field = null; 
                  if(sort.getAscOrder()){
                      field = new SortField("_hibernate_class", SortField.STRING);  
                  }else{
                      field = new SortField("_hibernate_class", SortField.STRING, true);  
                  }                               
                  Sort sortByClass = new Sort(field); 
                  fullTextQuery = (FullTextQueryImpl) fullTextQuery.setSort(sortByClass);
              }             
          }
          resultList = fullTextQuery.list();
          log.info("Results: "+ resultList.size());
        }
        catch (JDBCException ex) {
            log.error("JDBC Exception in SearchAPIDAO ", ex);
            throw new FreestyleLMException("JDBC Exception in SearchAPIDAO ", ex);
        }
        catch(org.hibernate.HibernateException hbmEx) {
            log.error(hbmEx.getMessage());
            throw new FreestyleLMException("Hibernate problem ", hbmEx);
        }
        catch(Exception e) {
            log.error("Exception ", e);
            throw new FreestyleLMException("Exception in the SearchAPIDAO ", e);
        }
        finally {
            try {
               fullTextSession.clear();
               fullTextSession.close();
            }
            catch (Exception eSession) {
                log.error("Could not close the session - "+ eSession.getMessage());
                throw new FreestyleLMException("Could not close the session  " + eSession);
            }
        }
        return resultList;
    }
    
    /**
     * Executes queries 
     * @param searchString
     * @param sort
     * @return returns sorted results
     * @throws DAOException
     */
    public List query(String searchString) throws FreestyleLMException{       
        return query(searchString, new gov.nih.nci.search.Sort());
    }
    
    private String[] getIndexedFields() throws Exception {
        return properties.getIndexedFields();
    }

}
