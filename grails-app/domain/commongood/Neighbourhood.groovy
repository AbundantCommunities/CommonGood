package commongood

class Neighbourhood {
    String name
    String Logo // Not sure how we will store this image

    Boolean acceptAnonymousRequests
    Boolean emailAnonymousRequests

    Date dateCreated
    Date lastUpdated

    static hasMany = [ blocks:Block ]

    static mapping = {
        acceptAnonymousRequests defaultValue: "TRUE"
        emailAnonymousRequests defaultValue: "TRUE"
    }

    static constraints = {
        logo nullable: true
    }
}
