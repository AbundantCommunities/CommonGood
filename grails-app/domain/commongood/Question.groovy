package commongood

class Question {
    String text
    Integer neighbourhoodId

    Date dateCreated
    Date lastUpdated

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
