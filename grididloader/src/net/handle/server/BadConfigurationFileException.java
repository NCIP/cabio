/**********************************************************************\
  COPYRIGHT 2006 Corporation for National Research Initiatives (CNRI);
                        All rights reserved.

             This software is made available subject to the
         Handle System Public License, which may be obtained at
         http://hdl.handle.net/4263537/5009 or hdl:4263537/5009
\**********************************************************************/

package net.handle.server;

/**
 * Signals that the configuration file config.dct was not found in the
 * specified Handle repository directory.
 */
public class BadConfigurationFileException extends Exception {
	/**
	 * Constructs a new exception with the specified cause
	 *
	 * @param cause
	 * 	the cause for the exception.
	 */
	public BadConfigurationFileException(Throwable cause) { super(cause); }
}

