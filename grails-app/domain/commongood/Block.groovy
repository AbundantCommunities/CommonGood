package commongood

class Block {
    String code
    String description
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    Date dateCreated
    Date lastUpdated

    static hasMany = [ addresses:Address ]
    
    String getDisplayName( ) {
        "(${code}) ${description}"
    }
}
