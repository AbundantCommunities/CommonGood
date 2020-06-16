/*
 * Define ourLat & ourLon for a point in a YEG neighbourhood.
 * Open and read the boundaries of YEG's neighbourhoods.
 * Announce which neighbourhood contains ourLat & ourLon.
 */
//@Grab('com.xlson.groovycsv:groovycsv:1.3')
import static com.xlson.groovycsv.CsvParser.parseCsv

import org.locationtech.jts.io.WKTReader
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.geom.Geometry

import groovy.time.TimeCategory 
import groovy.time.TimeDuration

// STEP 1 -- create ourPoint, a JTS point in 2d space

double ourLat
double ourLon

// Cafe Bike
ourLat = 53.5226462
ourLon = -113.4691658

// The Orchards at Ellerslie
ourLat = 53.402374
ourLon = -113.4661818

// Sweet Grass
ourLat = 53.4630202
ourLon = -113.5275937

// West Meadowlark Park
ourLat = 53.5257363
ourLon = -113.6072145

Coordinate myCoordinate = new Coordinate( ourLon, ourLat )
GeometryFactory factory = new GeometryFactory( )
Geometry ourPoint = factory.createPoint( myCoordinate )


// STEP 2 -- Input all of Edmonton's neighbourhoods into an array called hoods.
// For each neighbourhood, we precalculate some useful objects.

def csvFile = new File('NEIGHBOURHOODS_SHAPE.csv')
// NAME,AREA_KM2,the_geom,NUMBER

def geomReader = new WKTReader()
def hoods = [ ]

csvFile.withReader{ reader ->
    def yegHoods = parseCsv( reader )
    for(hood in yegHoods) {
        // Parse the boundary (a WKT string) and transform it into a JTS structure, geom.
        def geom = geomReader.read( hood.the_geom )

        // Envelope: the smallest rectangle that contains the neighbourhood and whose N and S sides
        // are parallel to lines of latitude
        def envelope = geom.getEnvelopeInternal( )
        def minY = envelope.getMinY( )
        def minX = envelope.getMinX( )
        def maxY = envelope.getMaxY( )
        def maxX = envelope.getMaxX( )
        hoods << [ name:hood.NAME, boundary:geom, minY:minY, minX:minX, maxY:maxY, maxX:maxX ]
    }
}


// STEP 3 -- Linear search of hoods to see which one contains ourPoint

def start = new Date( )
hoods.each {
    // These 4 double precision comparisons fast compared to JTS's contains method
    if( ourLat >= it.minY && ourLat <= it.maxY && ourLon >= it.minX && ourLon <= it.maxX ) {
        // This neighbourhood *might* contain ourPoint.
        if( it.boundary.contains(ourPoint) ) {
            // This neighbourhood *definitely* contains ourPoint.
            println "Am I in ${it.name}?"
        }
    }
}

def stop = new Date( )
TimeDuration td = TimeCategory.minus( stop, start )
println "Took ${td} to search all neighbourhoods"
