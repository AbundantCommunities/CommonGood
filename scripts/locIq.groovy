@Grab('io.github.http-builder-ng:http-builder-ng-okhttp:1.0.4')
import LocationIq.ApiException
import com.locationiq.client.model.Location
import com.locationiq.client.api.SearchApi
import LocationIq.Configuration
import LocationIq.ApiClient
import LocationIq.auth.ApiKeyAuth

// API Reference for Search at https://github.com/location-iq/locationiq-java-client/blob/master/docs/SearchApi.md
// All APIs at https://github.com/location-iq/locationiq-java-client/tree/master/docs

String accessToken = System.getenv('LOCIQ_ACCESS_TOKEN')
if( accessToken ) {
    println "Picked up LOCIQ_ACCESS_TOKEN from system environment"
} else {
    throw new RuntimeException('Missing environment variable LOCIQ_ACCESS_TOKEN')
}

ApiClient defaultClient = Configuration.getDefaultApiClient( )
ApiKeyAuth key = defaultClient.getAuthentication("key")
key.setApiKey( accessToken );

SearchApi api = new SearchApi( )

String q = '9301 93 St NW,Edmonton,AB,Canada'
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
List<Location> response = api.search(q, format, normalizecity, addressdetails, viewbox, bounded, limit, acceptLanguage, countrycodes, namedetails, dedupe, extratags, statecode)

for( locn in response ) {
    println( "FOUND ${locn}" )
}
