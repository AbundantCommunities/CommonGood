package org.abundantcommunityinitiative

import commongood.*
import com.cognish.password.HashSpec
import com.cognish.password.Hasher

class AdminController {

    // Let's have a quick peek at things...
    def countRows( ) {
        log.info( 'Counting rows...' )
        def neighbourhoods = Neighbourhood.count( )
        def blocks = Block.count( )
        def addresses = Address.count( )
        def families = Family.count( )
        def people = Person.count( )
        def questions = Question.count( )
        def answers = Answer.count( )
        log.info( 'Finished counting' )
        [
            neighbourhoods:neighbourhoods, blocks:blocks, addresses:addresses, families:families,
            people:people, questions:questions, answers:answers
        ]
    }
}
