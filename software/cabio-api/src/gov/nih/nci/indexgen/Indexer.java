/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.indexgen;

import org.hibernate.CacheMode;
import org.hibernate.FlushMode;
import org.hibernate.ScrollMode;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.persister.entity.EntityPersister;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.Search;

/**
 * Generates Lucene indexes for a given entity.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 */
public class Indexer extends Thread {
    
    private FullTextSession fullTextSession;
    
    private EntityPersister entity;

    // TODO: load this from hibernate.properties since it must match 
    private int batchSize = 200;

    /**
     * Generates an index for the specified entity
     */
    public Indexer(Session session, EntityPersister entity) {
        this.fullTextSession = Search.createFullTextSession(session);
        this.entity = entity;
    }

    /**
     * Generates lucene documents
     */
    public void run() {
        
        System.out.println("Started "+entity.getEntityName());
        
        long start = System.currentTimeMillis();

        try {
            fullTextSession.setFlushMode(FlushMode.MANUAL);
            fullTextSession.setCacheMode(CacheMode.IGNORE);
            Transaction transaction = fullTextSession.beginTransaction();
            
            // Scrollable results will avoid loading too many objects in memory
            ScrollableResults results = fullTextSession.createQuery(
                "from "+entity.getEntityName()).scroll(ScrollMode.FORWARD_ONLY);
            
            int i = 0;
            while( results.next()) {
                fullTextSession.index(results.get(0)); 
                if (++i % batchSize == 0) fullTextSession.clear();
            }
            
            transaction.commit();
        }

        finally {
            fullTextSession.close();
        }

        long end = System.currentTimeMillis();
        System.out.println("Completed "+entity.getEntityName()+" in "+(end - start)+" ms");
    }
}
