package commongood

/**
 * People who can authenticate (who can login to the webapp) need rights. This table gives
 * them rights. For example, if a person has a row in this table with domainCode "N" and
 * domainKey 123 then she has rights to the Neighbourhood whose id is 123.
*/
class DomainAuthorization {
    final static String APPLICATION = "A"
    final static String NEIGHBOURHOOD = "N"
    final static String BLOCK = "B"

    Person person
    String domainCode // A, N, B → Application Administrator, NeighbourHood Connector, Block Connector
    Integer orderWithinDomain
    Long domainKey // domainCode: A means domainKey is null, N means key is neighbourhood.id, B means block.id

    Date dateCreated
    Date lastUpdated
}
