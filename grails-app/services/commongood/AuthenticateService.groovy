package commongood

import org.abundantcommunityinitiative.commongood.HashSpec
import org.abundantcommunityinitiative.commongood.Hasher
import grails.transaction.Transactional

@Transactional
class AuthenticateService {

    /**
     * Handy for client code to check if the user's session has timed out.
     */
    public Boolean isAuthenticated( session ) {
        if( session.user ) {
            return Boolean.TRUE
        } else {
            return Boolean.FALSE
        }
    }

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
                log.warn "${peep.fullName} failed password validation"
            }
        }

        return null // this signals FAILURE
    }
}
