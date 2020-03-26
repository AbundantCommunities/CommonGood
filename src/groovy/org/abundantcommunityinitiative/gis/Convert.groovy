package org.abundantcommunityinitiative.gis

import groovy.json.JsonSlurper
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.io.WKTReader
import org.locationtech.jts.io.WKTWriter

class Convert {
    /**
     * Does what the name says EXCEPT it returns an empty string if passed
     * an empty array (in JSON this is "[]")
     */
    static jsonBoundaryToLinearRingAsWKT( String json ) {
        def jsonParser = new JsonSlurper( )
        def boundary = jsonParser.parseText( json ) // an ArrayList object
        if( boundary.size() == 0 ) {
            return ''
        } else {
            Coordinate[] coordinates = new Coordinate[0]
            for (vertex in boundary) {
                coordinates += new Coordinate(vertex[0], vertex[1])
            }
            coordinates += coordinates[0]

            def factory = new GeometryFactory()
            def linearRing = factory.createLinearRing(coordinates)
            def stringifier = new WKTWriter()
            return stringifier.write(linearRing)
        }
    }

    /**
     * Convert a WKT string that should be a simple Polygon (or, even better,
     * a LinearRing) to an array of JTS Coordinate objects.
     *
     * @param String like "MULTIPOLYGON (((-113.474414620273 53.532619638549,-113.474149921333 53.5326766290234, ..."
     * @return Coordinate[ ]
     */
    static Coordinate[ ] parseCoordinates( String wktString ) {
        def geomReader = new WKTReader()
        def geom = geomReader.read( wktString )
        return geom.getCoordinates( )
    }
}
