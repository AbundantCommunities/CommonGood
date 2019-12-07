@Grab('io.github.http-builder-ng:http-builder-ng-okhttp:1.0.4')
import static groovyx.net.http.HttpBuilder.configure
import groovy.sql.Sql
import groovy.json.JsonSlurper

def sql = Sql.newInstance('jdbc:postgresql://localhost/thehoods', 'myapp', 'sloj92GOM', 'org.postgresql.Driver')
def rows = sql.rows('SELECT a.id AS adr_id, a.text, gr.id AS gr_id FROM geolocate_request AS gr, address AS a WHERE a.id = gr.address_id ORDER BY gr.id')

println "Retrieved ${rows.size()} addresses from Geolocate queue"
def jsonParser = new JsonSlurper( )

def http = configure {
    request.uri = 'https://nominatim.openstreetmap.org'
}

rows.each{
    def address = it.text + " NW,Edmonton,AB,Canada"

    def responseContent = http.get {
        request.uri.path = '/search'
        request.uri.query = [format:'json', q:address]
    }

    def json = responseContent
    if( json.size() == 1 ) {
        if( (json[0].class=='building') || (json[0].class=='place') ) {
            println "Success: address ${it.adr_id}:${address} at ${json[0].lat}, ${json[0].lon}"

            sql.execute \
                'UPDATE address SET latitude=?, longitude=?, geolocate_state=? WHERE id=?', 
                [ new BigDecimal(json[0].lat), new BigDecimal(json[0].lon), 'S', it.adr_id ]

        } else {
            println "FAILED: 'class' is neither 'building' nor 'place' for ${it.adr_id}:${address}\n${json}"
            sql.execute \
                'UPDATE address SET geolocate_state=? WHERE id=?', [ 'F', it.adr_id ]
        }
    } else {
        println "FAILED: ${json.size()} nominatim item(s) returned for ${it.adr_id}:${address}\n${json}"
        sql.execute \
            'UPDATE address SET geolocate_state=? WHERE id=?', [ 'F', it.adr_id ]
    }

    sql.execute 'DELETE FROM geolocate_request WHERE id=?', [ it.gr_id ]

    sleep 10 * 1000
  }

println 'Normal exit for geolocate script'
