package org.abundantcommunityinitiative.commongood.handy

import java.security.SecureRandom;

/**
 * A soure of strings of random 16 hex digits.
 */
class TokenGenerator {
    private static SecureRandom source = SecureRandom.getInstance("SHA1PRNG");

    public static String get( ) {
        byte[] bytes = new byte[8]
        source.nextBytes( bytes )
        final Writable printableHex = bytes.encodeHex( )
        return printableHex.toString()
    }
}
