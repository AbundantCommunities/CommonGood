package commongood

import grails.transaction.Transactional

@Transactional
class DomainAuthorizationService {
    /**
     * For a given block in a given neighbourhood, find the people who might
     * have interviewed a resident of that block. That will be the block's
     * connectors plus the neighourhood's connectors.
     * 
     * If the caller knows the currentInterviewerId (person id of the interviewer)
     * then our result will highlight that person (default entry in map is true).
     * 
     * @return List of [ id:personId, fullName:personFullName, default:thisPersonAlreadySelected ]
    */
    def getPossibleInterviewers( neighbourhoodId, blockId, currentInterviewerId ) {
        // TODO Would code be cleaner if caller passed in Block instead of nh & blk ids?
        Integer iNeighbourhoodId = neighbourhoodId
        Integer iBlockId = blockId

        def result = [ ]

        // Who are the neighbourhood connectors?
        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.NEIGHBOURHOOD, , iNeighbourhoodId ])

        das.each {
            // each result row found above has a list like [ DomainAuthorization, Person ]
            def thisOne = (it[1].id == currentInterviewerId) ? 'true' : 'false'
            result << [ id: it[1].id, fullName:it[1].fullName, 'default':thisOne ]
        }

        // Who are the block connectors?
        das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.BLOCK, , iBlockId ])

        das.each {
            def thisOne = (it[1].id == currentInterviewerId) ? 'true' : 'false'
            result << [ id: it[1].id, fullName:it[1].fullName, 'default':thisOne ]
        }

        if( currentInterviewerId ) {
            // It is possible that result does not contain currentInterviewerId
            def findResult = result.find{ it.id == currentInterviewerId }
            println "currentInterviewerId is non null; find result is ${findResult}"
            if( !findResult ) {
                def interviewer = Person.get( currentInterviewerId )
                result << [ id:currentInterviewerId, fullName:interviewer.fullName, 'default':true ]
            }
        } else {
            println "currentInterviewerId is null"
        }

        println "Possible Interviewers are ${result}"
        return result
    }
    
    def getPossibleInterviewers( neighbourhoodId, blockId ) {
        return getPossibleInterviewers( neighbourhoodId, blockId, null )
    }
}