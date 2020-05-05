package commongood

import org.abundantcommunityinitiative.gis.Convert
import org.abundantcommunityinitiative.gis.LatLon

class Block {
    String code
    String description
    Neighbourhood neighbourhood
    Integer orderWithinNeighbourhood

    String boundary  // A WKT string, like a MULTIPOLYGON

    Date dateCreated
    Date lastUpdated

    // If you name this fn getLatLon, IDEs may complain
    LatLon latLon( ) {
        if( boundary == null || boundary.allWhitespace ) {
            new LatLon( )  // Creates an 'unknown' LatLon
        } else {
            Convert.calculateCentroid( boundary )
        }
    }

    static hasMany = [ addresses:Address ]
    static transients = [ 'displayName', 'latLon' ]

    static constraints = {
        boundary nullable: true
    }

    static mapping = {
        boundary type: 'text'
    }

    String getDisplayName( ) {
        "Block ${code}:${description}"
    }
}
