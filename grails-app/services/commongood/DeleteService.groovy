package commongood

import grails.transaction.Transactional

@Transactional
class DeleteService {

    def boolean personInBlock( Person person, Block target ) {

        def addresses = Address.findAllByBlock( target )
        for ( anAddress in addresses ) {
            if (personInAddress( person, anAddress )) {
                return true
            }
        }
        return false

    }

    def boolean personInAddress( Person person, Address target ) {

        def families = Family.findAllByAddress( target )
        for ( aFamily in families ) {
            if (personInFamily( person, aFamily )) {
                return true
            }
        }
        return false
    }

    def boolean personInFamily( Person person, Family target ) {

        def members = Person.findAllByFamily( target )
        for ( aMember in members ) {
            if ( person.id == aMember.id ) {
                return true
            }
        }
        return false
    }


    // Delete a given block (and its addresses, families, members & answers)
    def block( Block target ) {
        def addresses = Address.findAllByBlock( target )
        addresses.each {
            address( it )
        }

        // If the blocks BC lives on the block being deleted, DA record will be deleted
        // when the BC person record is deleted. However, if the BC does not live on the
        // block being deleted (a post 1.5.0 feature), we need to delete the DA record here.
        def query = DomainAuthorization.where {
            domainCode == DomainAuthorization.BLOCK && domainKey == target.id
        }

        def das = query.list()
        das.each {
            it.delete(flush: true)
        }

        target.delete( flush:true )
    }

    // Delete a given address (and its families, their members & answers)
    def address( Address target ) {
        def families = Family.findAllByAddress( target )
        families.each {
            family( it )
        }

        target.delete( flush:true )
    }

    // Delete a given family (and its members & answers)
    def family( Family target ) {
        def members = Person.findAllByFamily( target )
        members.each {
            person( it )
        }

        target.delete( flush:true )
    }

    // Delete a given person (and all their answers, etc)
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
