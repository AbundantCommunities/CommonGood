/*
 * Find Bonnie Doon's adjacent neighbourhoods.
 */
@Grab('com.xlson.groovycsv:groovycsv:1.1')
import static com.xlson.groovycsv.CsvParser.parseCsv

import org.locationtech.jts.io.WKTReader
import org.locationtech.jts.geom.Coordinate

def csvFile = new File('NEIGHBOURHOODS_SHAPE.csv')
// NAME,AREA_KM2,the_geom,NUMBER

def geomReader = new WKTReader()
Coordinate[ ] bdPoints = null

csvFile.withReader{ reader ->
    def hoods = parseCsv( reader )
    for( hood in hoods ) {
        def boundary = geomReader.read( hood.the_geom )
        if( hood.NAME == "Bonnie Doon" ) {
            bdPoints = boundary.getCoordinates( )
        }
    }
}

if( bdPoints == null ) {
    println 'WTF'
    return
}

csvFile.withReader{ reader ->
    def hoods = parseCsv( reader )
    for( hood in hoods ) {
        def boundary = geomReader.read( hood.the_geom )
        if( hood.NAME != "Bonnie Doon" ) {
            def thisHood = null
            Coordinate[ ] candidate = boundary.getCoordinates( )
            candidate.each{
                if( it in bdPoints ) {
                    thisHood = hood.NAME
                }
            }
            if( thisHood != null ) {
                println "${thisHood}"
            }
        }
    }
}
