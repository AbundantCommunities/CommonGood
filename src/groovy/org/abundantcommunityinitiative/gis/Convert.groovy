package org.abundantcommunityinitiative.gis

import groovy.json.JsonSlurper
import org.locationtech.jts.algorithm.Centroid
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.io.WKTReader
import org.locationtech.jts.io.WKTWriter

class Convert {
    static Coordinate toCoordinate(Location ll ) {
        if( ll.unknown ) {
            throw new java.lang.IllegalArgumentException('Location is UNKNOWN')
        } else {
            new Coordinate(ll.longitude, ll.latitude)
        }
    }

    /**
     * A centroid is the geometric centre of an object.
     * @param wktString A String holding a WKT representation of a boundary
     * @return Location representing the centre (centroid)
     */
    static Location calculateCentroid(String wktString ) {
        def geomReader = new WKTReader()
        def geom = geomReader.read( wktString )
        Coordinate centre = Centroid.getCentroid( geom )
        new Location( centre.getY(), centre.getX() )
    }

    /**
     * Does what the name says EXCEPT it returns an empty string if passed null or
     * and empty string or a string of all whitespace or an empty array (in JSON,
     * "[]" is an empty array)
     */
    static jsonBoundaryToLinearRingAsWKT( String json ) {
        if( json == null || json.trim().isEmpty() ) {
            return ''
        } else {
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
