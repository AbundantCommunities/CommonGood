package commongood

class Answer {
    Person person
    Question question
    String text // the actual answer text
    Boolean wouldLead // TODO Are wouldLead & wouldOrganize what we really need?
    Boolean wouldOrganize

    Date dateCreated
    Date lastUpdated

//    static constraints = {
//        question nullable: true
//        dateCreated nullable: true
//        lastUpdated nullable: true
//    }
}
