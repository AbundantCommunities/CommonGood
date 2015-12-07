package commongood

class Neighbourhood {
    String name
    String Logo // Not sure how we will store this image

    Date dateCreated
    Date lastUpdated

    static hasMany = [ blocks:Block ]

    static constraints = {
        logo nullable: true
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
