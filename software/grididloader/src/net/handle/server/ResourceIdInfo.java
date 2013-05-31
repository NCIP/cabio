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

import java.net.URI;

/**
 * ResourceIdInfo is a wrapper class to communicate the
 * application's way of uniquely identifying a resource.
 *
 * <p>The resourceContext is a URI that identifies the type/kind
 * of resource and indicates that the identifiers of all
 * resources with the same context should be managed together.
 * Internally this context will be mapped to a NA-prefix.</p>
 *
 * <p>The resourceIdentification is a String that can be used by
 * the application to store the uniquely identifiable information
 * for that resource, like primary key values, local unique ID,
 * SQL-select statement or SQL WHERE-clause, XPATH query
 * statement, etc.
 * The application is free to use any format to encode the
 * identification info, but it should ensure that the exact
 * same info is presented for the same resource such that
 * the identifier runtime can assign the same identifier
 * to the same resource.
 * When the application supplies this identification-info
 * at identifier creation time, then when presented with
 * the identifier later, identifier-runtime will be able
 * to return the exact same identification-info string.
 * This allows the application to find the resource using
 * the local identification mechanisms.</p>
 *
 */
public class ResourceIdInfo {
	/**
	 * The context under which this {@link ResourceIdInfo} object
	 * can be uniquely identified.
	 */
	public URI resourceContext = null;
	/**
	 * The identifier for this {@link ResourceIdInfo} object under
	 * the context of {@code resourceContext}.  The formatting and
	 * content are undefined here and should be interpreted by the
	 * calling application.
	 */
	public String resourceIdentification = null;
	/**
	 * Formats this {@link ResourceIdInfo} object in a
	 * user-friendly {@link String} format.  This should not be
	 * used as an identifier for the resource; the
	 * {@code resourceContext} and {@code resourceIdentification}
	 * variables should be used for this purpose.
	 */
	public String toString() {
		return "{" + resourceContext + "}" + resourceIdentification;
	}
	/**
	 * @param context is a URI that identifies the type/kind
	 * of resource.
	 * @param identification is a string that can be used by
	 * the application to store the uniquely identifyable
	 * information for that resource.
	 */
	public ResourceIdInfo(URI context, String identification){
		resourceContext = context;
		resourceIdentification = identification;
	}


	/**
	 * @param context is a URI that identifies the type/kind
	 * of resource.
	 * By not supplying any resource-identification info, the
	 * application indicates that it is able to manage the
	 * mapping of the identifier to the resource without
	 * that information.
	 */
	public ResourceIdInfo(URI context){
		resourceContext = context;
	}

}

