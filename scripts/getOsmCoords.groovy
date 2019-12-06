@Grab('io.github.http-builder-ng:http-builder-ng-okhttp:1.0.3')
import static groovyx.net.http.HttpBuilder.configure
import groovy.sql.Sql
import groovy.json.JsonSlurper

def sql = Sql.newInstance('jdbc:postgresql://localhost/thehoods', 'myapp', 'sloj92GOM', 'org.postgresql.Driver')
def rows = sql.rows('SELECT a.id, a.text FROM address AS a, block AS b WHERE a.block_id = b.id AND b.neighbourhood_id = 2000 ORDER BY a.id')
// sql.connection.close( )

println "Retrieved ${rows.size()} assets"
def jsonParser = new JsonSlurper( )

def http = configure {
    request.uri = 'https://nominatim.openstreetmap.org'
}

rows.each{
    def stAddress = it.text + " NW"
    if( stAddress.length() > 3 ) {
        if( stAddress.substring(stAddress.length()-2).equals('NW') ) {
            def plussed = stAddress.replaceAll(' ','+')
            def address = "${plussed},Edmonton,AB,Canada"

            def responseContent = http.get {
                request.uri.path = '/search'
                request.uri.query = [format:'json', q:address]
            }

            def json = responseContent
            if( json.size() == 1 ) {
                if( (json[0].class=='building') || (json[0].class=='place') ) {
                    println "${stAddress}, ${json[0].lat}, ${json[0].lon}"
                    // json[0].lat
                    
                    // UPDATE THE ADDRESS RECORD
                    sql.execute \
                        "UPDATE address SET latitude=?, longitude=?, geolocate_status=? WHERE id=?",
                        [ 1, 2, 3 ]
                    
                } else {
                    println "ERROR class is neither building nor place for ${it.id} ${stAddress}: ${json}"
                }
            } else {
                println "ERROR Not exactly one item for id ${it.id} ${stAddress}: ${json}"
            }
            sleep 12000

        } else {
            println "ERROR ${it.id} ${stAddress} does not end in NW"
        }
    } else {
        println "ERROR ${it.id} ${stAddress} too short"
    }
}

return
