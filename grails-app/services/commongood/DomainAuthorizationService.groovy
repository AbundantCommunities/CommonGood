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

    /**
     * For a given Person, we find their "best" DomainAuthorization row, to discover
     * what Neighbourhood's or Block's data they can read/write. At this time in the
     * evolution of CommonGood, "best" works like this: if we find a domainCode of 'N'
     * then we return authorization for that neighbourhood. If we don't find an 'N'
     * then we select one of the DA rows.
     * 
     * We hear you excliaming, "ONE of the DA rows"?! Yes, we are not yet prepared
     * to handle multiple 'B' domainCodes for one person (unless that person has an
     * 'N' DA).
     * 
     * Lastly, we do not return the selected DomainAuthorization (DA). Instead, we
     * transform the DA into an instance of org.abundantcommunityinitiative.commongood.Authorization.
     * That class is a bit more useful for authorizing HTTP requests.
     */
    def getForPerson( person ) {
        log.info "Get Authorization for ${person.logName}"
        def da = DomainAuthorization.findAll( "from DomainAuthorization da where da.person.id=?", [ person.id ] )

        if( da.size() == 0 ) {
            log.warn "No DA rows found for ${person.logName}"

        } else {
            log.info "${da.size()} DA rows found for ${person.logName}"
            def bestDA = null
            for( domAuth in da ) {
                if( domAuth.domainCode == DomainAuthorization.NEIGHBOURHOOD ) {
                    // A person should have at most one of these.
                    bestDA = domAuth
                    break

                } else if( domAuth.domainCode == DomainAuthorization.BLOCK ) {
                    // We'll use the first non-NH DA we find
                    bestDA = domAuth
                
                } else {
                    log.warn "Ignoring domainCode ${domAuth.domainCode}"
                }
            }

            if( bestDA ) {
                if( bestDA.domainCode == DomainAuthorization.NEIGHBOURHOOD ) {
                    return Authorization.getForNeighbourhood( bestDA.domainKey, bestDA.write )
                } else {
                    return Authorization.getForBlock( bestDA.domainKey, bestDA.write )
                }
            }
        }

        log.warn "No valid DA for ${person.logName}"
        return null
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
