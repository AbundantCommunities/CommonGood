package commongood

class Person {
    Family family // Can be null if this person is simply an app user
    String lastName
    String firstNames
    String emailAddress
    Integer birthYear
    String phoneNumber
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

    static hasMany = [ answers:Answer ]

    static constraints = {
        family nullable: true
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
