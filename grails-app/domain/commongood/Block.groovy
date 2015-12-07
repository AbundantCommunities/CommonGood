package commongood

class Block {
    String code
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    Date dateCreated
    Date lastUpdated

    static hasMany = [ locations:Location ]

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
