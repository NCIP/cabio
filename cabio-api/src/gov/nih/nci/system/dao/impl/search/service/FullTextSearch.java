package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.indexgen.SearchAPIProperties;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.search.SummaryResult;
import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.ParallelMultiSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;
import org.apache.lucene.search.SortField;
import org.apache.lucene.store.FSDirectory;

/**
 * Performs full text searches on a Lucene-based index.
 * 
 * @author Shaziya Muhsin
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class FullTextSearch implements Searchable {
    
    private static final Logger log = Logger.getLogger(FullTextSearch.class);

    private static final SearchAPIProperties prop = SearchAPIProperties.getInstance();
    
    /**
     * Performs a full text search for a given String.
     */
    public List<SearchResult> query(String searchString) 
            throws FreestyleLMException {
        return query(searchString, null, new Sort());
    }
    
    /**
     * Performs a text based search for a given String.
     * Allows sorting of the results. 
     */
    public List<SearchResult> query(String searchString, Sort sort)
            throws FreestyleLMException {
        return query(searchString, null, sort);
    }

    /**
     * Performs a text based search for a given String in the given class.
     */
    public List<SearchResult> query(String searchString, String className)
            throws FreestyleLMException {
        return query(searchString, className, new Sort());
    }

    /**
     * Performs a text based search for a given String in the given class.
     * Allows sorting of the results.
     */
    public List<SearchResult> query(String searchString, String className, Sort sort)
            throws FreestyleLMException {
        return luceneSearch(searchString, className, sort, false);
    }
    
    /**
     * Performs a text based search for a given String.
     */
    public List<SummaryResult> querySummary(String searchString)
            throws FreestyleLMException {
        return luceneSearch(searchString, null, null, true);
    }

    /**
     * Returns the index location.
     * @return
     * @throws Exception
     */
    private String getIndexLocation() {
        String indexFileLocation = prop.getIndexLocation();
        log.debug("Index Location: "+ indexFileLocation);
        return indexFileLocation;
    }
        
    /**
     * Returns a list of subdirectories located within the given root directory.
     * @param indexRoot
     * @return
     * @throws Exception
     */
    private File[] getDirectoryList(String indexRoot) {            
        File dir = new File(indexRoot);
        FileFilter fileFilter = new FileFilter(){
            public boolean accept(File file){
                return file.isDirectory();
            }
        };
        return dir.listFiles(fileFilter);
    }
    
    /**
     * Creates a ParellelMultiSearcher for all the indexes.
     * @return
     * @throws Exception
     */
    private Searcher getIndexSearcher() throws FreestyleLMException {
        
        File[] files = getDirectoryList(getIndexLocation());
        IndexSearcher[] searchers = new IndexSearcher[files.length];  
                         
        try {
            for(int i=0; i< files.length; i++){
                searchers[i] = new IndexSearcher(FSDirectory.getDirectory(files[i]));
            } 
            return new ParallelMultiSearcher(searchers);  
        }
        catch (IOException e) {
            throw new FreestyleLMException("Error creating index searcher",e);
        }
    }

    /**
     * Creates a Searcher for the given class.
     * @return
     * @throws Exception
     */
    private Searcher getIndexSearcher(Class<?> clazz) 
            throws FreestyleLMException {
        
        String indexFileLocation = prop.getIndexLocation();
        
        try {
            return new IndexSearcher(indexFileLocation+"/"+clazz.getName());
        }
        catch (IOException e) {
            throw new FreestyleLMException("Error creating index searcher",e);
        }
    }
    
    /**
     * Performs a search and returns the Hits.
     * @param searchString
     * @param className
     * @param sort
     * @return
     * @throws FreestyleLMException
     */
    private List luceneSearch(String searchString, String className, 
            Sort sort, boolean summarize) throws FreestyleLMException {
               
        List results = null;
        Searcher searcher = null;
        if (className != null) {
            try {
                searcher = getIndexSearcher(Class.forName(className));
            }
            catch (ClassNotFoundException e) {
                throw new FreestyleLMException("No such class: "+className);
            }
        } 
        else {
            searcher = getIndexSearcher();
        }

        try {
            QueryParser parser = new MultiFieldQueryParser(
                prop.getIndexedFields(), new StandardAnalyzer());
            Query query = parser.parse(searchString);
            
            Hits hits = null; 
            if(sort != null && sort.getSortByClassName()) {
                SortField field = new SortField("_hibernate_class", 
                    SortField.STRING, !sort.getAscOrder());
                hits = searcher.search(query, 
                    new org.apache.lucene.search.Sort(field));                
            }
            else {
                hits = searcher.search(query);                
            }

            if (summarize) {
                results = getSearchSummary(hits, searchString);
            }
            else {
                results = getSearchResults(hits, searchString);
            }
            
            searcher.close();
        }
        catch (ParseException e) {
            throw new FreestyleLMException(
                "Error parsing search string: "+searchString,e);
        }
        catch (IOException e) {
            throw new FreestyleLMException(
                "Error accessing FreestyleLM indexes", e);
        }
        return results;
    }

    
    /**
     * Returns a List of SearchResult objects for the specified Hits
     * @param hits
     * @param searchString
     * @return
     * @throws Exception
     */
    private List<SummaryResult> getSearchSummary(Hits hits, String searchString) 
            throws FreestyleLMException {
        
        Map<String, SummaryResult> counts = new HashMap<String, SummaryResult>();    
        
        for(int i=0; i<hits.length(); i++) {

            Document doc = null;
            try {
                doc = hits.doc(i);
            }
            catch (IOException e) {
                throw new FreestyleLMException("Error retrieving document #"
                    +i+" for search "+searchString,e);
            }
            
            String className = doc.getField("_hibernate_class").stringValue();
            SummaryResult count = null;
            if (!counts.containsKey(className)) {
                count = new SummaryResult();
                count.setClassName(className);
                counts.put(className, count);
            }
            else {
                count = counts.get(className);
            }
            count.setHits(count.getHits() + 1);
        }
        List<SummaryResult> results = new ArrayList<SummaryResult>();
        results.addAll(counts.values());
        return results;
    }
    
    /**
     * Returns a List of SearchResult objects for the specified Hits
     * @param hits
     * @param searchString
     * @return
     * @throws Exception
     */
    public List<SearchResult> getSearchResults(Hits hits, String searchString) 
            throws FreestyleLMException {
        
        List<SearchResult> resultList = new ArrayList<SearchResult>();            
        for(int i=0; i<hits.length(); i++) {
            
            Document doc = null;
            try {
                doc = hits.doc(i);
            }
            catch (IOException e) {
                throw new FreestyleLMException("Error retrieving document #"
                    +i+" for search "+searchString,e);
            }
            
            int num = i +1;
            SearchResult result = getSearchResult(doc);
            result.setKeyword(searchString);
            result.setHit(num);
            resultList.add(result);                        
        }
        return resultList;
    }

    /**
     * Returns a SearchResult object for a given document
     * @param doc 
     * @param i
     * @param keyword
     * @return
     */  
    private SearchResult getSearchResult(Document doc) {
        
        SearchResult result = new SearchResult();
        HashMap<String,String> properties = new HashMap<String, String>();
        
        for(Iterator it = doc.getFields().iterator(); it.hasNext(); ){
            Field field = (Field)it.next();        
            properties.put(field.name(), field.stringValue());
            if(field.name().equalsIgnoreCase("_hibernate_class")){
                result.setClassName(field.stringValue());
            }
            if(field.name().equalsIgnoreCase("id")){
                result.setId(field.stringValue());
            }
        }
        
        result.setProperties(properties);
        return result;
    }
}
