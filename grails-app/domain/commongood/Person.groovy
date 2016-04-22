package commongood

class Person {
    Family family
    String firstNames
    String lastName
    Integer birthYear
    Boolean birthYearIsEstimated
    String emailAddress
    String phoneNumber
    String note
    Integer orderWithinFamily
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
    String hashedPassword

    Date dateCreated
    Date lastUpdated

    static hasMany = [ answers:Answer, privileges:DomainAuthorization ]

    Person( ) {
        appUser = Boolean.FALSE
        note = ''
    }

    def getFullName( ) {
        return firstNames + ' ' + lastName
    }

    def getLogName( ) {
        return "${firstNames} ${lastName} ${id}"
    }

    static constraints = {
        hashedPassword nullable: true, size: 1..900
        birthYearIsEstimated defaultValue: "FALSE", nullable: true
    }
}
