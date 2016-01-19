package commongood

class Family {
    Address address
    Person interviewer // Block Connector

    String name
    Date interviewDate
    Integer orderWithinAddress
    Boolean participateInInterview
    Boolean permissionToContact
    String note

    Date dateCreated
    Date lastUpdated

    static hasMany = [ members:Person ]

    static constraints = {
        interviewer nullable: true
        interviewDate nullable: true
    }
}
