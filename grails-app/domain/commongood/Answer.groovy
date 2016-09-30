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

    // ALTER TABLE answer ALTER text TYPE VARCHAR(1000);
    static constraints = {
        text( maxSize:1000 )
    }

    Date dateCreated
    Date lastUpdated
}
