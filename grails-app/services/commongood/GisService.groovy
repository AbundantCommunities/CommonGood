package commongood

import grails.transaction.Transactional
import org.abundantcommunityinitiative.gis.Convert
import org.locationtech.jts.geom.Coordinate

@Transactional
class GisService {

    static public String mapboxAccessToken = System.getenv("CG_MAPBOX_ACCESS_TOKEN")
    static {
        if( !mapboxAccessToken ) {
            throw new RuntimeException("Missing environment variable CG_MAPBOX_ACCESS_TOKEN")
        }
    }

    def getBoundaryCoordinates( Block block ) {
        if( block.boundary != null && block.boundary.trim().length() > 0 ) {
            return [ type:'block', coordinates: Convert.parseCoordinates( block.boundary ) ]
        } else {
            // Perhaps the block's neighbourhood has a boundary...
            if( block.neighbourhood.boundary != null && block.neighbourhood.boundary.trim().length() > 0 ) {
                return [ type:'neighbourhood', coordinates: Convert.parseCoordinates( block.neighbourhood.boundary ) ]
            } else {
                // Return an empty array
                return  [ type:'nada', coordinates: new Coordinate[ 0 ] ]
            }
        }
    }

    def getBoundaryCoordinates( Neighbourhood neighbourhood ) {
        if( neighbourhood.boundary != null && neighbourhood.boundary.trim().length() > 0 ) {
            return [ type:'neighbourhood', coordinates: Convert.parseCoordinates( neighbourhood.boundary ) ]
        } else {
            // Return an empty array
            return  [ type:'nada', coordinates: new Coordinate[ 0 ] ]
        }
    }
}
