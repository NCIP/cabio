/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

/**********************************************************************\
  COPYRIGHT 2006 Corporation for National Research Initiatives (CNRI);
                        All rights reserved.

             This software is made available subject to the
         Handle System Public License, which may be obtained at
         http://hdl.handle.net/4263537/5009 or hdl:4263537/5009
\**********************************************************************/

package net.handle.server;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import net.handle.hdllib.HSG;
import net.handle.util.StreamTable;
import net.handle.util.StringEncodingException;

/**
 * Abstract class that uses a static method to construct an
 * IDSvcInterface instance.
 */
public abstract class IDSvcInterfaceFactory {

private static final String SUBCLASS_NAME = "IDSvcInterface_class";

/**
 * Create an IDSvcInterface instance using the server configuration from
 * the given Handle Server repository directory.  The configuration file
 * in this directory (<i>config.dct</i>) must contain an entry
 * {@code IDSvcInterface_class} with the name of the subclass to be
 * instantiated.  For example,
 * <blockquote>{@code "IDSvcInterface_class" = "net.handle.server.HandleRepositoryIDInterface"}</blockquote>
 * Other required properties in this file are defined in the specific
 * subclass definitions.
 *
 * @param handleRepositoryDir
 * 	The absolute path to an installed Handle Server repository.
 * @return
 * 	An instance of an IDSvcInterface to the repository.
 * @throws BadConfigurationFileException
 * 	If the repository configuration file does not exist or is corrupted.
 * @throws InvalidSubclassException
 * 	If the specified subclass name cannot be used.
 */
public static IDSvcInterface getInterface(String handleRepositoryDir)
	throws BadConfigurationFileException,InvalidSubclassException
{
	try {
		File configDir = new File(handleRepositoryDir);
		StreamTable configTable = new StreamTable();
		configTable.readFromFile(new File(configDir, HSG.CONFIG_FILE_NAME));
		String subclassName = configTable.getStr(SUBCLASS_NAME);
		Class subclass = Class.forName(subclassName);
		Constructor constructor = subclass.getConstructor(
				new Class[] { Class.forName("java.lang.String") });
		return (IDSvcInterface)constructor.newInstance(
				new Object[] { handleRepositoryDir });
	} catch (StringEncodingException e) {
		throw new BadConfigurationFileException(e);
	} catch (IOException e) {
		throw new BadConfigurationFileException(e);
	} catch (ClassNotFoundException e) {
		throw new InvalidSubclassException(e);
	} catch (NoSuchMethodException e) {
		throw new InvalidSubclassException(e);
	} catch (InstantiationException e) {
		throw new InvalidSubclassException(e);
	} catch (IllegalAccessException e) {
		throw new InvalidSubclassException(e);
	} catch (InvocationTargetException e) {
		throw new InvalidSubclassException(e);
	}
}

/**
 * Sole constructor.  Declared as private because all methods are static.
 */
private IDSvcInterfaceFactory() { }

}

