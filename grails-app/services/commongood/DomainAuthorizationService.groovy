package commongood

import grails.transaction.Transactional
import org.abundantcommunityinitiative.commongood.Authorization

@Transactional
class DomainAuthorizationService {

    /*
     * Remove a given person+block pairing from DomainAuthorization
     */
    def deauthorizeBlockConnector( personId, blockId ) {
        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=? and da.person.id=?",
                    [ DomainAuthorization.BLOCK, blockId, personId ])

        if( das.size() == 0 ) {
            log.warn( "No DomainAuthorization rows found for person ${personId} and block ${blockId}")
        } else if( das.size() > 1 ) {
            log.warn( "${das.size()} DomainAuthorization rows found for person ${personId} and block ${blockId}")
        }

        das.each{
            it[0].delete( flush:true )
        }
    }

    def getForPerson( person ) {
        log.info "Get Authorization for ${person.logName}"

        def da = DomainAuthorization.findAll( "from DomainAuthorization da where da.person.id=?", [ person.id ] )

        if( da.size() == 0 ) {
            log.warn( "No DA rows found for ${person.fullName}" )

        } else if( da.size() > 1 ) {
            log.warn( "${da.size()} DA rows found for ${person.fullName}" )
        
        } else {
            // Is the DA for a Neighbourhood or a Block?
            def domAuth = da[0]
            switch( domAuth.domainCode ) {
                case DomainAuthorization.NEIGHBOURHOOD:
                    return Authorization.getForNeighbourhood( domAuth.domainKey )

                case DomainAuthorization.BLOCK:
                    return Authorization.getForBlock( domAuth.domainKey )

                default:
                    log.warn "Did not understand domainCode ${domAuth.domainCode}"
            }
        }
        return null // Failed to find valid DomainAuthorization configuration for person
    }

    /**
     * Return the list of Person who have DomainAuthorization entries for a given block.
    */
    def getBlockConnectors( blockId ) {

        // TODO Sort by new orderWithinDomain column !!
        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.BLOCK, blockId ])

        def result = [ ]
        das.each {
            result << it[1]
        }

        return result
    }

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
        def result = [ ]

        // Who are the neighbourhood connectors?
        def das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.NEIGHBOURHOOD, neighbourhoodId ])

        das.each {
            // each result row found above has a list like [ DomainAuthorization, Person ]
            def thisOne = (it[1].id == currentInterviewerId) ? 'true' : 'false'
            result << [ id: it[1].id, fullName:it[1].fullName, 'default':thisOne ]
        }

        // Who are the block connectors?
        das = DomainAuthorization.findAll("from DomainAuthorization da join da.person where da.domainCode=? and da.domainKey=?",
                    [ DomainAuthorization.BLOCK, blockId ])

        das.each {
            def thisOne = (it[1].id == currentInterviewerId) ? 'true' : 'false'
            result << [ id: it[1].id, fullName:it[1].fullName, 'default':thisOne ]
        }

        if( currentInterviewerId ) {
            // It is possible that result does not contain currentInterviewerId
            def findResult = result.find{ it.id == currentInterviewerId }
            log.debug "currentInterviewerId is non null; find result is ${findResult}"
            if( !findResult ) {
                def interviewer = Person.get( currentInterviewerId )
                result << [ id:currentInterviewerId, fullName:interviewer.fullName, 'default':'true' ]
            }
        } else {
            log.debug "currentInterviewerId is null"
        }

        log.debug "Possible Interviewers are ${result}"
        return result
    }
    
    def getPossibleInterviewers( neighbourhoodId, blockId ) {
        return getPossibleInterviewers( neighbourhoodId, blockId, null )
    }
}
