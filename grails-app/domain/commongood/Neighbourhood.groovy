package commongood

class Neighbourhood {
    String name
    String featureFlags // like "featureA featureK featureW"

    Boolean acceptAnonymousRequests // allow Connect Me requests?
    Boolean emailAnonymousRequests
    String disclosureKey // disclose anonymous info on our public pages?

    String boundary  // A WKT string, like a MULTIPOLYGON

    Date dateCreated
    Date lastUpdated

    static hasMany = [ blocks:Block ]

    static mapping = {
        featureFlags defaultValue: "''"
        acceptAnonymousRequests defaultValue: "TRUE"
        emailAnonymousRequests defaultValue: "TRUE"
        boundary type: 'text'
    }

    static constraints = {
        boundary nullable: true
    }

    public Boolean hasFeature( feature ) {
        featureFlags.contains( feature )
    }

    public void createDisclosureKey( ) {
        if( disclosureKey ) {
            throw new RuntimeException("Disclosure key exists")
        } else {
            // Create string of 40 random hex digits
            disclosureKey = org.abundantcommunityinitiative.commongood.handy.TokenGenerator.get( 40 )
        }
        
    }

    public String toString( ) {
        return "NH ${id} ${name}"
    }
}
