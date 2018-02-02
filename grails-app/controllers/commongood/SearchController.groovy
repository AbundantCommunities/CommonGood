package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

class SearchController {

    def searchService
    def authorizationService
    def mapService

    def form( ) {
        log.debug "${LogAid.who(session)} ${session.authorized} asked for search form"
        [
            authorized: session.authorized
        ]
    }

    def map() {
        def nhood = session.neighbourhood
        authorizationService.neighbourhoodRead( nhood.id, session )
        [
            q: params.q,
            answersByBlock: mapService.answers( nhood, params.q )
        ]
    }

    def index() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH or Block of signed in user.
        log.info "${LogAid.who(session)} ${session.authorized} searching for '${params.q}'"
        def contactInfo = params.boolean('contactInfo')
        def fromAge = params.int('fromAge')
        def toAge = params.int('toAge')

        def advSearch
        if( !fromAge && !toAge ) {
            advSearch = false
        } else {
            advSearch = true
        }

        def people
        def answers

        if( !contactInfo ) {
            contactInfo = false
        }

        if ( advSearch ) {
            if( !fromAge ) {
                fromAge = searchService.MIN_AGE
            }
            if( !toAge ) {
                toAge = searchService.MAX_AGE
            }
        }

        if ( contactInfo ) {
            if ( advSearch ) {
                people = searchService.peopleWithContactInfo( session, params.q, fromAge, toAge )
                answers = searchService.answersWithContactInfo( session, params.q, fromAge, toAge )
            } else {
                people = searchService.peopleWithContactInfo( session, params.q )
                answers = searchService.answersWithContactInfo( session, params.q )
            }
        } else {
            if ( advSearch ) {
                people = searchService.people( session, params.q, fromAge, toAge )
                answers = searchService.answers( session, params.q, fromAge, toAge )
            } else {
                people = searchService.people( session, params.q )
                answers = searchService.answers( session, params.q )
            }
        }

        return [ contactInfo:params.contactInfo, q:params.q, fromAge:params.fromAge, toAge:params.toAge, answers:answers, people:people ]
    }
}
