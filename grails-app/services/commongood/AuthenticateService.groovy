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
        log.debug "Request to check password of ${emailAddress}"

        def peeps = Person.findAll( 'from Person where emailAddress=? and appUser=true', [emailAddress] )

        if( peeps.size() > 1 ) {
            log.error "Authentication failure: ${peeps.size()} people with appUser=true and address=${emailAddress}"

        } else if ( peeps.size() == 0 ) {
            log.warn "No Person where emailAddress='${emailAddress}' and appUser=true"

        } else {
            def peep = peeps[0]
            if (Hasher.validate(peep.hashedPassword, password.toCharArray())) {
                log.info "${peep.fullName} authenticated successfully"
                return peep
            } else {
                log.warn "${peep.fullName} FAILED to authenticat"
            }
        }

        return null // this signals FAILURE
    }
}
