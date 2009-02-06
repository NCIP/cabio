package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.indexgen.SearchAPIProperties;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.ParallelMultiSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.store.FSDirectory;

/**
 * Performes full text searches on a Lucene-based index.
 * 
 * @author Shaziya Muhsin
 */
public class FullTextSearch implements Searchable {
    
    String indexPropertyFile = "indexedFields.properties";
    private static final Logger log = Logger.getLogger(FullTextSearch.class);

    /**
     * Performs a full text search for a given string
     */
    public List query(String searchString)throws FreestyleLMException{
        List results = new ArrayList();
        try{           
            results = luceneSearch(searchString);
        }
        catch(Exception ex){
            throw new FreestyleLMException("Full text search failed: " + ex.getMessage(), ex);
        }
        return results;

    }
    /**
     * Performs a text based search for a given String.
     * If sort is set to true the results returned are sorted. 
     */
    public List query(String searchString, gov.nih.nci.search.Sort sort)throws FreestyleLMException{
        List results = new ArrayList();
        try{
            results = luceneSearch(searchString, sort);
        }
        catch(Exception ex){
            throw new FreestyleLMException("Full text search failed: "+ ex.getMessage(),ex);
        }
        return results;
    }
    
    /**
     * Returns the field names that are indexed
     * @return
     * @throws Exception
     */
    private String[] getIndexedFields() throws Exception{ 
        SearchAPIProperties properties = SearchAPIProperties.getInstance();
        return properties.getIndexedFields();
    }
        
    /**
     * Returns a list of subdirectories located within the given root directory
     * @param indexRoot
     * @return
     * @throws Exception
     */
    private File[] getDirectoryList(String indexRoot) throws Exception{            
        File dir = new File(indexRoot);
        FileFilter fileFilter = new FileFilter(){
            public boolean accept(File file){
                return file.isDirectory();
            }
        };
        return dir.listFiles(fileFilter);
    }
    
    /**
     * Returns the index location
     * @return
     * @throws Exception
     */
    private String getIndexLocation() throws Exception{
        SearchAPIProperties prop = SearchAPIProperties.getInstance();
        String indexFileLocation = prop.getIndexLocation();
        log.debug("Index Location: "+ indexFileLocation);
        return indexFileLocation;
    }
    
    /**
     * Creates a ParellelMultiSearcher for the indexes
     * @return
     * @throws Exception
     */
    private ParallelMultiSearcher getIndexSearchers() throws FreestyleLMException, Exception{
        String indexLocation = getIndexLocation();
        IndexSearcher[] searchers = null;
        File[] files = null;
        try{
            files = getDirectoryList(indexLocation);
            searchers = new IndexSearcher[files.length];               
        }catch(Exception ex){
            throw new FreestyleLMException(indexLocation+" Invalid index directory specified: " + ex.getMessage(), ex);
        }
        for(int i=0; i< files.length; i++){
            searchers[i]=new IndexSearcher(FSDirectory.getDirectory(files[i],false));
        } 
        return new ParallelMultiSearcher(searchers);        
    }
    
    public List luceneSearch(String searchString) throws Exception{
        return luceneSearch(searchString, new gov.nih.nci.search.Sort());
    }
    
    /**
     * Performs a search on the indexes for the given string 
     * @param searchString specifies the search criteria
     * @return
     * @throws Exception
     */
    public List luceneSearch(String searchString, gov.nih.nci.search.Sort sort) throws FreestyleLMException, Exception{        
        ParallelMultiSearcher multiSearcher = null;
        Query query = null;
        List results = new ArrayList();
       
        try{
            try {
                multiSearcher = getIndexSearchers();
            }
            catch(Exception ex){
                throw new FreestyleLMException("Unable to get lucene searchers "+ ex.getMessage(),ex);
            }                
            String searchFields[] = getIndexedFields();            
            QueryParser parser = new MultiFieldQueryParser(searchFields, new StandardAnalyzer());
            query = parser.parse(searchString);
            Hits hits = null;   
        
            if(sort.getSortByClassName()){
                SortField field = null;                
                if(sort.getAscOrder()){
                    field = new SortField("_hibernate_class", SortField.STRING);  
                }else{
                    field = new SortField("_hibernate_class", SortField.STRING, true);  
                }                               
                Sort sortByClass = new Sort(field);                
                hits = multiSearcher.search(query, sortByClass);                
            }else{
                hits = multiSearcher.search(query);                
            }
        
            results = getSearchResults(hits, searchString);
            multiSearcher.close();
        }
        catch (Exception e){
            throw new FreestyleLMException("Lucene Search Error " + e.getMessage(),e);
        }
        return results;
    }
    
    /**
     * Returns a SearchResult object for a given document
     * @param doc 
     * @param i
     * @param keyword
     * @return
     */  
    private SearchResult getSearchResult(Document doc, int i, String keyword){
        SearchResult result = new SearchResult();
        HashMap<String,String> properties = new HashMap<String, String>();        
        for(Iterator it = doc.getFields().iterator(); it.hasNext(); ){
            org.apache.lucene.document.Field field = (org.apache.lucene.document.Field)it.next();        
            properties.put(field.name(), field.stringValue());
            if(field.name().equalsIgnoreCase("_hibernate_class")){
                result.setClassName(field.stringValue());
            }
            if(field.name().equalsIgnoreCase("id")){
                result.setId(field.stringValue());
            }
        }
        result.setProperties(properties);
        int num = i;
        result.setHit(num);
        result.setKeyword(keyword);
        return result;
    }
    
    /**
     * Returns a List of SearchResult objects for the specified Hits
     * @param hits
     * @param searchString
     * @return
     * @throws Exception
     */
    public List getSearchResults(Hits hits, String searchString) throws Exception{
        List<SearchResult> resultList = new ArrayList<SearchResult>();            
        for(int i=0; i<hits.length(); i++){          
            Document doc = hits.doc(i);
            int num = i +1;
            SearchResult result = getSearchResult(doc,num,searchString);
            resultList.add(result);                        
        }
        return resultList;
    }
    
 
}
