package commongood

class SearchController {
    def searchService

    def form( ) {
        log.debug "${session.user.getLogName()} ${session.authorized} asked for search form"
        [
            authorized: session.authorized
        ]
    }

    def advanced() {
        def fromAge = params.int('fromAge')
        def toAge = params.int('toAge')
        def contactInfo = params.boolean('contactInfo')
        log.info "${session.user.getLogName()} ${session.authorized} advanced search for '${params.q}' aged ${fromAge}:${toAge} contact ${contactInfo}"

        if( !fromAge ) {
            fromAge = searchService.MIN_AGE
        }
        if( !toAge ) {
            toAge = searchService.MAX_AGE
        }
        if( !contactInfo ) {
            contactInfo = false
        }

        def people
        def answers
        if( contactInfo ) {
            people = searchService.peopleWithContactInfo( session, params.q, fromAge, toAge )
            answers = searchService.answersWithContactInfo( session, params.q, fromAge, toAge )
        } else {
            people = searchService.people( session, params.q, fromAge, toAge )
            answers = searchService.answers( session, params.q, fromAge, toAge )
        }

        return [ q:params.q, fromAge:params.fromAge, toAge:params.toAge, contactInfo:params.contactInfo,
            answers:answers, people:people ]
    }

    def index() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH or Block of signed in user.
        log.info "${session.user.getLogName()} ${session.authorized} searching for '${params.q}'"
        def people = searchService.people( session, params.q )
        def answers = searchService.answers( session, params.q )
        return [ q:params.q, answers:answers, people:people ]
    }

    def withContactInfo() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH or Block of signed in user.
        log.info "${session.user.getLogName()} ${session.authorized} searching for '${params.q}' (with contact info)"
        def people = searchService.peopleWithContactInfo( session, params.q )
        def answers = searchService.answersWithContactInfo( session, params.q )
        return [ q:params.q, answers:answers, people:people ]
    }
}
