package commongood

class DomainAuthorization {

    Integer personId
    String domainCode // A, N, B → Admin, NeighbourHood Connector, Block Connector
    Integer domainKey // roleCode: A → null, N → FK to neighbourhood, B → FK to block

    Date dateCreated
    Date lastUpdated

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
