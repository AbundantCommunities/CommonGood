package commongood

import grails.transaction.Transactional

@Transactional
class DeleteService {

    def address( Address target ) {
        def families = Family.findAllByAddress( target )
        families.each {
            family( it )
        }

        target.delete( flush:true )
    }

    def family( Family target ) {
        def members = Person.findAllByFamily( target )
        members.each {
            person( it )
        }

        target.delete( flush:true )
    }

    def person( Person target ) {
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
                it.interviewer = null
                it.save( flush:true, failOnError: true )
            }

            target.delete(flush:true)
    }
}
