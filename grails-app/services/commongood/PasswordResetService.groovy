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
    /*
    These 3 checks are required in both the requestEmail and reset actions
    is the email address on file?
    if so, is app_user true?
    if so, is there a DA record?
    IF ALL OKAY THEN
        create PasswordReset row
        send email with link like https://app.aci.org/password/getNew?token=F362DCA6890E958.....
        the GSP displays
            text about checking email for you@someplace.ca
            you have X hours
            Close tab button
    ELSE
        display the index form with warning msg: Email address is not valid
    ENDIF
*/

    def reset( String emailAddress, String password ) {
        if( validateEmailAddress(emailAddress) ) {
            // Store the hash of the pwd in person row
        }
    }
}
