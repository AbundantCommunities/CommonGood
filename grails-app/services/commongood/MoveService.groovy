package commongood

import grails.transaction.Transactional

@Transactional
class MoveService {

    // Move a given address to a different block.
    def address( Address addressToMove, Block destinationBlock ) {

        addressToMove.block = destinationBlock

        addressToMove.save( flush:true, failOnError: true )

    }

    // Move a given family to a different address.
    def family( Family familyToMove, Address destinationAddress ) {

        familyToMove.address = destinationAddress

        familyToMove.save( flush:true, failOnError: true )

    }

    // Move a given person to a different family.
    def person( Person personToMove, Family destinationFamily ) {

        personToMove.family = destinationFamily

        personToMove.save( flush:true, failOnError: true )

    }
}
