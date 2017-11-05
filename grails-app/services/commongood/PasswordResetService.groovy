package commongood

import grails.transaction.Transactional
import com.cognish.password.FreshRandomness

@Transactional
class PasswordResetService {

    FreshRandomness fresher = new FreshRandomness( )

    // Send a reset email and return a new PasswordReset
    // (but no email and return null if emailAddress fails database tests)
    PasswordReset sendEmail( String emailAddress ) {
        if( emailAddressIsOkay(emailAddress) ) {
            println "SHOULD SEND EMAIL to MAILGUN"
            Date expiresAt
            use( groovy.time.TimeCategory ) {
                expiresAt = 6.hours.from.now
            }
            byte[] randy = new byte[32]
            fresher.get( randy )
            def token = randy.encodeHex().toString()
            def reset = new PasswordReset( token:token, emailAddress:emailAddress,
                            expiryTime:expiresAt, state:"Active" )
            reset.save( flush:true, failOnError: true )
            return reset
        } else {
            return null
        }
    }

    // Find the random token in the PasswordReset table
    Tuple2 get( String token ) {
        // TODO Probably should index PasswordReset table by token
        def reset = PasswordReset.findByToken( token )
        if( reset ) {
            if( reset.state.equals("Active") ) {
                if( new Date() < reset.expiryTime ) {
                    return new Tuple2( "okay", reset )
                } else {
                    log.info "${reset.moniker} is stale"
                    return new Tuple2( "stale", reset )
                }
            } else {
                log.info "${reset.moniker} is not active"
                return new Tuple2( "inactive", reset )
            }
        } else {
            log.warn "UNEXPECTED: Password reset token not on file: ${token}"
            return new Tuple2( "nof", new PasswordReset() ) // Can't put a null in a Tuple2
        }
    }

    def emailAddressIsOkay( String emailAddress ) {
        def person = Person.findByEmailAddress( emailAddress )
        if( !person ) {
            log.warn "No person with email address ${emailAddress}"
            return false
        }
        if( !person.appUser ) {
            log.warn "${person.getLogName} is not an appUser"
            return false
        }
        def da = DomainAuthorization.findByPerson( person )
        if( !da ) {
            log.warn "${person.logName} has no DomainAuthorization"
            return false
        }
        return true
    }

    def reset( PasswordReset reset, String password ) {
        if( validateEmailAddress(reset.emailAddress) ) {
            println "MUST HASH ${password} and SAVE IT"
            log.info "We should change the password for ${reset.moniker}"
        }
    }
}
