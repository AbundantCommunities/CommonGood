package commongood

class Answer {
    Person person
    Question question
    String text
    Boolean wouldLead
    Boolean wouldOrganize
    Boolean wouldAssist

    static mapping = {
        wouldAssist defaultValue: "FALSE"
    }

    Date dateCreated
    Date lastUpdated
}
