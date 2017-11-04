package commongood

class PasswordReset {
    String token
    String state
    String emailAddress
    Date expiryTime
/*
ACTIVE Active
USED   user successfully used it to reset her password
STALE  the token became stale dated
KILLED the administrator or the application retired it for some "logical reason" (!)
 */
    Date dateCreated
    Date lastUpdated
    
    def getLogString( ) {
        return "PasswordReset ${id} ${state} ${expiryTime} ${emailAddress}"
    }
}
