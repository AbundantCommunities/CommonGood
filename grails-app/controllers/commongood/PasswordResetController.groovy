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
        String emailAddress = params.emailAddress
        if( emailAddress.indexOf( "@" ) > 0 ) {
            // If the service likes the emailAddress it will make a new PasswordReset and
            // send a reset email that references the PasswordReset.
            def reset = passwordResetService.sendEmail( emailAddress )
            if( reset ) {
                log.info "Emailed ${reset.moniker}"
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

    // The user has clicked on the URL we sent in the email (or someone is tricksy!)
    def getNew( ) {
        String token = params.token
        def ( String quality, PasswordReset reset ) = passwordResetService.get( token )
        if( quality.equals("okay") ) {
            log.info "Retrieved good ${reset.moniker}"
            session.passwordReset = reset
        } else {
            session.passwordReset = null
        }
        [
            quality: quality,
            reset: reset
        ]
    }
/*
getNew
    fetch the PasswordReset row
    if nof then
        go to index form with yellow msg: "not a valid reset request (too old?)"
    endif
    if already changed password then
        go to index form with yellow msg: "already changed password with this link"
    endif
    if stale dated
        go to index form with yellow msg: "Too old"
    endif
    fetch the person row USING THE PERSON ID(!)
    if peron's email address != PasswordReset's email address then
        Blow up (this is odd)
    endif
    if email address is blank OR !app_user OR !DA row then
        reset.gsp says "WTF?!"
    endif
    store token in session
    getNew.gsp offers
        two password controls
        submit buttom which posts to reset action

reset
    get the token from session (if not there then blow up)
    do the same validity checks as getNew
    if the two passwords match then
        set the PasswordReset row to successful
        hash the password
        set person.hashedPassword
        set passwordReset.successful to true
        commit
        goto login page with a green thumbs up message
    else
        goto getNew with a yellow "you did a whoopsie" message
    endif
*/
    def reset( ) {
        def pwd1 = params.password1
        def pwd2 = params.password2
        def reset = session.passwordReset
        println "Retrieved reset from session: ${reset}"
        // TODO Explore session.passwordReset no longer attached to Hibernate session
        if( pwd1.equals(pwd2) ) {
            // update the person row
            log.info "User submitted 2 identical passwords for ${reset.moniker}"
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
