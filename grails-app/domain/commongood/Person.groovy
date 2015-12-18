package commongood

class Person {
    Family family // Can be null if this person is simply an app user
    String firstNames
    String lastName
    Integer birthYear
    String emailAddress
    String phoneNumber
    Integer orderWithinFamily // first in order is our primary contact
    /*
    If appUser then
        if passwordHash nonzero then
            this person has chosen a password
        else
            this person has not replied to email invitation
    else
        passwordHash should be zero
    */
    Boolean appUser
    Integer passwordHash

    Date dateCreated
    Date lastUpdated

    static hasMany = [ answers:Answer, privileges:DomainAuthorization ]
    
    def getFullName( ) {
        return firstNames + ' ' + lastName
    }

    static constraints = {
        family nullable: true
    }
}
