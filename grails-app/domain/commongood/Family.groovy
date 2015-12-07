package commongood

class Family {
    Location location
    String familyName
    Person primaryMember // Person to contact
    Date initialInterviewDate

    Person interviewer // Block Connector

    Boolean participateInInterview
    Boolean permissionToContact

    Date dateCreated
    Date lastUpdated

    static hasMany = [ members:Person ]

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
