package commongood

class PasswordReset {
    String token
    String emailAddress
    Date expiryTime
    Boolean expired
    Boolean successful

    Date dateCreated
    Date lastUpdated
    
    def getLogString( ) {
        return "PasswordReset ${id} ${emailAddress}"
    }
}
