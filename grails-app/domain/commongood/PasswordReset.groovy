package commongood

class PasswordReset {
    String token
    String state  // TODO Use enum for state
/*
ACTIVE Active
USED   user successfully used it to reset her password
KILLED the administrator or the application retired it for some "logical reason" (!)
 */
    String emailAddress
    Date expiryTime

    Date dateCreated
    Date lastUpdated

    String toString( ) {
        // Useful for writing to log files
        return "PasswordReset ${id} ${state} ${expiryTime} ${emailAddress}"
    }
}
