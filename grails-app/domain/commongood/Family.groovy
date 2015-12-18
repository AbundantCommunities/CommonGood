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

//    static mapping = {
//        orderWithinAddress defaultValue: "100"
//        note defaultValue: "'note'"
//        participateInInterview defaultValue: "TRUE"
//        note defaultValue: "TRUE"
//    }

//    static constraints = {
//        address nullable: true
//        dateCreated nullable: true
//        lastUpdated nullable: true
//    }
}
