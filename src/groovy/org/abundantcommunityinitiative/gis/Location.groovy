package org.abundantcommunityinitiative.gis

/**
 * A Location is a lightweight object holding a latitude and a longitude (unless its
 * unknown property is True). Similar to JTS's Coordinate class, but allows us to
 * minimize the number of references to JTS types within CommonGood code.
 */
class Location {
    BigDecimal latitude
    BigDecimal longitude
    Boolean unknown  // if True than lat & lon are UNKNOWN

    // Note that JTS's Coordinate constructor wants lon first, then lat.
    Location( double lat, double lon ) {
        latitude = lat
        longitude = lon
        latitude = latitude.setScale( 5, BigDecimal.ROUND_HALF_EVEN )
        longitude = longitude.setScale( 5, BigDecimal.ROUND_HALF_EVEN )
        unknown = Boolean.FALSE
    }

    // Note that JTS's Coordinate constructor wants lon first, then lat.
    Location(BigDecimal lat, BigDecimal lon ) {
        latitude = lat
        longitude = lon
        unknown = Boolean.FALSE
    }

    Location( ) {
        unknown = Boolean.TRUE
    }

    String toString( ) {
        if( unknown ) {
            'Location(unknown)'
        } else {
            "Location(${latitude},${longitude})"
        }
    }
}
