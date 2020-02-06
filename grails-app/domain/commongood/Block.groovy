package commongood

class Block {
    String code
    String description
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    // The centre of this block
    BigDecimal centreLatitude  // in degrees; negative is south of equator
    BigDecimal centreLongitude  // in degrees; negative is east of Greenwich
    String boundary  // A WKT string, like a MULTIPOLYGON

    Date dateCreated
    Date lastUpdated

    static hasMany = [ addresses:Address ]

    static constraints = {
        // Scale is 5 because 0.00001 degrees latitude is around 1 metre.
        // One metre is close enough for our purposes.
        centreLatitude  nullable: true, scale: 5
        centreLongitude nullable: true, scale: 5
        boundary nullable: true
    }

    static mapping = {
        centreLatitude  defaultValue: 0.0
        centreLongitude defaultValue: 0.0
        boundary type: 'text'
    }
    
    String getDisplayName( ) {
        "(${code}) ${description}"
    }
}
