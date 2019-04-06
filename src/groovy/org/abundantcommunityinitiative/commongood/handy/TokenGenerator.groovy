package org.abundantcommunityinitiative.commongood.handy

import java.security.SecureRandom;

/**
 * A source of strings containing random hex digits.
 */
class TokenGenerator {
    private static SecureRandom source = SecureRandom.getInstance("SHA1PRNG");

    /**
     * returns a String containing 16 random hex digits
     */
    public static String get( ) {
        return get( 16 )
    }

    /**
     * returns a String containing the specified number random hex digits
     */
    public static String get( int hexDigits ) {
        if( hexDigits % 2 != 0 ) {
            throw new RuntimeException( "Odd number of digits")
        }
        byte[] bytes = new byte[ hexDigits / 2 ]
        source.nextBytes( bytes )
        final Writable printableHex = bytes.encodeHex( )
        return printableHex.toString()
    }
}
