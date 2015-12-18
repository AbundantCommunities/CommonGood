package commongood

class Block {
    String code
    String description
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    Date dateCreated
    Date lastUpdated

    static hasMany = [ addresses:Address ]

//    static constraints = {
//        dateCreated nullable: true
//        lastUpdated nullable: true
//    }
}
