package commongood

import grails.transaction.Transactional

@Transactional
class DomainAuthorizationService {
    /**
     * For a given block in a given neighbourhood, find the people who might have
     * the right to interview someone. That will be the block's BCs and the neighnourhood's
     * NCs.
     * 
     * If the caller knows a previously selected interviewer (person) id, then pass that
     * in as currentInterviewerId -- we'll return a value of checked set to 'checked'.
     * 
     * @return List of [ id:personId, fullName:personFullName, checked:thisPersonAlreadySelected ]
    */
    def getPossibleInterviewers( neighbourhoodId, blockId, currentInterviewerId ) {
        Integer iNeighbourhoodId = neighbourhoodId
        Integer iBlockId = blockId

        def result = [ ]

        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.NEIGHBOURHOOD, , iNeighbourhoodId ])
        das.each {
            // each result row found above has a list like [ DomainAuthorization, Person ]
            def checked = (it[1].id == currentInterviewerId) ? 'checked' : ''
            result << [ id: it[1].id, fullName:it[1].fullName, checked:checked ]
        }

        das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.BLOCK, , iBlockId ])
        das.each {
            result << [ id: it[1].id, fullName:it[1].fullName ]
        }

        return result
    }
    
    def getPossibleInterviewers( neighbourhoodId, blockId ) {
        return getPossibleInterviewers( neighbourhoodId, blockId, null )
    }
}
