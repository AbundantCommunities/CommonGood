package org.abundantcommunityinitiative.gis

import groovy.json.JsonSlurper
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.io.WKTWriter

class Convert {
    static jsonBoundaryToLinearRingAsWKT( String json ) {
        def jsonParser = new JsonSlurper( )
        def boundary = jsonParser.parseText( json )

        Coordinate[ ] coordinates = new Coordinate[ 0 ]
        for( vertex in boundary ) {
            coordinates += new Coordinate( vertex[0], vertex[1] )
        }
        coordinates += coordinates[0]

        def factory = new GeometryFactory( )
        def linearRing = factory.createLinearRing( coordinates )
        def stringifier = new WKTWriter( )
        return stringifier.write( linearRing )
    }
}
