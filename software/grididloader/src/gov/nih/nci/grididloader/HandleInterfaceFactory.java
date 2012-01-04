/*
 *  The caBIO Software License, Version 1.0
 * 
 *  Copyright 2006 SAIC. This software was developed in conjunction with the 
 *  National Cancer Institute, and so to the extent government employees are 
 *  co-authors, any rights in such works shall be subject to Title 17 of the 
 *  United States Code, section 105.
 *
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted rovided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice, 
 *  this list of conditions and the disclaimer of Article 3, below.  
 *  Redistributions in binary form must reproduce the above copyright notice, 
 *  this list of conditions and the following disclaimer in the documentation 
 *  and/or other materials provided with the distribution.
 *
 *  2.  The end-user documentation included with the redistribution, if any, 
 *  must include the following acknowledgment:
 *
 *  "This product includes software developed by the SAIC and the National 
 *  Cancer Institute."
 *
 *  If no such end-user documentation is to be included, this acknowledgment 
 *  shall appear in the software itself, wherever such third-party 
 *  acknowledgments normally appear.
 *
 *  3. The names "The National Cancer Institute", "NCI" and "SAIC" must not be 
 *  used to endorse or promote products derived from this software.
 * 
 *  4. This license does not authorize the incorporation of this software into 
 *  any proprietary programs.  This license does not authorize the recipient to 
 *  use any trademarks owned by either NCI or SAIC-Frederick.
 *
 *  5. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED 
 *  WARRANTIES, (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED.  IN NO 
 *  EVENT SHALL THE NATIONAL CANCER INSTITUTE, SAIC, OR THEIR AFFILIATES BE 
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 *  POSSIBILITY OF SUCH DAMAGE.
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
