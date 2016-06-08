package commongood

import org.abundantcommunityinitiative.commongood.handy.TokenGenerator

class DeleteController {
    def authorizationService
    def deleteService

    // AJAX. The GSP confirming a deletion can tell us to forget about it.
    def cancel( ) {
        session.deleteType = null
        session.deleteToken = null
        render ""
    }

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
        session.deleteType = 'family'
        session.deleteToken = token

        return [deleteThis: deleteThis, id: target.id, associatedTables: associated, magicToken: token ]
    }

    // Determine what answers would be lost if a given person were to be
    // deleted (cascading deletion of person's answers).
    def confirmPerson( ) {
        Person target = Person.get( params.long('id') )
        log.info "${session.user.getLogName()} confirm deletion of person ${target.logName}"
        authorizationService.person( target.id, session )

        def deleteThis = "PERSON ${target.firstNames} ${target.lastName}"
        def count = Answer.countByPerson( target )
        def associated = [ "${count} Answers" ]

        def das = DomainAuthorization.findAllByPerson( target )
        count = 0
        das.each {
            count++
        }
        if( count ) {
            associated << "${count} Authorizations (this is technical)"
        }

        associated << "(not reporting interviewer references!)"

        def token = TokenGenerator.get( )
        session.deleteType = 'person'
        session.deleteToken = token

        return [deleteThis: deleteThis, id: target.id, associatedTables: associated, magicToken: token ]
    }

    // Delete a given family. Cascade the deletion to objects associated with the
    // family.
    def famiy( ) {
        Family target = Family.get( params.long('id') )
        log.info "${session.user.getLogName()} DELETE family ${target.id} ${target.name}"
        authorizationService.family( target.id, session )

        if( session.deleteType == 'family' && session.deleteToken == params.magicToken ) {
            // Need to remember address for response page
            Address address = target.address

            def members = Person.findAllByFamily( target )
            members.each {
                deleteService.person( it )
            }

            // Last but not least.
            target.delete( flush:true )

            session.deleteType = null
            session.deleteToken = null

            flash.message = "Deleted FAMILY ${target.name}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "address", id: address.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical delete on family')
        }
    }

    // Delete a given person. Cascade the deletion to objects associated with the
    // person.
    def person( ) {
        Person target = Person.get( params.long('id') )
        log.info "${session.user.getLogName()} DELETE person ${target.logName}"
        authorizationService.person( target.id, session )

        if( session.deleteType == 'person' && session.deleteToken == params.magicToken ) {
            // Need to remember family for response page
            Family family = target.family

            def answers = Answer.findAllByPerson( target )
            answers.each {
                it.delete(flush: true)
            }
            def das = DomainAuthorization.findAllByPerson( target )
            das.each {
                it.delete(flush: true)
            }
            def bcs = Family.findAllByInterviewer( target )
            bcs.each {
                it.interviwer = null
                it.save( flush:true, failOnError: true )
            }

            // Finally, the coup de grace.
            target.delete(flush:true)

            session.deleteType = null
            session.deleteToken = null

            flash.message = "Deleted PERSON ${target.firstNames} ${target.lastName}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "family", id: family.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical delete on person')
        }
    }
}
