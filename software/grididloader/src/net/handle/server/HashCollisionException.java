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
 * Signals the (unlikely) event that a cryptographic digest collision
 * was found.
 */
class HashCollisionException extends Exception {
	/**
	 * Constructs a new exception with the specified detail message.
	 * 
	 * @param message
	 * 	the detail message, which can be retrieved by the
	 * 	{@link Throwable#getMessage()} method.
	 */
	public HashCollisionException(String message) { super(message); }
}

