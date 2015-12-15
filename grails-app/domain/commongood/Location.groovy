package commongood

// TODO Rename Location to Address
// |-----> Consider effect on Block and Family,
class Location {
    Block block
    Integer orderWithinBlock
    /*
    We need to control or guide the nature of the address entered.
    When we implement GIS features this may be our goal:
    officialAddress + Some Suffix yields a string that unambiguously
    specifies the building to Google Maps or Canada Post.
    */
    String officialAddress // Official because postal service recognizes it
    String note

    Date dateCreated
    Date lastUpdated

    // In some neighbourhoods locations have a single Family but not all.
    static hasMany = [ families:Family ]

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
