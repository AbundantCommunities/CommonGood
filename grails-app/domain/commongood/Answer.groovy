package commongood

class Answer {
    Person person
    Question question
    String text
    Boolean wouldAssist
    String note

    static mapping = {
        wouldAssist defaultValue: "FALSE"
        note defaultValue: "''"
    }

    Date dateCreated
    Date lastUpdated
}
