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

    def hashForm( ) {
        log.debug( 'Someone requested our hash form' )
    }

    def hashPassword( ) {
        // Neat thing is: one can change the parameters here without affecting
        // the existing password hashes.
        HashSpec spec = new HashSpec("PBKDF2WithHmacSHA512", 75000, 64, 256)
        Hasher hasher = new Hasher(spec)
        String res = hasher.create(params.password.toCharArray())
        log.info("Hashed password for ${params.emailAddress} = ${res}")
        render "Thanks!<br/>Please email Howard, <b>howardlawrence@shaw.ca</b>, saying you submitted your password."
    }
}
