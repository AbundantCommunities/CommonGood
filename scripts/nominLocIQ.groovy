import groovy.sql.Sql

import LocationIq.ApiException
import com.locationiq.client.model.Location
import com.locationiq.client.api.SearchApi
import LocationIq.Configuration
import LocationIq.ApiClient
import LocationIq.auth.ApiKeyAuth

/*
 * RUN: groovy -cp ../lib/locationiq-java-client-1.0.0.jar locIq.groovy
 * 
 * Connects to your local 'thehoods' database.
 * Reads all the address ids that are in geolocate_request.
 * For each address...
 *   Appends " NW,Edmonton,AB,Canada" to address.text
 *   Asks LocationIQ to geolocate the address
 *   If successful then save lat+long to address row
 *   Either way, update address.geolocate_state
 *   Delete the geolocate_request row
 *   Sleep
 * Log every address to standard out.
 * WARNING: No transaction control (IOW, could update an address and not delete the request).
 */

String accessToken = System.getenv('LOCIQ_ACCESS_TOKEN')
if( accessToken ) {
    println "Picked up LOCIQ_ACCESS_TOKEN from system environment"
} else {
    throw new RuntimeException('Missing environment variable LOCIQ_ACCESS_TOKEN')
}

// API Reference for Search at https://github.com/location-iq/locationiq-java-client/blob/master/docs/SearchApi.md
// All APIs at https://github.com/location-iq/locationiq-java-client/tree/master/docs

ApiClient defaultClient = Configuration.getDefaultApiClient( )
ApiKeyAuth key = defaultClient.getAuthentication("key")
key.setApiKey( accessToken );

SearchApi api = new SearchApi( )

String format = 'json'
Integer normalizecity = 0
Integer addressdetails = null
String viewbox = null
Integer bounded = null
Integer limit = null
String acceptLanguage = null
String countrycodes = null
Integer namedetails = null
Integer dedupe = null
Integer extratags = null
Integer statecode = null


def sql = Sql.newInstance('jdbc:postgresql://localhost/thehoods', 'myapp', 'sloj92GOM', 'org.postgresql.Driver')
def rows = sql.rows('SELECT a.id AS adr_id, a.text, gr.id AS gr_id FROM geolocate_request AS gr, address AS a WHERE a.id = gr.address_id ORDER BY gr.id')

println "Retrieved ${rows.size()} addresses from Geolocate queue"


rows.each{
    def q = it.text + " NW,Edmonton,AB,Canada"
    println "Locate ${q}"

    List<Location> response = api.search(q, format, normalizecity, addressdetails, viewbox, bounded, limit, acceptLanguage, countrycodes, namedetails, dedupe, extratags, statecode)

    if( response.size() == 1 ) {
        Location locn = response.get( 0 )
        println "    SUCCESS: ${it.adr_id}:${it.text} (${locn.osmType}) located at ${locn.lat}, ${locn.lon}"

        sql.execute \
            'UPDATE address SET latitude=?, longitude=?, geolocate_state=? WHERE id=?', 
            [ new BigDecimal(locn.lat), new BigDecimal(locn.lon), 'S', it.adr_id ]

    } else {
        println "    FAILURE: ${response.size()} item(s) returned for ${it.adr_id}:${it.text}"
        sql.execute \
            'UPDATE address SET geolocate_state=? WHERE id=?',
            [ 'F', it.adr_id ]
    }

    sql.execute \
        'DELETE FROM geolocate_request WHERE id=?',
        [ it.gr_id ]

    sleep 1500  // milliseconds
  }

println 'Normal exit for script'
