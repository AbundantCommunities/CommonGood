package commongood

class SearchController {
    def searchService

    def index() {
        // No need to ask AuthorizationService about permission.
        // SearchService limits results to NH of currently signed in user.
        log.info "${session.user.getFullName()} searching for '${params.q}'"
        def questionId = 0L // Later, we will allow user to limit to one question
        def answers = searchService.answers( session, questionId, params.q )
        def people = searchService.people( session, params.q )
        return [ q:params.q, answers:answers, people:people ]
    }
}
