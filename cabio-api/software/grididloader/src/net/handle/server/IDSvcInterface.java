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
 * An interface for registering global identifiers and resources under a
 * unique {@link URI} identifier.
 */
public interface IDSvcInterface {

/**
 * Registers a resource in the repository.  If the resource has already
 * been registered, this method simply returns the URI that was created
 * for it previously.  The returned URI may be opaque;
 * that is, there may be no obvious correlation between the URI and the
 * context or the identification string.  However, the URI authority will
 * uniquely identify a context.
 *
 * @param ID
 * 	the resource to register
 * @return
 * 	an identifier for the resource if it was registered successfully;
 * 	{@code null} otherwise.
 */
public URI createOrGetGlobalID(ResourceIdInfo ID);

/**
 * Retrieves a resource identifier from the repository, in the same
 * format as it was stored when registered with {@link #createOrGetGlobalID}.
 *
 * @param identifier
 * 	the URI of the resource to retrieve
 * @return
 * 	the stored information about the given resource if found;
 * 	{@code null} otherwise, or if the formatting of the URI is
 * 	invalid.
 */
public ResourceIdInfo getBigIDInfo(URI identifier);

/**
 * Removes a resource identifier from the repository.  If the identifier
 * does not exist, this method does nothing.
 *
 * @param ID
 *	the context and identifier to remove
 */
public void removeGlobalID(ResourceIdInfo ID);

/**
 * Removes a resource identifier from the repository.  If the identifier
 * does not exist, this method does nothing.
 *
 * @param ID
 *	the Global identifier of the resource identifier to remove
 */
public void removeGlobalID(URI ID);

/**
 * Removes a context and its associated identifiers from the repository.
 * If the context does not exist, this method does nothing.
 *
 * @param context
 * 	the URI of the context to remove
 */
public void removeContext(URI context);

}

