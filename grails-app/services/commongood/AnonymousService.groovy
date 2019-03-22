package commongood

import grails.transaction.Transactional

/**
 * WARNING !!!!
 * 
 * This service is called by AnonymousController, which provides PUBLIC ACCESS
 * to its actions.
 * 
 * Return only public and anonymized data!
 */

@Transactional
class AnonymousService {

    def getQuestions( Long neighbourhoodId ) {
        def hood = Neighbourhood.get( neighbourhoodId )
        if( hood ) {
            if( hood.featureFlags.contains('disclose') ) {
                [
                    neighbourhood: hood,
                    questions: Question.findAllByNeighbourhood( hood,  [sort: 'orderWithinQuestionnaire'] )
                ]
            } else {
                log.warn "Won't disclose questions of " + hood
                return null
            }
        } else {
            log.warn "Invalid neighbourhood id: ${neighbourhoodId}"
            return null
        }
    }
}
