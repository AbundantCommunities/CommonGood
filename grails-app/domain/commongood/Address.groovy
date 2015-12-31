package commongood

class Address {
    Block block
    String text // In YEG this is like '9355 93 Ave'
    String note // Anything peculiar about accessing this address?
    Integer orderWithinBlock

    Date dateCreated
    Date lastUpdated

    // In some neighbourhoods addresses have a single Family but not all.
    static hasMany = [ families:Family ]
}
