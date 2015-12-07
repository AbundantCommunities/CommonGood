package commongood

class Response {
    Person person
    Integer questionCode // 1 to 7
    String response
    Boolean wouldLead
    Boolean wouldOrganize

    Date dateCreated
    Date lastUpdated

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
