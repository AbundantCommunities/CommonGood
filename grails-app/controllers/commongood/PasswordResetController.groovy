package commongood

class PasswordResetController {

    def authenticateService
    def passwordResetService

    def index( ) {
        if( authenticateService.isAuthenticated(session) ) {
            log.info "User ${session.user.logName} is logged in and asked for password reset form!"
        } else {
            log.info "Anonymous request for password reset form"
        }
    }

    // The user submitted an emailAddress
    def sendEmail( ) {
        // We do very little to assess the email address's format.
        // If it's in the database then we've already decided the format is good.
        String emailAddress = params.emailAddress.trim( )
        if( emailAddress.indexOf( "@" ) > 0 ) {
            // If the service likes the emailAddress it will make a new PasswordReset and
            // send a reset email that references the PasswordReset.
            def reset = passwordResetService.sendEmail( emailAddress )
            if( reset ) {
                log.info "Emailed ${reset}"
                [
                    reset: reset
                ]
            } else {
                log.info "Rejecting reset password request for ${emailAddress}"
                flash.message = "We cannot email a password reset to ${emailAddress}"
                flash.nature = 'WARNING'
                redirect action:'index'
            }
        } else {
            log.info "Bad email address format: ${emailAddress}"
            flash.message = "The format of this email address is bad: ${emailAddress}"
            flash.nature = 'WARNING'
            redirect action:'index'
        }
    }

    //                      CAREFUL!
    // In PasswordResetService's sendToMailGun method we build a URL that we
    // place in an email; the URL POINTS TO THIS CONTROLLER ACTION.
    //
    // The user has clicked on the URL we sent in the email (OR someone is tricksy!)
    def getNew( ) {
        String token = params.token
        def ( String quality, PasswordReset reset ) = passwordResetService.get( token )
        if( quality.equals("okay") ) {
            log.info "Retrieved good ${reset}"
            session.passwordReset = reset
        } else {
            session.passwordReset = null
        }
        [
            quality: quality,
            reset: reset
        ]
    }

    def reset( ) {
        def pwd1 = params.password1.trim( )
        def pwd2 = params.password2.trim( )
        def reset = session.passwordReset
        println "Retrieved reset from session: ${reset}"
        // TODO Explore session.passwordReset no longer attached to Hibernate session
        if( pwd1.equals(pwd2) ) {
            // update the person row
            log.info "User submitted 2 identical passwords for ${reset}"
            if( passwordResetService.reset(reset,pwd1) ) {
                log.info "Password successfully reset for ${reset}"
                [
                    reset: reset
                ]
            } else {
                flash.message = "We're sorry; we failed to reset your password"
                flash.nature = 'WARNING'
                redirect action:'getNew', params:[token:reset.token]
            }
        } else {
            log.info "User submitted 2 different passwords for ${reset}"
            flash.message = "Those two passwords are not the same"
            flash.nature = 'WARNING'
            redirect action:'getNew', params:[token:reset.token]
        }
    }
}
