package org.abundantcommunityinitiative

import commongood.*

class QuickLookController {

    // Let's have a quick peek at things...
    def index( ) {
        def neighbourhoods = Neighbourhood.count( )
        def blocks = Block.count( )
        def addresses = Address.count( )
        def families = Family.count( )
        def people = Person.count( )
        def questions = Question.count( )
        def answers = Answer.count( )
        [
            neighbourhoods:neighbourhoods, blocks:blocks, addresses:addresses, families:families,
            people:people, questions:questions, answers:answers
        ]
    }
}
