package commongood

class Answer {
    Person person
    Integer questionCode // 1 to 6
    String text // the actual answer text
    Boolean wouldLead
    Boolean wouldOrganize

    Date dateCreated
    Date lastUpdated

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
