package commongood

class Answer {
    Person person
    Question question
    AnswerGroup answerGroup
    String text
    Boolean wouldAssist
    String note

    static mapping = {
        wouldAssist defaultValue: "FALSE"
        note defaultValue: "''"
    }

    // ALTER TABLE answer ALTER text TYPE VARCHAR(1000);
    static constraints = {
        answerGroup  nullable: true
        text( maxSize:1000 )
    }

    Date dateCreated
    Date lastUpdated
}
