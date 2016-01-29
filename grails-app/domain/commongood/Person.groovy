package commongood

class Person {
    Family family // Can be null if this person is simply an app user
    String firstNames
    String lastName
    Integer birthYear
    String emailAddress
    String phoneNumber
    String note
    Integer orderWithinFamily // first in order is our primary contact
    /*
    If appUser then
        if hashedPassword nonempty then
            this person has chosen a password
        else
            this person has not replied to email invitation
    else
        hashedPassword should be empty or null
    */
    Boolean appUser
    Integer passwordHash
    String hashedPassword

    Date dateCreated
    Date lastUpdated

    static hasMany = [ answers:Answer, privileges:DomainAuthorization ]

    Person( ) {
        appUser = Boolean.FALSE
        passwordHash = 0
        note = ''
    }

    def getFullName( ) {
        return firstNames + ' ' + lastName
    }

    static constraints = {
        // We can create a neighbourhood or block connector without identifying a family:
        family nullable: true
        hashedPassword nullable: true, size: 1..900
    }
}
