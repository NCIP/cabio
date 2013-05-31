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
import java.net.URI;
import java.net.URISyntaxException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Enumeration;
import net.handle.hdllib.*;
import net.handle.util.StreamTable;

/**
 * A class providing a Handle Server Repository backend for registering
 * resources into a global naming service. This repository can be used by a
 * handle server; however a handle server is not created with this class. It
 * also assumes that all handles will be stored locally on this repository, so
 * any attempts to create or access a resource stored on another server will
 * return a {@code null}.
 * 
 * @see <a href="http://handle.net/documentation.html">Handle System
 *      Documentation</a>
 */
public class HandleRepositoryIDInterface implements IDSvcInterface {

	private static final String SERVER_PREFIX = "server_prefix";

	private static final String MIN_HASH_LENGTH = "min_hash_length";

	private HandleStorage storage;

	private boolean autoCommit = true;

	private PreparedStatement createHandleStatement = null;

	private String CREATE_HDL_STMT = "insert into handles ( prefix, handle, idx, type, data, ttl_type, ttl, "
			+ "timestamp, refs, admin_read, admin_write, pub_read, pub_write) values "
			+ "( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	private MessageDigest md = MessageDigest.getInstance("SHA-1");

	private String rootNA = "0.NA";

	private String serverNA;

	public int numCollisions = 0;

	public int minHashLength;
	
	private String subprefix = null;

	/**
	 * Initializes the interface to the Handle Server repository on the local
	 * machine.
	 * 
	 * <p>
	 * The following properties must be defined in the <i>config.dct</i> file:
	 * <ul>
	 * <li>{@code server_prefix}: the handle prefix for the local server</li>
	 * <li>{@code min_hash_length}: the minimum size hash length for
	 * constructing URIs (between 1 and 32)</li>
	 * </ul>
	 * </p>
	 * 
	 * @param handleRepositoryDir
	 *            a {@link String} containing the absolute path to the Handle
	 *            Repository
	 * @throws Exception
	 *             If initialization of the repository fails. Future versions of
	 *             this code may throw {@link HandleException} instead, for more
	 *             automated error-handling.
	 */
	public HandleRepositoryIDInterface(String handleRepositoryDir) throws Exception {
		File configDir = new File(handleRepositoryDir);
		StreamTable configTable = new StreamTable();
		configTable.readFromFile(new File(configDir, HSG.CONFIG_FILE_NAME));
		serverNA = configTable.getStr(SERVER_PREFIX);
		minHashLength = configTable.getInt(MIN_HASH_LENGTH, 32);
		storage = HandleStorageFactory.getStorage(configDir, (StreamTable) configTable.get(HSG.SERVER_CONFIG), true);
    }

	/**
	 * {@inheritDoc}
	 */
	public URI createOrGetGlobalID(ResourceIdInfo ID) {
		try {
			if (subprefix == null) {
				// look up context handle, create if it doesn't exist
				HandleName fullContextHandle = nextHandleName(serverNA, ID.resourceContext.toString());
				if (fullContextHandle.needToCreate) {
					HandleValue contextURI = new HandleValue(1, Util.encodeString("URI"), Util
							.encodeString(ID.resourceContext.toString()));
					AdminRecord adminRec = new AdminRecord(Util.encodeString(rootNA + "/" + serverNA), 200, true, true,
							false, false, true, true, true, true, true, true, true, true);
					HandleValue adminVal = new HandleValue(100, Util.encodeString("HS_ADMIN"), Encoder
							.encodeAdminRecord(adminRec));
					if (autoCommit) {
						storage.createHandle(Util.encodeString(fullContextHandle.name),
								new HandleValue[] { contextURI, adminVal });
					} else {
						createHandle(Util.encodeString(fullContextHandle.name), new HandleValue[] { contextURI, adminVal });
					}
				}
	
				// make sure we register the sub-prefix with the server
				// (might not be necessary if sub-prefix delegation gets
				// implemented)
				// convert prefix/subprefix handle into prefix.subprefix
				subprefix = fullContextHandle.name.replace('/', '.');
				// setHaveNA is transaction-safe, no need to switch
				storage.setHaveNA(Util.encodeString(rootNA + "/" + subprefix), true);
			}

			// create handle for resourceIdentification
			HandleName fullAttributeHandle = nextHandleName(subprefix, ID.resourceIdentification);
			if (fullAttributeHandle.needToCreate) {		
				HandleValue contextURI = new HandleValue(1, Util.encodeString("Attribute"), Util
						.encodeString(ID.resourceIdentification));
				AdminRecord adminRec = new AdminRecord(Util.encodeString(rootNA + "/" + serverNA), 200, true, true,
						false, false, true, true, true, true, true, true, true, true);
				HandleValue adminVal = new HandleValue(100, Util.encodeString("HS_ADMIN"), Encoder
						.encodeAdminRecord(adminRec));
				if (autoCommit) {
					storage.createHandle(Util.encodeString(fullAttributeHandle.name), new HandleValue[] { contextURI,
							adminVal });
				} else {
					createHandle(Util.encodeString(fullAttributeHandle.name), new HandleValue[] { contextURI, adminVal });
				}
			}
			try {
				return new URI("hdl://" + fullAttributeHandle.name);
			} catch (URISyntaxException e) {
				throw new RuntimeException(e);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public ResourceIdInfo getBigIDInfo(URI identifier) {
		if ((identifier == null) || (identifier.getAuthority() == null) || (identifier.getPath() == null)) {
			System.out.println("invalid URI format");
			return null;
		}
		try {
			// context = lookup handle on authority, defined by:
			// separating the last part of the sub-prefix (replacing the last
			// '.' with a '/')
			String authority = identifier.getAuthority();
			int subprefix = authority.lastIndexOf('.');
			String contextHandle = authority.substring(0, subprefix) + "/" + authority.substring(subprefix + 1);
			// get the URI value from index 1
			HandleValue[] hv = getHandleFromStorage(contextHandle, new int[] { 1 }, null);
			if (hv == null) {
				System.out.println("error:  identifier context not found");
				return null;
			}
			if (hv.length != 1) {
				System.out.println("Error, handle does not have correct format");
				return null;
			}
			URI resourceContext = new URI(hv[0].getDataAsString());

			// resourceIdentification = lookup handle on authority + path
			String attributeHandle = authority + identifier.getPath();
			// get the String value from index 1
			hv = getHandleFromStorage(attributeHandle, new int[] { 1 }, null);
			if (hv == null) {
				System.out.println("error:  identifier not found");
				return null;
			}
			if (hv.length != 1) {
				System.out.println("Error, handle does not have correct format");
				return null;
			}
			String resourceIdentification = hv[0].getDataAsString();
			return new ResourceIdInfo(resourceContext, resourceIdentification);
		} catch (URISyntaxException e) {
			System.out.println("Error, handle does not have valid URI, message = " + e.getMessage());
			return null;
		} catch (HandleException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void removeGlobalID(ResourceIdInfo ID) {
		try {
			HandleName fullContextHandle = nextHandleName(serverNA, ID.resourceContext.toString());
			String subprefix = fullContextHandle.name.replace('/', '.');
			HandleName fullAttributeHandle = nextHandleName(subprefix, ID.resourceIdentification);
			removeGlobalID(new URI("hdl://" + fullAttributeHandle.name));
			// for the exceptions, probably just do nothing.
		} catch (HashCollisionException e) {
			e.printStackTrace();
		} catch (HandleException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void removeGlobalID(URI ID) {
		String handleName = ID.getAuthority() + ID.getPath();
		try {
			// System.out.println("removing " + new
			// String(Util.encodeString(handleName)));
			// deleteHandle is transaction-safe, no need to switch
			storage.deleteHandle(Util.encodeString(handleName));
			// for the exceptions, probably just do nothing.
		} catch (HandleException e) {
			e.printStackTrace();
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void removeContext(URI context) {
		try {
			HandleName fullContextHandle = nextHandleName(serverNA, context.toString());
			// if it actually exists...
			if (!fullContextHandle.needToCreate) {
				String subprefix = fullContextHandle.name.replace('/', '.');
				Enumeration hdlsToDelete = storage.getHandlesForNA(Util.encodeString("0.NA/" + subprefix));
				while (hdlsToDelete.hasMoreElements()) {
					byte[] nextHandle = (byte[]) hdlsToDelete.nextElement();
					// System.out.println("deleting handle " +
					// Util.decodeString(nextHandle));
					try {
						storage.deleteHandle(nextHandle);
						// for the exceptions, probably just do nothing.
					} catch (HandleException e) {
						e.printStackTrace();
					}
				}
				// System.out.println("deleting context handle " +
				// fullContextHandle);
				storage.deleteHandle(Util.encodeString(fullContextHandle.name));
			}
			// for the exceptions, probably just do nothing.
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Begins an extended database transaction, rather than using the default
	 * behavior using the Storage API. Finish the transaction by calling
	 * {@link #commitTransaction}. This may improve the running time for large
	 * amounts of changes. This method can only be called if the underlying
	 * storage is a database management system-- for any other implementation,
	 * this method has no effect, other than displaying a message to standard
	 * error output.
	 * 
	 * @throws HandleException
	 *             if any error in the connection occurs.
	 */
	public void beginTransaction() throws HandleException {
		try {
			SQLHandleStorage sql = (SQLHandleStorage) storage;
			Connection conn = sql.getConnection();
			conn.setAutoCommit(false);
			autoCommit = false;
			createHandleStatement = conn.prepareStatement(CREATE_HDL_STMT);
		} catch (ClassCastException e) {
			System.err.println("Error, storage type " + storage.getClass().getName()
					+ " cannot be used with transaction processing");
		} catch (SQLException e) {
			throw new HandleException(HandleException.INTERNAL_ERROR, "Error creating handle: " + e);
		}
	}

	/**
	 * Ends an extended database transaction, rather than using the default
	 * behavior using the Storage API. The transaction should first be started
	 * by calling {@link #beginTransaction}. This may improve the running time
	 * for large amounts of changes. This method can only be called if the
	 * underlying storage is a database management system-- for any other
	 * implementation, this method has no effect, other than displaying a
	 * message to standard error output.
	 * 
	 * @throws HandleException
	 *             if any error in the connection occurs.
	 */
	public void commitTransaction() throws HandleException {
		try {
			SQLHandleStorage sql = (SQLHandleStorage) storage;
			Connection conn = sql.getConnection();
			conn.commit();
			conn.setAutoCommit(true);
			autoCommit = true;
		} catch (ClassCastException e) {
			System.err.println("Error, storage type " + storage.getClass().getName()
					+ " cannot be used with transaction processing");
		} catch (SQLException e) {
			throw new HandleException(HandleException.INTERNAL_ERROR, "Error creating handle: " + e);
		}
	}


	private HandleName nextHandleName(String prefix, String data)
			throws /* InvalidHandleFormatException, */HashCollisionException, HandleException {
		HandleName handleName = new HandleName();

		md.reset();
		md.update(data.getBytes());
		byte[] dataDigest = md.digest();
		String longEncoded = Base32.encode(dataDigest);
		String hashCollision = "";
		StringBuffer buffer = new StringBuffer();
		buffer.append(prefix);
		buffer.append("/");
		buffer.append(longEncoded.substring(0, minHashLength - 1));
		for (int i = minHashLength; i <= longEncoded.length(); i++) {
			buffer.append(longEncoded.charAt(i-1));
			// expecting to find the context URI or resource data at index 1
			HandleValue[] hv = getHandleFromStorage(buffer.toString(), new int[] { 1 }, null);
			// if we found it, check to see if we've already created this handle
			// or if the hash bucket is already taken
			if (hv != null) {
				// if it actually has info at index 1...
				if (hv.length == 1) {
					hashCollision = hv[0].getDataAsString();
					// if it's not really a hash collision...
					if (hashCollision.equals(data)) {
						handleName.name = buffer.toString();
						handleName.needToCreate = false;
						return handleName;
					} else {
						numCollisions++;
                        System.out.println("Number of handle collisions: " + numCollisions);
					}
				}
				// otherwise, go on to the next iteration
				// if we haven't found the bucket, we can claim it now
			} else {
				handleName.name = buffer.toString();
				handleName.needToCreate = true;
				return handleName;
			}
		}
		// we shouldn't ever get this far, otherwise we've found a SHA-1
		// collision
		throw new HashCollisionException("Error, hash collision between " + hashCollision + " and " + data);
	}

	private HandleValue[] getHandleFromStorage(String handle, int indexList[], byte typeList[][])
			throws HandleException {
		// getRawHandleValues is transaction-safe, no need to switch
		byte[][] resp = storage.getRawHandleValues(Util.encodeString(handle), indexList, typeList);
		if (resp == null) {
			return null;
		}
		HandleValue[] hv = new HandleValue[resp.length];
		for (int i = 0; i < resp.length; i++) {
			hv[i] = new HandleValue();
			Encoder.decodeHandleValue(resp[i], 0, hv[i]);
		}
		return hv;
	}

	private void createHandle(byte handle[], HandleValue values[]) throws /* HandleException, */SQLException {
		// no need to check if the handle already exists, we already did that in
		// nextHandleName
		for (int i = 0; i < values.length; i++) {
			// handle, index, type, data, ttl_type, ttl, timestamp, references,
			// admin_read, admin_write, pub_read, pub_write

			HandleValue val = values[i];
			createHandleStatement.setBytes(1, Util.getNAPart(handle));
			createHandleStatement.setBytes(2, Util.getIDPart(handle));
			createHandleStatement.setInt(3, val.getIndex());
			createHandleStatement.setBytes(4, val.getType());
			createHandleStatement.setBytes(5, val.getData());
			createHandleStatement.setByte(6, val.getTTLType());
			createHandleStatement.setInt(7, val.getTTL());
			createHandleStatement.setLong(8, val.getTimestamp());
			// if we really need this part later, we'll need to fix the
			// undefined symbols. For right now...
			createHandleStatement.setString(9, "");
			/*
			 * StringBuffer sb = new StringBuffer(); ValueReference refs[] =
			 * val.getReferences(); for(int rv=0; refs!=null && rv <
			 * refs.length; rv++) { if(rv!=0) sb.append('\t');
			 * sb.append(refs[rv].index); sb.append(':');
			 * sb.append(StringUtils.encode(Util.decodeString(refs[rv].handle))); }
			 * createHandleStatement.setString(9, encodeString(sb.toString()));
			 */

			createHandleStatement.setBoolean(10, val.getAdminCanRead());
			createHandleStatement.setBoolean(11, val.getAdminCanWrite());
			createHandleStatement.setBoolean(12, val.getAnyoneCanRead());
			createHandleStatement.setBoolean(13, val.getAnyoneCanWrite());

			createHandleStatement.executeUpdate();
		}
	}
    
   public void shutdown() {
       storage.shutdown();
   }

	private class HandleName {
		String name = "";
		boolean needToCreate = false;
	}
}
