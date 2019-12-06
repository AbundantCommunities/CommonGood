package commongood

class Address {

    // GeolocateState values
    // Ideally we would implement with an enum but that is messy in Grails 2.
    // We will wait till using Grails 3 or 4.
    public static final String GEOL_NONE      = ' ' // Probably a legacy address.
    public static final String GEOL_QUEUED    = 'Q' // We've submitted this Address to our geolocate service.
    public static final String GEOL_FAILED    = 'F' // The geolocate service failed to locate this.
    public static final String GEOL_SUCCEEDED = 'S' // The service successfully determined the Address's lat & long
    public static final String GEOL_USER      = 'U' // User determined lat & long using GUI.

    Block block
    String text // In YEG this is like '9355 93 Ave'
    String note // Ex: 'Basement apartment; door on north side'
    Integer orderWithinBlock

    BigDecimal latitude   // in degrees; negative is south of equator
    BigDecimal longitude  // in degrees; negative is west of Greenwich
    String geolocateState // the one-character code from GeolocateState

    Date dateCreated
    Date lastUpdated

    // In many neighbourhoods an Address has a single Family, but not all.
    static hasMany = [ families:Family ]

    static constraints = {
        latitude  min: new BigDecimal('-90'),  max: new BigDecimal('90'),  scale: 5
        longitude min: new BigDecimal('-180'), max: new BigDecimal('180'), scale: 5
    }

    static mapping = {
        latitude       defaultValue: "0.0"
        longitude      defaultValue: "0.0"
        geolocateState defaultValue: "' '"
    }
}
