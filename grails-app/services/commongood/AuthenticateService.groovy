package commongood

import grails.transaction.Transactional

@Transactional
class AuthenticateService {

    // FIXME NOT SUITABLE FOR PRODUCTION !!

    /**
     * Returns a Person if and only if the emailAddress and password match.
    */
    public Person check( emailAddress, password ) {
        
        Integer phoneyHash = password.hashCode( )
        def peeps = Person.findAll( 'from Person where emailAddress=? and appUser=true and passwordHash=?', [emailAddress,phoneyHash] )

        if( peeps.size() > 1 ) {
            println "NASTY data integrity problem; ${peeps.size()} people with matching passwords for ${emailAddress}"

        } else if ( peeps.size() == 0 ) {
            println "No password match for ${emailAddress}"

        } else {
            def peep = peeps[0]
            println "Phoney authentication success for ${peep.fullName}"
            return peep
        }

        return null
    }
}
