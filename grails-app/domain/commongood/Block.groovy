package commongood

class Block {
    String code
    String description
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    String boundary  // A WKT string, like a MULTIPOLYGON

    Date dateCreated
    Date lastUpdated

    static hasMany = [ addresses:Address ]

    static constraints = {
        boundary nullable: true
    }

    static mapping = {
        boundary type: 'text'
    }
    
    String getDisplayName( ) {
        "(${code}) ${description}"
    }
}
