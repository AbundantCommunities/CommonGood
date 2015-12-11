package commongood

class DomainAuthorization {
    public static String APPLICATION = "A"
    public static String NEIGHBOURHOOD = "N"
    public static String BLOCK = "B"
    
    Integer personId
    String domainCode // A, N, B → Application Administrator, NeighbourHood Connector, Block Connector
    Integer domainKey // domainCode: A means domainKey is null, N means key is neighbourhood.id, B means block.id

    Date dateCreated
    Date lastUpdated

    static constraints = {
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
