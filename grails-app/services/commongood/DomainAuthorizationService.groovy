package commongood

import grails.transaction.Transactional

@Transactional
class DomainAuthorizationService {
    /**
     * For a given block in a given neighbourhood, find the people who might have
     * the right to interview someone. That will be the block's BCs and the neighnourhood's
     * NCs.
     * 
     * @return List of [ id:personId, fullName:personFullName ]
    */
    def getPossibleInterviewers( neighbourhoodId, blockId ) {
        Integer iNeighbourhoodId = neighbourhoodId
        Integer iBlockId = blockId

        def result = [ ]

        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.NEIGHBOURHOOD, , iNeighbourhoodId ])
        das.each {
            // each result row has a list like [ DomainAuthorization, Person ]
            result << [ id: it[1].id, fullName:it[1].fullName ]
        }

        das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.BLOCK, , iBlockId ])
        das.each {
            result << [ id: it[1].id, fullName:it[1].fullName ]
        }

        return result
    }
}
