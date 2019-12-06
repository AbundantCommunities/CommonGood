package commongood

/**
 * When ordered by the id this table is a queue of work for our geolocation service.
 */
class GeolocateRequest {

    Address address  // please look up this address's latitude and longitude
    Date dateCreated // date & time
}
