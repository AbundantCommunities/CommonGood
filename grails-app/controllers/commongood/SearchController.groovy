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
        log.warn 'ADVANCED SEARCH NOT IMPLEMENTED -- INVOKING SEARCH SANS CONTACT INFO'
        log.info "${session.user.getLogName()} ${session.authorized} advanced search for '${params.q}' ${params.fromBirthYear}:${params.toBirthYear}"
        def people = searchService.people( session, params.q )
        def answers = searchService.answers( session, params.q )
        return [ q:params.q, fromBirthYear:params.fromBirthYear, toBirthYear:params.toBirthYear,
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
