package commongood

class Question {
    Neighbourhood neighbourhood
    String code
    String text
    Integer orderWithinQuestionnaire
    String shortText

    static mapping = {
        shortText defaultValue: "'Short'"
    }

    Date dateCreated
    Date lastUpdated
}
