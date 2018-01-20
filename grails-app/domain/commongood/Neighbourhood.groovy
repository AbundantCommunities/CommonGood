package commongood

class Neighbourhood {
    String name
    String Logo // Not sure how we will store this image

    Boolean acceptAnonymousRequests
    Boolean emailAnonymousRequests

    // The centre of this neighbourhood
    BigDecimal centreLatitude  // in degrees; negative is south of equator
    BigDecimal centreLongitude  // in degrees; negative is east of Greenwich

    Date dateCreated
    Date lastUpdated

    static hasMany = [ blocks:Block ]

    static mapping = {
        acceptAnonymousRequests defaultValue: "TRUE"
        emailAnonymousRequests defaultValue: "TRUE"
        centreLatitude  defaultValue: 0.0
        centreLongitude defaultValue: 0.0
    }

    static constraints = {
        logo nullable: true
        // Scale is 5 because 0.00001 degrees latitude is around 1 metre.
        // One metre is close enough for our purposes.
        centreLatitude  nullable: true, scale: 5
        centreLongitude nullable: true, scale: 5
    }
    
    public String toString( ) {
        return "Neighbourhood ${name}"
    }
}
