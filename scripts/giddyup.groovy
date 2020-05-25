/*
 * Define ourLat & ourLon for a point in a YEG neighbourhood.
 * Open and read the boundaries of YEG's neighbourhoods.
 * Announce which neighbourhood contains ourLat & ourLon.
 */
@Grab('com.xlson.groovycsv:groovycsv:1.3')
import static com.xlson.groovycsv.CsvParser.parseCsv
import org.locationtech.jts.io.WKTReader

import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.geom.Geometry

import groovy.time.TimeCategory 
import groovy.time.TimeDuration

double ourLat
double ourLon

// West Meadowlark Park
ourLat = 53.5257363
ourLon = -113.6072145

// Cafe Bike
ourLat = 53.5226462
ourLon = -113.4691658

// The Orchards at Ellerslie
ourLat = 53.402374
ourLon = -113.4661818

// Sweet Grass
ourLat = 53.4630202
ourLon = -113.5275937

Coordinate myCoordinate = new Coordinate( ourLon, ourLat )
GeometryFactory factory = new GeometryFactory( )
Geometry ourPoint = factory.createPoint( myCoordinate )

def csvFile = new File('NEIGHBOURHOODS_SHAPE.csv')
// NAME,AREA_KM2,the_geom,NUMBER

def geomReader = new WKTReader()
def fastHoods = [ ]

csvFile.withReader{ reader ->
    def hoods = parseCsv( reader )
    for(hood in hoods) {
        def geom = geomReader.read( hood.the_geom )
        def envelope = geom.getEnvelopeInternal( )
        def minY = envelope.getMinY( )
        def minX = envelope.getMinX( )
        def maxY = envelope.getMaxY( )
        def maxX = envelope.getMaxX( )
        fastHoods << [ name:hood.NAME, boundary:geom, minY:minY, minX:minX, maxY:maxY, maxX:maxX ]
    }
}

def start = new Date( )
fastHoods.each {
    if( ourLat >= it.minY && ourLat <= it.maxY && ourLon >= it.minX && ourLon <= it.maxX ) {
        println "Box candidate: ${it.name}"
        if( it.boundary.contains(ourPoint) ) {
            println "Am I in ${it.name}?"
        }
    }
}

def stop = new Date( )
TimeDuration td = TimeCategory.minus( stop, start )
println "Took ${td} to search all neighbourhoods"
