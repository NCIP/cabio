package gov.nih.nci.system.dao.impl.search;

import gov.nih.nci.system.dao.QueryException;

/*
 * Created on Aug 31, 2007
 * ShaziyaMuhsin
 * 
 */
public class FreestyleLMException extends Exception {
    private static final long serialVersionUID = 3L;
    /**
     * Default constructor. Constructs the (@link QueryException) object 
     */
    public FreestyleLMException() {
        super();        
    }
        /**
         * Constructs the {@link QueryException} object with the passed message 
         * @param message The message which is describes the exception caused
         */
        public FreestyleLMException(String message)
        {
            super(message);
        }
        /**
         * Constructs the {@link QueryException} object with the passed message.
         * It also stores the actual exception that occured 
         * @param message The message which describes the exception
         * @param cause The actual exception that occured
         */
        public FreestyleLMException(String message, Throwable cause)
        {
            super(message, cause);
        }
        /**
         * Constructs the {@link QueryException} object storing the actual 
         * exception that occured 
         * @param cause The actual exception that occured
         */
        public FreestyleLMException(Throwable cause)
        {
            super(cause);
        }
        
        public FreestyleLMException(String message, Exception ex){
            super(message, ex);
        }

}
