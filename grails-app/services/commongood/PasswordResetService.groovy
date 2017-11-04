package commongood

import grails.transaction.Transactional

@Transactional
class PasswordResetService {

    // Return a PasswordReset but null if emailAddress fails our tests
    PasswordReset requestEmail( String emailAddress ) {
        if( validateEmailAddress(emailAddress) ) {
            println "SHOULD WRITE RESET to DATABASE"
            println "SHOULD SEND EMAIL to MAILGUN"
            def reset = new PasswordReset( token:"randomHexString", emailAddress:emailAddress,
                            expiryTime:new Date(), state:"Active" )
            return reset
        } else {
            return null
        }
    }

    PasswordReset get( String token ) {
        def reset = PasswordReset.findByToken( token )
        if( reset ) {
            if( reset.state.equals("Active") ) {
                if( reset.expiryTime ) {
                    log.info "Retrieved ${reset.logString} okay"
                    return reset
                } else {
                    log.warn "${reset.logString} is stale"
                }
            } else {
                log.warn "${reset.logString} is not active"
            }
        } else {
            log.warn "This is ODD. Password reset token not on file: ${token}"
        }
        return null
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

    def reset( String emailAddress, String password ) {
        if( validateEmailAddress(emailAddress) ) {
            // Store the hash of the pwd in person row
        }
    }
}
