package org.abundantcommunityinitiative.commongood;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Hasher {

    private final HashSpec currentSpec;
    private final FreshRandomness random = new FreshRandomness();

    public Hasher(HashSpec cs) {
        currentSpec = cs;
    }

    /**
     * Create the hash of a newly chosen password. Uses this Hasher's HashSpec
     * to control how much salt to use, the algorithm, etc. Generates fresh,
     * random salt.
     *
     * @param password The password as a char array.
     *
     * @return a printable String that encodes the resulting hash value plus all
     * the data used to create the value.
     */
    public String create(final char[] password) {
        byte[] salt = new byte[currentSpec.saltLength];
        random.get(salt);
        byte[] value = hash(currentSpec.algorithm, salt, currentSpec.iterations, currentSpec.keyLength, password);

        Base64.Encoder enc = Base64.getEncoder();  // Needs Java 8
        String saltE = enc.encodeToString(salt);
        String hashE = enc.encodeToString(value);
        return currentSpec.asString() + "|" + saltE + "|" + hashE;
    }

    static private byte[] hash(final String alg, final byte[] salt, final int its, final int kLen, final char[] password) {
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance(alg);
            PBEKeySpec spec = new PBEKeySpec(password, salt, its, kLen);
            SecretKey key = skf.generateSecret(spec);
            byte[] value = key.getEncoded();
            return value;

        } catch( NoSuchAlgorithmException e ) {
            throw new RuntimeException(e);

        } catch( InvalidKeySpecException e ) {
            throw new RuntimeException(e);
        }
    }

    public String validateAndRehash(String knownGood, final char[] possiblyGood) {
        // TODO Validate and possibly rehash. Three possible outcomes:
        // .... 1. possiblyGood isn't
        // .... 2. possiblyGood is good and uses currentSpec
        // .... 3. possiblyGood is good and currentSpec is different; return newly hashed
        return null;
    }

    static public boolean validate(String knownGood, final char[] possiblyGood) {
        String[] tokens = knownGood.split("\\|");
        String a = tokens[0];
        int i = Integer.valueOf(tokens[1]);
        int k = Integer.valueOf(tokens[3]);
        Base64.Decoder dec = Base64.getDecoder();
        byte[] s = dec.decode(tokens[4]);
        byte[] v = dec.decode(tokens[5]);

        byte[] possible = hash(a, s, i, k, possiblyGood);
        if (v.length == possible.length) {
            for (int j = 0; j < v.length; j++) {
                if (v[j] != possible[j]) {
                    System.out.println("BYTE MISMATCH");
                    return false;
                }
            }
        } else {
            System.out.println("LENGTH ERROR");
            return false;
        }

        return true;
    }
}
