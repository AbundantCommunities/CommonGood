package commongood

class Address {

    Block block
    String text // In YEG this is like '9355 93 Ave'
    String note // Ex: 'Basement apartment; door on north side'
    Integer orderWithinBlock

    BigDecimal latitude   // in degrees; negative is south of equator
    BigDecimal longitude  // in degrees; negative is west of Greenwich

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
    }
}
