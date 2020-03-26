package commongood

import grails.transaction.Transactional
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.io.WKTReader

@Transactional
class GisService {

    def getBoundaryCoordinates( Block block ) {
        if( block.boundary != null && block.boundary.trim().length() > 0 ) {
            log.info('Found block boundary')
            return [ type:'block', coordinates: parseCoordinates( block.boundary ) ]
        } else {
            // Perhaps the block's neighbourhood has a boundary defined...
            if( block.neighbourhood.boundary != null && block.neighbourhood.boundary.trim().length() > 0 ) {
                log.info('Found neighbourhood boundary')
                return [ type:'neighbourhood', coordinates: parseCoordinates( block.neighbourhood.boundary ) ]
            } else {
                // Return an empty array
                log.info('Found no boundary')
                return  [ type:'nada', coordinates: new Coordinate[ 0 ] ]
            }
        }
    }

    /**
     * Convert a WKT string that should be a simple polygon to an array
     * of JTS Coordinate objects.
     *
     * @param String like "MULTIPOLYGON (((-113.474414620273 53.532619638549,-113.474149921333 53.5326766290234, ..."
     * @return Coordinate[ ]
     */
    Coordinate[ ] parseCoordinates( String bString ) {
        def geomReader = new WKTReader()
        def geom = geomReader.read( bString )
        return geom.getCoordinates( )
    }
}
