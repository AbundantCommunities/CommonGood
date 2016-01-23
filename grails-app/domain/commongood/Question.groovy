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

    def String getShortHeader( ) {
        return code + '. ' + shortText
    }

    def String getLongHeader( ) {
        return code + '. ' + text
    }
}
