package commongood

import grails.transaction.Transactional

@Transactional
class AuthenticateService {

    // FIXME Not suitable for production!

    public Person check( emailAddress, password ) {
        
        def phoneyHash = password.size( )
        def peeps = Person.findAll( 'from Person where emailAddress = ? and appUser and passwordHash != 0', [emailAddress] )

        if( peeps.size() > 1 ) {
            println "NASTY data integrity problem; ${peeps.size()} people with passwords for ${emailAddress}"

        } else if ( peeps.size() == 0 ) {
            println "No passwords on file for ${emailAddress}"

        } else {
            Person peep = peeps[0]
            if( peep.passwordHash == phoneyHash) {
                println "Phoney authentication success for ${peep.fullName}"
                return peep
            } else {
                println "Hash failure for ${emailAddress}"
            }
        }

        return null
    }
}
