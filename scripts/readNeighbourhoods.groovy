/*
 * Learning JTS Topology Suite.
 * Define ourLat & ourLon for a point in a YEG neighbourhood.
 * Open and read the boundaries of YEG's neighbourhoods.
 * Announce which neighbourhood contained ourLat & ourLon.
 */
@Grab('com.xlson.groovycsv:groovycsv:1.1')
import static com.xlson.groovycsv.CsvParser.parseCsv
import org.locationtech.jts.io.WKTReader

import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.locationtech.jts.geom.Geometry

import groovy.time.TimeCategory 
import groovy.time.TimeDuration

// We will tell the user in what neighbourhood these coordinates exist
// Answer = Bonnie Doon
def ourLat = 53.5257363
def ourLon = -113.6072145

Coordinate myCoordinate = new Coordinate( ourLon, ourLat )
GeometryFactory factory = new GeometryFactory( )
Geometry myPoint = factory.createPoint( myCoordinate )

def csvFile = new File('NEIGHBOURHOODS_SHAPE.csv')
// NAME,AREA_KM2,the_geom,NUMBER

def geomReader = new WKTReader()

csvFile.withReader{ reader ->
    def hoods = parseCsv( reader )
    def start = new Date( )
    for(hood in hoods) {
        def geom = geomReader.read( hood.the_geom )
        if( geom.contains(myPoint) ) {
            println "Am I in ${hood.NAME}?"
        }
    }
    def stop = new Date( )
    TimeDuration td = TimeCategory.minus( stop, start )
    println "Took ${td} to search all neighbourhoods"
}
