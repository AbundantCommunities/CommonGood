package org.abundantcommunityinitiative.commongood;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Uses a java.security.SecureRandom to generate random bytes. We recreate our
 * random number generator after we have generated a certain number of bytes
 * (good practice: makes determining the pseudo random sequence harder).
 *
 * Currently, the number of bytes is HARD CODED.
 */
public class FreshRandomness {
    public static final int MAX_GENERATED_BYTES = 50 & 1000 * 1000;
    private static Logger logger = Logger.getLogger( FreshRandomness.class.getName() ); 

    private static SecureRandom sRand;
    private static int srFitness = 0;

    public void get(byte[] bytes) {
        getRandom().nextBytes(bytes);
        srFitness -= bytes.length;
    }

    private SecureRandom getRandom() {
        if (srFitness < 1) {
            try {
                logger.log(Level.INFO, "Generating fresh source of random bytes");
                sRand = SecureRandom.getInstance("SHA1PRNG");
                srFitness = MAX_GENERATED_BYTES;

            } catch (NoSuchAlgorithmException ex) {
                logger.log(Level.SEVERE, null, ex);
                // TODO Say something helpful
                throw new RuntimeException("Failed");
            }
        }
        return sRand;
    }
}
