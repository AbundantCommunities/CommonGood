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

    def requestEmail( ) {
        String emailAddress = params.emailAddress
        if( !goodEmailAddressFormat(emailAddress) ) {
            log.info "Invalid email address format: ${emailAddress}"
            flash.message = "The format of this email address is bad: ${emailAddress}"
            flash.nature = 'WARNING'
            redirect action:'index'
        } else {
            def reset = passwordResetService.requestEmail( emailAddress )
            if( reset ) {
                // The address passed our database checks.
                // Also: the service has created a new reset token
                // and the service sent the reset email
                log.info "Emailed ${reset.logString}"
                [
                    emailAddress: emailAddress,
                    expires: reset.expiryTime
                ]
            } else {
                log.info "Rejecting request for ${emailAddress}; failed database checks"
                flash.message = "Cannot send a password reset to ${emailAddress}"
                flash.nature = 'WARNING'
                redirect action:'index'
            }
        }
    }

    Boolean goodEmailAddressFormat( String address ) {
        println "WE SHOULD DO A BETTER JOB OF CHECKING EMAIL FORMAT!??"
        def atSign = address.indexOf( "@" )
        return atSign > 0
    }

    // The user has clicked on the URL we sent in the email (hopefully!)
    def getNew( ) {
        String token = params.token
        def ( String quality, PasswordReset reset ) = passwordResetService.get( token )
        if( quality.equals("okay") ) {
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
}
