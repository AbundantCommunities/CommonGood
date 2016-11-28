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

    // Determine what families, people and answers would be lost if a given address
    // were to be deleted (cascading deletions...).
    def confirmBlock( ) {
        Block target = Block.get( params.long('id') )
        authorizationService.blockWrite( target.id, session )

        if ( deleteService.personInBlock( session.user, target ) ) {
            log.warn "${session.user.logName} prevent deletion of own block"
            flash.message = "You cannot delete your own block. That would delete you, too!"
            flash.nature = 'WARNING'
            redirect controller: "navigate", action: "block", id: target.id

        } else {
            log.info "${session.user.getLogName()} confirm delete block ${target.code}"
            def deleteThis = "BLOCK ${target.code}"
            def addresses = Address.findAllByBlock( target )

            def countFamilies = 0
            def countPeeps = 0
            def countAnswers = 0

            addresses.each{
                def families = Family.findAllByAddress( it )
                countFamilies += families.size()

                families.each{
                    def peeps = Person.findAllByFamily( it )
                    countPeeps += peeps.size()
                    peeps.each{
                        // This is a horrid way to treat a database!
                        countAnswers += Answer.countByPerson( it )
                    }
                }
            }

            def associated = [ "${addresses.size()} Addresses" ]
            associated << "${countFamilies} Families"
            associated << "${countPeeps} Family Members"
            associated << "${countAnswers} Answers"

            def token = TokenGenerator.get( )
            session.deleteType = 'block'
            session.deleteToken = token

            return [deleteThis: deleteThis, id: target.id, associatedTables: associated, magicToken: token ]
        }
    }

    // Determine what families, people and answers would be lost if a given address
    // were to be deleted (cascading deletions...).
    def confirmAddress( ) {
        Address target = Address.get( params.long('id') )
        authorizationService.addressWrite( target.id, session )

        if ( deleteService.personInAddress( session.user, target ) ) {
            log.warn "${session.user.logName} prevent deletion of own address"
            flash.message = "You cannot delete your own address. That would delete you, too!"
            flash.nature = 'WARNING'
            redirect controller: "navigate", action: "address", id: target.id
            
        } else {
            log.info "${session.user.getLogName()} confirm delete address ${target.text}"
            def deleteThis = "ADDRESS ${target.text}"
            def families = Family.findAllByAddress( target )

            def countPeeps = 0
            def countAnswers = 0
            families.each{
                def peeps = Person.findAllByFamily( it )
                countPeeps += peeps.size()
                peeps.each{
                    // This is a horrid way to treat a database!
                    countAnswers += Answer.countByPerson( it )
                }
            }

            def associated = [ "${families.size()} Families" ]
            associated << "${countPeeps} Family Members"
            associated << "${countAnswers} Answers"

            def token = TokenGenerator.get( )
            session.deleteType = 'address'
            session.deleteToken = token

            return [deleteThis: deleteThis, id: target.id, associatedTables: associated, magicToken: token ]
        }
    }

    // Determine what people and answers would be lost if a given family were to be
    // deleted (cascading deletions...).
    def confirmFamily( ) {
        Family target = Family.get( params.long('id') )
        authorizationService.familyWrite( target.id, session )

        if ( deleteService.personInFamily( session.user, target ) ) {
            log.warn "${session.user.logName} prevent deletion of own family"
            flash.message = "You cannot delete your own famiy. No way!"
            flash.nature = 'WARNING'
            redirect controller: "navigate", action: "family", id: target.id
            
        } else {
            log.warn "${session.user.getLogName()} confirm delete family ${target.name}"
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
    }

    // Determine what answers would be lost if a given person were to be
    // deleted (cascading deletion of person's answers).
    def confirmPerson( ) {
        Person target = Person.get( params.long('id') )
        authorizationService.personWrite( target.id, session )

        if ( session.user.id == target.id ) {
            log.warn "${session.user.getLogName()} Prevent user deleting self"
            flash.message = "You want to delete yourself? Not going to happen!"
            flash.nature = 'WARNING'
            redirect controller: "navigate", action: "familymember", id: target.id

        } else {
            log.info "${session.user.logName} confirm delete person ${target.logName}"
            def deleteThis = "PERSON ${target.firstNames} ${target.lastName}"
            def count = Answer.countByPerson( target )
            def associated = [ "${count} Answers" ]

            associated << "(not reporting interviewer references!)"

            def token = TokenGenerator.get( )
            session.deleteType = 'person'
            session.deleteToken = token

            return [deleteThis: deleteThis, id: target.id, associatedTables: associated, magicToken: token ]
        }
    }

    // Delete a given address. Cascade the deletion to objects associated with the
    // address.
    def block( ) {
        Block target = Block.get( params.long('id') )
        log.info "${session.user.getLogName()} DELETE block ${target.id} ${target.code}"
        authorizationService.blockWrite( target.id, session )

        if( session.deleteType == 'block' && session.deleteToken == params.magicToken ) {
            Neighbourhood neighbourhood = target.neighbourhood

            deleteService.block( target )

            session.deleteType = null
            session.deleteToken = null

            flash.message = "Deleted BLOCK ${target.displayName}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "neighbourhood", id: neighbourhood.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical delete on block')
        }
    }

    // Delete a given address. Cascade the deletion to objects associated with the
    // address.
    def address( ) {
        Address target = Address.get( params.long('id') )
        log.info "${session.user.getLogName()} DELETE address ${target.id} ${target.text}"
        authorizationService.addressWrite( target.id, session )

        if( session.deleteType == 'address' && session.deleteToken == params.magicToken ) {
            Block block = target.block

            deleteService.address( target )

            session.deleteType = null
            session.deleteToken = null

            flash.message = "Deleted ADDRESS ${target.text}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "block", id: block.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical delete on address')
        }
    }

    // Delete a given family. Cascade the deletion to objects associated with the
    // family.
    def family( ) {
        Family target = Family.get( params.long('id') )
        log.info "${session.user.getLogName()} DELETE family ${target.id} ${target.name}"
        authorizationService.familyWrite( target.id, session )

        if( session.deleteType == 'family' && session.deleteToken == params.magicToken ) {
            Address address = target.address

            deleteService.family( target )

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
        authorizationService.personWrite( target.id, session )

        if( session.deleteType == 'person' && session.deleteToken == params.magicToken ) {
            Family family = target.family

            deleteService.person( target )

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
