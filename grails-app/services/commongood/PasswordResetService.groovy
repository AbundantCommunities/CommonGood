package commongood

import grails.transaction.Transactional

@Transactional
class PasswordResetService {

    // Return null if emailAddress is suspect else return a PasswordReset object.
    def requestEmail( String emailAddress ) {
        if( emailAddress.length() > 10 ) {
            println "email address is longer than 10"
            println "SHOULD CREATE RESET ROW"
            def reset = new PasswordReset( token:"randomHexString", emailAddress:emailAddress,
                            expiryTime:new Date(), expired:false, successful:false )
            return reset
        } else {
            println "email address is short"
            return null
        }
    }

    def validateEmailAddress( String emailAddress ) {
        if( !addrOnFile ) {
            return false
        }
        if( !appUser ) {
            return false
        }
        if( !daRow ) {
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
            // hash & store in person row
        }
    }
}
