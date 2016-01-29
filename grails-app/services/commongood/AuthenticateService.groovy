package commongood

import com.cognish.password.HashSpec
import com.cognish.password.Hasher
import grails.transaction.Transactional

@Transactional
class AuthenticateService {

    /**
     * Returns a Person if and only if the emailAddress and password match.
    */
    public Person check( emailAddress, password ) {
        println "Request to check password of ${emailAddress}"

        HashSpec spec = new HashSpec("PBKDF2WithHmacSHA512", 75000, 64, 256)
        println "HASH SPEC: ${spec.asString()}"
        Hasher hasher = new Hasher(spec)
        String res = hasher.create(password.toCharArray())
        println("HASH RESULT: ${res}")

        def peeps = Person.findAll( 'from Person where emailAddress=? and appUser=true', [emailAddress] )

        if( peeps.size() > 1 ) {
            println "NASTY data integrity problem; ${peeps.size()} people with matching passwords for ${emailAddress}"

        } else if ( peeps.size() == 0 ) {
            println "No password match for ${emailAddress}"

        } else {
            def peep = peeps[0]
            if (Hasher.validate(peep.hashedPassword, password.toCharArray())) {
                println "${peep.fullName} authenticated successfully"
                return peep
            } else {
                println "${peep.fullName} FAILED to authenticat"
            }
        }

        return null
    }
}
