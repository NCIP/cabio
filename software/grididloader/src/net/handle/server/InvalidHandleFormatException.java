/**********************************************************************\
  COPYRIGHT 2006 Corporation for National Research Initiatives (CNRI);
                        All rights reserved.

             This software is made available subject to the
         Handle System Public License, which may be obtained at
         http://hdl.handle.net/4263537/5009 or hdl:4263537/5009
\**********************************************************************/

package net.handle.server;

/**
 * Signals that a resource has been registered, but that the storage format
 * was discovered to be invalid.  This could indicate corruption of the
 * repository.
 */
public class InvalidHandleFormatException extends Exception {
	/**
	 * Constructs a new exception with no detail message.
	 */
	public InvalidHandleFormatException() { super(); }
	/**
	 * Constructs a new exception with the specified detail message.
	 * 
	 * @param message
	 * 	the detail message, which can be retrieved by the
	 * 	{@link Throwable#getMessage()} method.
	 */
	public InvalidHandleFormatException(String message) { super(message); }
}

