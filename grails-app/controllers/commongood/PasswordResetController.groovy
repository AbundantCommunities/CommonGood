package commongood

/**
 * Handle user requests for resetting her password.
 */

class PasswordResetController {

    def authenticateService
    def passwordResetService

/*
ALL ACTIONS SHOULD
    allow anonymous requests
    Barf if user is logged in
 */

    def index( ) {
        if( authenticateService.isAuthenticated(session) ) {
            // Makes no sense to ask for this form if you are logged in
            log.warn "User ${session.user.logName} asked for password reset form but is logged in"
            
            // TODO Take user to her normal landing page in a less convoluted way
            redirect controller:'login'
        } else {
            // User is not authenticated. Makes sense for user to request form to request password reset
            log.info "Request for password reset form"
        }
    }

    def requestEmail( ) {
        String emailAddress = params.emailAddress
        def reset = passwordResetService.requestEmail( emailAddress )
        if( reset ) {
            // It is reasonable to send a password reset email to the address
            // Also: the service has created a new reset token
            log.info "Will email ${reset}"
            // send email with link like https://app.aci.org/password/getNew?token=F362DCA6890E958.....
            [
                emailAddress: emailAddress,
                expires: reset.expiryTime
            ]
        } else {
            log.info "Rejecting request for ${emailAddress}"
            redirect action:'index'
        }
    }

/*
requestEmail
    IF ALL OKAY THEN
        the GSP displays
            text about checking email for you@someplace.ca
            you have X hours
            Close tab button
    ELSE
        display the index form with warning msg: Email address is not valid
    ENDIF
getNew
    The user has clicked on the URL we sent in the email (we hope)
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
    reset.gsp offers
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
