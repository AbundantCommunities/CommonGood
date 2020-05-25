/*
 * For each neighbourhood, find the adjacent neighbourhoods.
 */
@Grab('com.xlson.groovycsv:groovycsv:1.1')
import static com.xlson.groovycsv.CsvParser.parseCsv

import org.locationtech.jts.io.WKTReader
import org.locationtech.jts.geom.Coordinate

def csvFile = new File('NEIGHBOURHOODS_SHAPE.csv')
// NAME,AREA_KM2,the_geom,NUMBER

def geomReader = new WKTReader()

def allHoods = [ ]

csvFile.withReader{ reader ->
    def hoods = parseCsv( reader )
    for( hood in hoods ) {
        def boundary = geomReader.read( hood.the_geom )
        Coordinate[ ] bPoints = boundary.getCoordinates( )
        allHoods << [ name:hood.NAME, boundary:bPoints ]
    }
}

while( allHoods.size() > 0 ) {
    def thisHood = allHoods.remove( 0 )
    println "Processing ${thisHood.name}"
    allHoods.each {
        def testHood = it
        def match = null
        thisHood.boundary.each {
            if( it in testHood.boundary ) {
                match = testHood.name
            }
        }
        if( match ) {
            println "    ${match} is adjacent"
        }
    }
}
