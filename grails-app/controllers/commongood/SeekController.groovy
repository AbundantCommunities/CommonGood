package commongood

class SeekController {

    def index() {
        String searchTerm = params.q
        String query = "select a.text, p.firstNames from Answer a inner join a.person p where a.text like '%${searchTerm}%' "
        List hits = Answer.executeQuery( query ).collect {
            [
                answer: it[0],
                person: it[1]
            ]
        }
        [result: hits]
    }
}
