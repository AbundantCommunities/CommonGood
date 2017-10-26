package commongood

class PasswordController {
/*
ALL ACTIONS SHOULD
    allow anonymous requests
    Barf if user is logged in
index simply renders reset password form with
    (if we came from requestReset with a warning then MUST display email address in appropriate control)
    Email Address (ideally would display the same email address as the login page)
    Submit button (perhaps "Request Password Reset"?)
    submits to the requestReset closure
requestReset
    (note the following 3 checks are also performed in reset action)
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
