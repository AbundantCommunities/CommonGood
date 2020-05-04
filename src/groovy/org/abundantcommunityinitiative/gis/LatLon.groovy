package org.abundantcommunityinitiative.gis

import sun.font.TrueTypeFont

/**
 * A LatLon is a lightweight object holding a latitude and a longitude (unless its
 * unknown property is True). Similar to JTS's Coordinate class, but allows us to
 * minimize the number of references to JTS types within CommonGood code.
 */
class LatLon {
    BigDecimal latitude
    BigDecimal longitude
    Boolean unknown  // if True than lat & lon are UNKNOWN

    // Note that JTS's Coordinate constructor wants lon first, then lat.
    LatLon( BigDecimal lat, BigDecimal lon ) {
        latitude = lat
        longitude = lon
        unknown = Boolean.FALSE
    }

    LatLon( ) {
        unknown = Boolean.TRUE
    }
}
