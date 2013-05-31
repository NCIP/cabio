/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.grididloader;

import java.util.Properties;

import javax.sql.DataSource;

import net.handle.server.IDSvcInterface;
import net.handle.server.IDSvcInterfaceFactory;

/**
 * This factory makes various kinds of Handle Interfaces, based on system 
 * properties.
 */
/**
 * @author caBIO Team
 * @version 1.0
 */
public class HandleInterfaceFactory {

    public enum HandleInterfaceType { CLASSIC }
    
    private final DataSource dataSource; 
    private final String idSvcRepository;
    private final HandleInterfaceType systemType;
    
    public HandleInterfaceFactory(Properties props, DataSource dataSource) {
        this.dataSource = dataSource;
        this.idSvcRepository = props.getProperty("idsvr.repository");
        
        this.systemType = HandleInterfaceType.CLASSIC;
        System.out.println("Handle Interface: "+systemType);
    }

    /**
     * Returns the configured system type.
     */
    public HandleInterfaceType getSystemType() {
        return systemType;
    }

    /**
     * Returns the system configured handle interface.
     * @return a handle interface
     * @throws Exception
     */
    public IDSvcInterface getHandleInterface() throws Exception {
        return getHandleInterface(systemType);
    }

    /**
     * Returns either a "lite" interface or the true interface, depending 
     * on the parameter.
     * @return a handle interface
     * @throws Exception
     */
    public IDSvcInterface getHandleInterface(HandleInterfaceType type) throws Exception {
        switch (type) {
        case CLASSIC: return IDSvcInterfaceFactory.getInterface(idSvcRepository);
        }
        throw new IllegalArgumentException("Type is not supported");
    }
}
