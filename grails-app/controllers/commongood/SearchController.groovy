package commongood

class SearchController {
    def searchService

    def index() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH of currently signed in user.
        log.info "${session.user.getLogName()} ${session.authorized} searching for '${params.q}'"
        def answers = searchService.answers( session, params.q )
        def people = searchService.people( session, params.q )
        return [ q:params.q, answers:answers, people:people ]
    }

    def withContactInfo() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH of currently signed in user.
        log.info "${session.user.getLogName()} ${session.authorized} searching for '${params.q}' (with contact info)"
        def answers = searchService.answersWithContactInfo( session, params.q )
        def people = searchService.peopleWithContactInfo( session, params.q )
        return [ q:params.q, answers:answers, people:people ]
    }
}
