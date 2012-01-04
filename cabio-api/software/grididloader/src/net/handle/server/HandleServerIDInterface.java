/**********************************************************************\
 COPYRIGHT 2006 Corporation for National Research Initiatives (CNRI);
 All rights reserved.

 This software is made available subject to the
 Handle System Public License, which may be obtained at
 http://hdl.handle.net/4263537/5009 or hdl:4263537/5009
 \**********************************************************************/

package net.handle.server;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.MessageDigest;
import net.handle.hdllib.*;
import net.handle.util.StreamTable;

/**
 * A class providing an API into a Handle Server backend for registering
 * resources into a global naming service. A Handle Server daemon is also
 * started on ports TCP/UDP 2641 and TCP 8000.
 * 
 * <p>
 * The {@link ResponseMessageCallback} interface, along with the
 * {@code handleResponse} method provided by the interface, is used internally
 * by the Handle System.
 * </p>
 * 
 * @see <a href="http://handle.net/documentation.html">Handle System
 *      Documentation</a>
 */
public class HandleServerIDInterface implements IDSvcInterface, ResponseMessageCallback {

	private static final String SERVER_PREFIX = "server_prefix";

	private static final String MIN_HASH_LENGTH = "min_hash_length";

	private static final String AUTH_HANDLE = "auth_handle";

	private static final String AUTH_INDEX = "auth_index";

	private static final String PRIVKEY_FILENAME = "privKey_filename";

	private static final String PRIVKEY_PASSPHRASE = "privKey_passphrase";

	private Main main;

	private AbstractServer server;

	private AbstractResponse resp;

	private MessageDigest md = MessageDigest.getInstance("SHA-1");

	private String rootNA = "0.NA";

	private String serverNA;

	private int minHashLength;

	private AuthenticationInfo authInfo;

	private String authHandle;

	private int authIndex;

	private String privKeyFilename;

	private String privKeyPassword;

	/**
	 * Initializes the interface to the Handle Server. During initialization,
	 * the Handle backend will prompt the user for the repository passphrase on
	 * standard input. The constructor also starts three listener threads for
	 * the Handle protocol, one each on TCP/UDP port 2641 and TCP port 8000.
	 * 
	 * <p>
	 * Because the Handle Server also requires the administrator to create a
	 * public/private key pair for authorization tasks like creating handles,
	 * this constructor uses this key pair for registering the resources. The
	 * key pair must already have been created during the Handle Server setup.
	 * </p>
	 * 
	 * <p>
	 * The following properties must be defined in the <i>config.dct</i> file:
	 * <ul>
	 * <li>{@code server_prefix}: the handle prefix for the local server</li>
	 * <li>{@code min_hash_length}: the minimum size hash length for
	 * constructing URIs (between 1 and 32)</li>
	 * <li>{@code auth_handle}: the name of a handle containing a public key
	 * with administrator privileges</li>
	 * <li>{@code auth_index}: the index of the public key within the handle
	 * (usually 300)</li>
	 * <li>{@code privKey_filename}: the full path to the corresponding
	 * private key</li>
	 * <li>{@code privKey_passphrase}: the passphrase protecting the private
	 * key</li>
	 * </ul>
	 * </p>
	 * 
	 * @param handleRepositoryDir
	 *            a {@link String} containing the absolute path to the Handle
	 *            Server repository
	 * @throws Exception
	 *             If initialization of the repository fails. Future versions of
	 *             this code may throw {@link HandleException} instead, for more
	 *             automated error-handling.
	 */
	public HandleServerIDInterface(String handleRepositoryDir) throws Exception {
		File configDir = new File(handleRepositoryDir);
		StreamTable configTable = new StreamTable();
		configTable.readFromFile(new File(configDir, HSG.CONFIG_FILE_NAME));
		main = new Main(configDir, configTable);
		main.initialize();
		main.start(); // this starts up the other listener threads-- TCP/UDP
						// 2641 and TCP 8000
		serverNA = configTable.getStr(SERVER_PREFIX);
		minHashLength = configTable.getInt(MIN_HASH_LENGTH, 1);
		authHandle = configTable.getStr(AUTH_HANDLE);
		authIndex = configTable.getInt(AUTH_INDEX, 300);
		privKeyFilename = configTable.getStr(PRIVKEY_FILENAME);
		privKeyPassword = configTable.getStr(PRIVKEY_PASSPHRASE);
		server = main.getServer();

		// set up authentication info
		File keyFile = new File(privKeyFilename);
		FileInputStream fis = new FileInputStream(keyFile);
		byte[] rawKeyData = new byte[(int) keyFile.length()];
		fis.read(rawKeyData);
		fis.close();
		byte[] keyData = Util.decrypt(rawKeyData, Util.encodeString(privKeyPassword));
		authInfo = new PublicKeyAuthenticationInfo(Util.encodeString(authHandle), authIndex, Util
				.getPrivateKeyFromBytes(keyData, 0));
	}

	/**
	 * {@inheritDoc}
	 */
	public URI createOrGetGlobalID(ResourceIdInfo ID) {
		try {
			// look up context handle, create if it doesn't exist
			HandleName fullContextHandle = nextHandleName(serverNA, ID.resourceContext.toString());
			if (fullContextHandle.needToCreate) {
				HandleValue contextURI = new HandleValue(1, Util.encodeString("URI"), Util
						.encodeString(ID.resourceContext.toString()));
				AdminRecord adminRec = new AdminRecord(Util.encodeString(authHandle), authIndex, true, true, false,
						false, true, true, true, true, true, true, true, true);
				HandleValue adminVal = new HandleValue(100, Util.encodeString("HS_ADMIN"), Encoder
						.encodeAdminRecord(adminRec));
				CreateHandleRequest createContext = new CreateHandleRequest(Util.encodeString(fullContextHandle.name),
						new HandleValue[] { contextURI, adminVal }, null);
				server.processRequest(createContext, this);
				if (resp instanceof ChallengeResponse) {
					handleChallenge((ChallengeResponse) resp, createContext);
				}
				// System.out.println("response (" + resp.getClass().getName() +
				// "): " + resp);
			}

			// make sure we register the sub-prefix with the server
			// (might not be necessary if sub-prefix delegation gets
			// implemented)
			// convert prefix/subprefix handle into prefix.subprefix
			String subprefix = fullContextHandle.name.replace('/', '.');
			GenericRequest homeNAReq = new GenericRequest(Util.encodeString(rootNA + "/" + subprefix),
					AbstractMessage.OC_HOME_NA, null);
			server.processRequest(homeNAReq, this);
			if (resp instanceof ChallengeResponse) {
				handleChallenge((ChallengeResponse) resp, homeNAReq);
			}
			if (resp instanceof ErrorResponse) {
				System.out.println("Error creating context sub-prefix:  " + resp);
				return null;
			}
			// System.out.println("response for homeNAReq: (" +
			// resp.getClass().getName() + ") " + resp);

			// create handle for resourceIdentification
			HandleName fullAttributeHandle = nextHandleName(subprefix, ID.resourceIdentification);
			if (fullAttributeHandle.needToCreate) {
				HandleValue contextURI = new HandleValue(1, Util.encodeString("Attribute"), Util
						.encodeString(ID.resourceIdentification));
				AdminRecord adminRec = new AdminRecord(Util.encodeString(authHandle), authIndex, true, true, false,
						false, true, true, true, true, true, true, true, true);
				HandleValue adminVal = new HandleValue(100, Util.encodeString("HS_ADMIN"), Encoder
						.encodeAdminRecord(adminRec));
				CreateHandleRequest createContext = new CreateHandleRequest(Util.encodeString(fullAttributeHandle.name),
						new HandleValue[] { contextURI, adminVal }, null);
				server.processRequest(createContext, this);
				if (resp instanceof ChallengeResponse) {
					handleChallenge((ChallengeResponse) resp, createContext);
				}
				if (resp instanceof ErrorResponse) {
					System.out.println("Error response received from server:  " + resp);
					return null;
				}
				// System.out.println("response (" + resp.getClass().getName() +
				// "): " + resp);
			} else {
				System.out.println("warning:  attribute already created, no action performed");
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
		/*
		 * System.out.println("\tauthority = " + identifier.getAuthority());
		 * System.out.println("\tfragment = " + identifier.getFragment());
		 * System.out.println("\thost = " + identifier.getHost());
		 * System.out.println("\tpath = " + identifier.getPath());
		 * System.out.println("\tport = " + identifier.getPort());
		 * System.out.println("\tquery = " + identifier.getQuery());
		 * System.out.println("\tscheme = " + identifier.getScheme());
		 * System.out.println("\tscheme-specific part = " +
		 * identifier.getSchemeSpecificPart()); System.out.println("\tuser info = " +
		 * identifier.getUserInfo());
		 */
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
			// System.out.println("contextHandle = " + contextHandle);
			// get the URI value from index 1
			ResolutionRequest lookup = new ResolutionRequest(Util.encodeString(contextHandle), null, new int[] { 1 },
					null);
			server.processRequest(lookup, this);
			if (resp instanceof ErrorResponse) {
				System.out.println("error:  identifier context not found");
				return null;
			}
			HandleValue[] hv = ((ResolutionResponse) resp).getHandleValues();
			if (hv.length != 1) {
				System.out.println("Error, handle does not have correct format");
				return null;
			}
			URI resourceContext = new URI(hv[0].getDataAsString());

			// resourceIdentification = lookup handle on authority + path
			String attributeHandle = authority + identifier.getPath();
			// System.out.println("attributeHandle = " + attributeHandle);
			// get the String value from index 1
			lookup = new ResolutionRequest(Util.encodeString(attributeHandle), null, new int[] { 1 }, null);
			server.processRequest(lookup, this);
			if (resp instanceof ErrorResponse) {
				System.out.println("error:  identifier context not found");
				return null;
			}
			hv = ((ResolutionResponse) resp).getHandleValues();
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
	 * {@inheritDoc} <b>Warning: untested</b>
	 */
	public void removeGlobalID(ResourceIdInfo ID) {
		try {
			HandleName fullContextHandle = nextHandleName(serverNA, ID.resourceContext.toString());
			String subprefix = fullContextHandle.name.replace('/', '.');
			HandleName fullAttributeHandle = nextHandleName(subprefix, ID.resourceIdentification);
			removeGlobalID(new URI("hdl://" + fullAttributeHandle.name));
			// for the exceptions, probably just do nothing.
		} catch (HashCollisionException e) {
		} catch (HandleException e) {
		} catch (URISyntaxException e) {
		}
	}

	/**
	 * {@inheritDoc} <b>Warning: untested</b>
	 */
	public void removeGlobalID(URI ID) {
		String handleName = ID.getAuthority() + ID.getPath();
		DeleteHandleRequest delHandle = new DeleteHandleRequest(Util.encodeString(handleName), null);
		try {
			server.processRequest(delHandle, this);
			if (resp instanceof ChallengeResponse) {
				handleChallenge((ChallengeResponse) resp, delHandle);
			}
			// for the exceptions, probably just do nothing.
		} catch (HandleException e) {
		}
	}

	/**
	 * {@inheritDoc} <b>Warning: untested</b>
	 */
	public void removeContext(URI context) {
		try {
			HandleName fullContextHandle = nextHandleName(serverNA, context.toString());
			// if it actually exists...
			if (!fullContextHandle.needToCreate) {
				String subprefix = fullContextHandle.name.replace('/', '.');
				ListHandlesRequest listHandles = new ListHandlesRequest(Util.encodeString(subprefix), null);
				server.processRequest(listHandles, this);
				if (resp instanceof ChallengeResponse) {
					handleChallenge((ChallengeResponse) resp, listHandles);
				}
				if (!(resp instanceof ListHandlesResponse)) {
					return;
				}
				ListHandlesResponse hdlsToDelete = (ListHandlesResponse) resp;
				for (int i = 0; i < hdlsToDelete.handles.length; i++) {
					// System.out.println("deleting handle " +
					// Util.decodeString(hdlsToDelete.handles[i]));
					DeleteHandleRequest delHandle = new DeleteHandleRequest(hdlsToDelete.handles[i], null);
					try {
						server.processRequest(delHandle, this);
						if (resp instanceof ChallengeResponse) {
							handleChallenge((ChallengeResponse) resp, delHandle);
						}
						// for the exceptions, probably just do nothing.
					} catch (HandleException e) {
						e.printStackTrace();
					}
				}
				// System.out.println("deleting context handle " +
				// fullContextHandle);
				DeleteHandleRequest delContext = new DeleteHandleRequest(Util.encodeString(fullContextHandle.name), null);
				server.processRequest(delContext, this);
				if (resp instanceof ChallengeResponse) {
					handleChallenge((ChallengeResponse) resp, delContext);
				}
			}
			// for the exceptions, probably just do nothing.
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Browses the Handle Server repository to find a hash-based handle name for
	 * the given data under the given prefix. Also signals via the
	 * {@link needToCreate} variable whether this handle has not already been
	 * created previously.
	 * 
	 * @param prefix
	 *            The naming authority prefix that will contain the new handle
	 * @param data
	 *            The data that will be stored in the new handle
	 * @param newPrefix
	 *            Indicates whether the prefix might need to be registered with
	 *            the server. It is safe to make this {@code true} every time,
	 *            but if the prefix is already registered, a {@code false} value
	 *            will save some unnecessary communication costs.
	 * @return A hash-based string that can be used as a new handle name.
	 * @throws InvalidHandleFormatException
	 *             If the handle already exists but has an invalid format. For
	 *             example, if the expected attribute does not exist.
	 * @throws HashCollisionException
	 *             If a handle cannot be created for this data due to a hash
	 *             collision with a previously created handle.
	 * @throws HandleException
	 *             If the server creates a HandleException while looking up the
	 *             handle.
	 */
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
			buffer.append(longEncoded.charAt(i));
			// expecting to find the context URI or resource data at index 1
			ResolutionRequest lookup = new ResolutionRequest(Util.encodeString(buffer.toString()), null, new int[] { 1 }, null);
			server.processRequest(lookup, this);
			// if we found it, check to see if we've already created this handle
			// or if the hash bucket is already taken
			if (resp instanceof ResolutionResponse) {
				HandleValue[] hv = ((ResolutionResponse) resp).getHandleValues();
				// if it actually has info at index 1...
				if (hv.length == 1) {
					hashCollision = hv[0].getDataAsString();
					// if it's not really a hash collision...
					if (hashCollision.equals(data)) {
						handleName.name = buffer.toString();
						handleName.needToCreate = false;
						return handleName;
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

	/**
	 * Uses authInfo to answer a challenge in the Handle System protocol.
	 * 
	 * @param challenge
	 *            The challenge sent from the server
	 * @param req
	 *            The original request that caused the challenge
	 * @throws HandleException
	 *             If the authentication process fails or if the server is
	 *             unable to process the challenge answer.
	 */
	private void handleChallenge(ChallengeResponse challenge, AbstractRequest req) throws HandleException {
		byte sig[] = authInfo.authenticate(challenge, req);
		ChallengeAnswerRequest reply = new ChallengeAnswerRequest(authInfo.getAuthType(), authInfo.getUserIdHandle(),
				authInfo.getUserIdIndex(), sig, null);
		reply.takeValuesFrom(req);
		reply.sessionId = challenge.sessionId;
		reply.sessionInfo = req.sessionInfo;
		server.processRequest(reply, this);
	}

	/**
	 * Used internally by the Handle System.  Calling applications should not
	 * use this method.
	 */
	public void handleResponse(AbstractResponse message) {
		resp = message;
	}

	private class HandleName {
		String name = "";
		boolean needToCreate = false;
	}
}
