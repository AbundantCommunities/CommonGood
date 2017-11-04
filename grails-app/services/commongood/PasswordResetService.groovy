package commongood

import grails.transaction.Transactional

@Transactional
class PasswordResetService {

    // Return a PasswordReset but null if emailAddress fails our tests
    PasswordReset requestEmail( String emailAddress ) {
        if( validateEmailAddress(emailAddress) ) {
            println "SHOULD WRITE RESET to DATABASE"
            println "SHOULD SEND EMAIL to MAILGUN"
            Date expiresAt
            use( groovy.time.TimeCategory ) {
                expiresAt = 6.hours.from.now
            }
            def reset = new PasswordReset( token:"randomHexString", emailAddress:emailAddress,
                            expiryTime:expiresAt, state:"Active" )
            return reset
        } else {
            return null
        }
    }

    Tuple2 get( String token ) {
        def reset = PasswordReset.findByToken( token )
        if( reset ) {
            if( reset.state.equals("Active") ) {
                if( reset.expiryTime ) {
                    return new Tuple2( "okay", reset )
                } else {
                    log.warn "${reset.logString} is stale"
                    return new Tuple2( "stale", reset )
                }
            } else {
                log.warn "${reset.logString} is not active"
                return new Tuple2( "inactive", reset )
            }
        } else {
            log.warn "This is ODD. Password reset token not on file: ${token}"
            return new Tuple2( "nof", new PasswordReset() ) // Can't put a null in a Tuple2
        }
    }

    def validateEmailAddress( String emailAddress ) {
        def person = Person.findByEmailAddress( emailAddress )
        if( !person ) {
            log.warn "No person with email address = ${emailAddress}"
            return false
        }
        if( !person.appUser ) {
            log.warn "${person} is not an appUser"
            return false
        }
        def da = DomainAuthorization.findByPerson( person )
        if( !da ) {
            log.warn "${person} has no DomainAuthorization"
            return false
        }
        return true
    }

    def reset( PasswordReset reset, String password ) {
        if( validateEmailAddress(reset.emailAddress) ) {
            println "MUST HASH ${password} and SAVE IT"
            log.info "We should change the password for ${reset}"
        }
    }
}
