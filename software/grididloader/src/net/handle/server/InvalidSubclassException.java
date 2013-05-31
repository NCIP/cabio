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

/**
 * Signals that the class specified in the configuration file is invalid.
 */
public class InvalidSubclassException extends Exception {
	/**
	 * Constructs a new exception with the specified cause
	 *
	 * @param cause
	 * 	the cause for the exception.
	 */
	public InvalidSubclassException(Throwable cause) { super(cause); }
}

