package commongood

import org.abundantcommunityinitiative.commongood.handy.TokenGenerator

class DeleteController {
    def authorizationService

    // Determine what people and answers would be lost if a given family were to be
    // deleted (cascading deletions...).
    def confirmFamily( ) {
        Family target = Family.get( params.long('id') )
        log.info "${session.user.getLogName()} confirm deletion of family ${target.name}"
        authorizationService.family( target.id, session )

        def deleteThis = "FAMILY ${target.name}"
        def peeps = Person.findAllByFamily( target )
        def associated = [ "${peeps.size()} Family Members" ]

        def countAnswers = 0
        peeps.each{
            // This is a horrid way to treat a database!
            countAnswers += Answer.countByPerson( it )
        }
        associated << "${countAnswers} Answers"

        def token = TokenGenerator.get( )
        session.deletionType = 'family'
        session.deletionToken = token

        return [deleteThis: deleteThis, associatedTables: associated, magicToken: token ]
    }

    // Determine what answers would be lost if a given person were to be
    // deleted (cascading deletion of person's answers).
    def confirmPerson( ) {
        Person target = Person.get( params.long('id') )
        log.info "${session.user.getLogName()} confirm deletion of person ${target.logName}"
        authorizationService.person( target.id, session )

        def deleteThis = "PERSON ${target.firstNames} ${target.lastName}"
        def count = Answer.countByPerson( target )

        def token = TokenGenerator.get( )
        session.deletionType = 'person'
        session.deletionToken = token

        return [deleteThis: deleteThis, associatedTables: ["${count} Answers"], magicToken: token ]
    }
}
