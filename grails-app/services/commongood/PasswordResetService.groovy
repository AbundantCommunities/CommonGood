package commongood

import grails.transaction.Transactional
import com.cognish.password.FreshRandomness
import com.cognish.password.HashSpec
import com.cognish.password.Hasher

@Transactional
class PasswordResetService {

    FreshRandomness fresher = new FreshRandomness( )

    // Send a reset email and return a new PasswordReset
    // (but no email and return null if emailAddress fails database tests)
    PasswordReset sendEmail( String emailAddress ) {
        Person person = emailAddressIsOkay( emailAddress )
        if( person ) {
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

    private Person emailAddressIsOkay( String emailAddress ) {
        def person = Person.findByEmailAddress( emailAddress )
        if( !person ) {
            log.warn "No person with email address ${emailAddress}"
            return null
        }
        if( !person.appUser ) {
            log.warn "${person.logName} is not an appUser"
            return null
        }
        def da = DomainAuthorization.findByPerson( person )
        if( !da ) {
            log.warn "${person.logName} has no DomainAuthorization"
            return null
        }
        return person
    }

    def reset( PasswordReset reset, String password ) {
        def person = Person.findByEmailAddress( reset.emailAddress )
        if( person ) {
            // Get reset again, so it can be part of this Hibernate Transaction
            reset = PasswordReset.findByToken( reset.token )
            if( !reset ) {
                log.warn "SHOULD BE TESTING EVEN MORE THOROUGHLY !!!!"
                return false
            }
            String hashed = hashPassword( password )
            person.hashedPassword = hashed
            person.save( flush:true, failOnError: true )

            reset.state = "Used"
            reset.save( flush:true, failOnError: true )

            log.info "Changed the password for ${person.logName}"
            return true
        } else {
            log.warn "SOMEHOW password reset's email address no longer on file ${reset.moniker}"
            return false
        }
    }

    def hashPassword( String password ) {
        // Neat thing is: one can change the parameters here without affecting
        // the existing password hashes.
        HashSpec spec = new HashSpec( "PBKDF2WithHmacSHA512", 75000, 64, 256 )
        Hasher hasher = new Hasher( spec )
        return hasher.create( password.toCharArray() )
    }
}
