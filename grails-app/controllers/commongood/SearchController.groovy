package commongood

class SearchController {
    def searchService

    def index() {
        def questionId = 0L
        def answers = searchService.answers( questionId, params.q )
        def people = searchService.people( params.q )
        return [ q:params.q, answers:answers, people:people ]
    }
}
