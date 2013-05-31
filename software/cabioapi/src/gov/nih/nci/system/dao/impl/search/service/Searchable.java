/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.dao.impl.search.service;

import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.impl.search.FreestyleLMException;

import java.util.List;

/**
 * Interface that defines the search functionality.
 * 
 * @author Shaziya Muhsin
 */
public interface Searchable {
    
    public List query(String searchString) throws FreestyleLMException;

    public List query(String searchString, Sort sort) throws FreestyleLMException;
    
}
