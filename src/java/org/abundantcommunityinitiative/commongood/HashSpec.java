package org.abundantcommunityinitiative.commongood;

/**
 * Holds the values we have configured for performing password hashing.
 * Ex: our application instance always has a current HashSpec, used to hash
 * a newly chosen password. We store the spec with the hash value so that
 * we can authenticate the user when she logs in.
 */
public class HashSpec {

    // / / / / / / / / / / / / / / / / / / / / / / / / / /
    //  All members & methods have "package private" scope.
    // / / / / / / / / / / / / / / / / / / / / / / / / / /

    String algorithm; // Like "PBKDF2WithHmacSHA512"
    int iterations; // How many times our PBKDF2 will spin
    int saltLength;
    int keyLength;

    HashSpec(String a, int i, int sl, int kl) {
        algorithm = a;
        iterations = i;
        saltLength = sl;
        keyLength = kl;
    }

    String asString() {
        return algorithm + "|" + iterations + "|" + saltLength + "|" + keyLength;
    }

    HashSpec valueOf(String asString) {
        String[] tokens = asString.split("\\|");
        String a = tokens[0];
        int i = Integer.valueOf(tokens[1]);
        int sl = Integer.valueOf(tokens[2]);
        int kl = Integer.valueOf(tokens[3]);
        return new HashSpec(a, i, sl, kl);
    }
}
