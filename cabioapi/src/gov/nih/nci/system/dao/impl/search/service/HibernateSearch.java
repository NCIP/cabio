package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.indexgen.SearchAPIProperties;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.DAOException;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.SortField;
import org.hibernate.JDBCException;
import org.hibernate.SessionFactory;
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
    
    private static SearchAPIProperties prop = SearchAPIProperties.getInstance();
        
    private SessionFactory sessionFactory;
    
    public HibernateSearch(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    /**
     * Performs queries on the underlying database
     * @param queryString
     * @return
     * @throws FreestyleLMException
     */
    public List<SearchResult> query(String queryString, Sort sort) throws FreestyleLMException{        
        List<SearchResult> resultList = null;
        FullTextSession fullTextSession;

        try {
            fullTextSession = org.hibernate.search.Search.createFullTextSession(sessionFactory.openSession());
            if(fullTextSession == null) {
                log.error("Cannot create full text session.");
            }
        }
        catch(Exception e) {
            log.error("Unable to open session " + e);
            throw new FreestyleLMException("Unable to open session  " + e);
        }
      try {
          QueryParser parser = new MultiFieldQueryParser(
              prop.getIndexedFields(), new StandardAnalyzer());
          
          Query luceneQuery = parser.parse(queryString);
          
          FullTextQueryImpl fullTextQuery = (FullTextQueryImpl)
              fullTextSession.createFullTextQuery(luceneQuery);
          
          if(sort!=null){
              if(sort.getSortByClassName()){
                  SortField field = new SortField("_hibernate_class", SortField.STRING, !sort.getAscOrder());                      
                  fullTextQuery = (FullTextQueryImpl)fullTextQuery.setSort(
                      new org.apache.lucene.search.Sort(field));
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
    public List<SearchResult> query(String searchString) throws FreestyleLMException{       
        return query(searchString, new Sort());
    }

    public List<SearchResult> query(String searchString, String className,
            Sort sort) throws FreestyleLMException {
        throw new UnsupportedOperationException(
            "Single class query is not supported with the Hibernate Search. " +
            "Use the Full Text Search instead.");
    }

    public List<SearchResult> query(String searchString, String className)
            throws FreestyleLMException {
        return query(searchString, className, new Sort());
    }
}
