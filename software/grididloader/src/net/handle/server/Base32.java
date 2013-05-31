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
 * Base32 is a class wrapper for methods used to encode/decode
 * binary data into the Base32 encoding, as specified in RFC
 * 3548.
 *
 * Base32 is used instead of Base64 because Handle System
 * names may be case-insensitive, as specified in the Handle
 * System protocol, RFC 3650
 *
 * @see <a href="http://www.ietf.org/rfc/rfc3548.txt">RFC 3548</a>
 * @see <a href="http://www.handle.net/rfc/rfc3650.html">RFC 3650</a>
 */

public class Base32 {
	private static final char[] codeChars = {
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
		'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
		'U', 'V', 'W', 'X', 'Y', 'Z', '2', '3', '4', '5',
		'6', '7'
	};
	private static final byte reverseLookup(char codeChar) {
		if ((codeChar >= 'A') && (codeChar <= 'Z')) {
			return (byte)(codeChar - 'A');
		}
		if ((codeChar >= '2') && (codeChar <= '7')) {
			return (byte)(26 + (codeChar - '2'));
		}
		throw new RuntimeException("invalid character " + codeChar);
	}

	/**
	 * Converts arbitrary binary data into a Base32-encoded
	 * {@link String}.
	 * @param data	the binary data in an array of {@code byte}s.
	 * @return	a {@link String} with the Base32-encoded data.
	 */
	public static String encode(byte[] data) {
		String ans = "";
		for (int i=0; i<data.length / 5; i++) {
			int val1 = (data[5*i] & 0xf8) / 8;
			ans += codeChars[val1];
			int val2 = (data[5*i] & 0x07) * 4 + (data[5*i+1] & 0xc0) / 64;
			ans += codeChars[val2];
			int val3 = (data[5*i+1] & 0x3e) / 2;
			ans += codeChars[val3];
			int val4 = (data[5*i+1] & 0x01) * 16 + (data[5*i+2] & 0xf0) / 16;
			ans += codeChars[val4];
			int val5 = (data[5*i+2] & 0x0f) * 2 + (data[5*i+3] & 0x80) / 128;
			ans += codeChars[val5];
			int val6 = (data[5*i+3] & 0x7c) / 4;
			ans += codeChars[val6];
			int val7 = (data[5*i+3] & 0x03) * 8 + (data[5*i+4] & 0xe0) / 32;
			ans += codeChars[val7];
			int val8 = (data[5*i+4] & 0x1f);
			ans += codeChars[val8];
		}
		// take care of padding
		int lastBlock = 5 * (data.length / 5);
		int numBytes = data.length % 5;
		if (numBytes == 0)
			return ans;
		int val1 = (data[lastBlock] & 0xf8) / 8;
		ans += codeChars[val1];
		if (numBytes == 1) {
			int val2 = (data[lastBlock] & 0x07) * 4;
			ans += codeChars[val2] + "======";
			return ans;
		}
		int val2 = (data[lastBlock] & 0x07) * 4 + (data[lastBlock+1] & 0xc0) / 64;
		ans += codeChars[val2];
		int val3 = (data[lastBlock+1] & 0x3e) / 2;
		ans += codeChars[val3];
		if (numBytes == 2) {
			int val4 = (data[lastBlock+1] & 0x01) * 16;
			ans += codeChars[val4] + "====";
			return ans;
		}
		int val4 = (data[lastBlock+1] & 0x01) * 16 + (data[lastBlock+2] & 0xf0) / 16;
		ans += codeChars[val4];
		if (numBytes == 3) {
			int val5 = (data[lastBlock+2] & 0x0f) * 2;
			ans += codeChars[val5] + "===";
			return ans;
		}
		int val5 = (data[lastBlock+2] & 0x0f) * 2 + (data[lastBlock+3] & 0x80) / 128;
		ans += codeChars[val5];
		int val6 = (data[lastBlock+3] & 0x7c) / 4;
		ans += codeChars[val6];
		if (numBytes == 4) {
			int val7 = (data[lastBlock+3] & 0x03) * 8;
			ans += codeChars[val7] + "=";
			return ans;
		}
		System.err.println("bug!  length = " + data.length + ", lastBlock = " + lastBlock + ", numBytes = " + numBytes);
		return null;
	}

	/**
	 * Converts a Base32-encoded {@link String} into raw
	 * binary data, as an array of {@code byte}.
	 * @param data	a {@link String} containing the
	 * 		Base-32-encoded data.
	 * @return	the decoded binary data in an array of {@code byte}s if
	 * 		{@code data} is formatted correctly;
	 * 		{@code null} otherwise.
	 */
	public static byte[] decode(String data) {
		byte[] ans;
		if (data.matches("([A-Z2-7]{8})*")) {
			ans = new byte[data.length()/8 * 5];
		} else if (data.matches("([A-Z2-7]{8})*[A-Z2-7]{2}======")) {
			data = data.substring(0, data.indexOf('='));
			ans = new byte[data.length()/8 * 5 + 1];
		} else if (data.matches("([A-Z2-7]{8})*[A-Z2-7]{4}====")) {
			data = data.substring(0, data.indexOf('='));
			ans = new byte[data.length()/8 * 5 + 2];
		} else if (data.matches("([A-Z2-7]{8})*[A-Z2-7]{5}===")) {
			data = data.substring(0, data.indexOf('='));
			ans = new byte[data.length()/8 * 5 + 3];
		} else if (data.matches("([A-Z2-7]{8})*[A-Z2-7]{7}=")) {
			data = data.substring(0, data.indexOf('='));
			ans = new byte[data.length()/8 * 5 + 4];
		} else {
			System.err.println("invalid base32 string");
			return null;
		}
		int currPos = 0;
		for (int i=0; i<data.length()/8; i++) {
			ans[currPos++] = (byte)(reverseLookup(data.charAt(8*i)) * 8 +
				(reverseLookup(data.charAt(8*i+1)) & 0x1c) / 4);
			ans[currPos++] = (byte)((reverseLookup(data.charAt(8*i+1)) & 0x03) * 64 +
				(reverseLookup(data.charAt(8*i+2)) & 0x1f) * 2 +
				(reverseLookup(data.charAt(8*i+3)) & 0x10) / 16);
			ans[currPos++] = (byte)((reverseLookup(data.charAt(8*i+3)) & 0x0f) * 16 +
				(reverseLookup(data.charAt(8*i+4)) & 0x1e) / 2);
			ans[currPos++] = (byte)((reverseLookup(data.charAt(8*i+4)) & 0x01) * 128 +
				(reverseLookup(data.charAt(8*i+5)) & 0x1f) * 4 +
				(reverseLookup(data.charAt(8*i+6)) & 0x18) / 8);
			ans[currPos++] = (byte)((reverseLookup(data.charAt(8*i+6)) & 0x07) * 32 +
				(reverseLookup(data.charAt(8*i+7)) & 0x1f));
		}
		// take care of padding
		int lastBlock = 8 * (data.length() / 8);
		int numBytes = data.length() % 8;
		if (numBytes == 0) {
			return ans;
		}
		ans[currPos++] = (byte)(reverseLookup(data.charAt(lastBlock)) * 8 +
			(reverseLookup(data.charAt(lastBlock+1)) & 0x1c) / 4);
		if (numBytes == 2) {
			return ans;
		}
		ans[currPos++] = (byte)((reverseLookup(data.charAt(lastBlock+1)) & 0x03) * 64 +
			(reverseLookup(data.charAt(lastBlock+2)) & 0x1f) * 2 +
			(reverseLookup(data.charAt(lastBlock+3)) & 0x10) / 16);
		if (numBytes == 4) {
			return ans;
		}
		ans[currPos++] = (byte)((reverseLookup(data.charAt(lastBlock+3)) & 0x0f) * 16 +
			(reverseLookup(data.charAt(lastBlock+4)) & 0x1e) / 2);
		if (numBytes == 5) {
			return ans;
		}
		ans[currPos++] = (byte)((reverseLookup(data.charAt(lastBlock+4)) & 0x01) * 128 +
			(reverseLookup(data.charAt(lastBlock+5)) & 0x1f) * 4 +
			(reverseLookup(data.charAt(lastBlock+6)) & 0x18) / 8);
		if (numBytes == 7) {
			return ans;
		}
		System.err.println("bug!  length = " + data.length() + ", lastBlock = " + lastBlock + ", numBytes = " + numBytes);
		return null;
	}

	/**
	 * Sole constructor.  Since all methods are abstract, there is
	 * no need to instantiate a {@link Base32} object.
	 */
	private Base32() { }

}

