package commongood

class Block {
    String code
    String name
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    Date dateCreated
    Date lastUpdated

    static hasMany = [ locations:Location ]

    static constraints = {
        name nullable: true
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
