package commongood

import grails.transaction.Transactional

@Transactional
class MoveService {

    // Move a given address to a different block.
    def address( Address addressToMove, Block destinationBlock ) {

        // Find the largest value of orderWithinBlock for block address
        // is being moved to so we can position address at end of current
        // block list.
        def query = Address.where {
            block.id == destinationBlock.id
        }.projections {
            max('orderWithinBlock')
        }
        def lastOrder = query.find() as Integer
        lastOrder = lastOrder ?: 0

        addressToMove.orderWithinBlock = lastOrder + 1

        addressToMove.block = destinationBlock

        addressToMove.save( flush:true, failOnError: true )

    }

    // Move a given family to a different address.
    def family( Family familyToMove, Address destinationAddress ) {

        // Find the largest value of orderWithinAddress for address family
        // is being moved to so we can position family at end of current
        // address list.
        def query = Family.where {
            address.id == destinationAddress.id
        }.projections {
            max('orderWithinAddress')
        }
        def lastOrder = query.find() as Integer
        lastOrder = lastOrder ?: 0
        
        familyToMove.orderWithinAddress = lastOrder + 1

        familyToMove.address = destinationAddress

        familyToMove.save( flush:true, failOnError: true )

    }

    // Move a given person to a different family.
    def person( Person personToMove, Family destinationFamily ) {

        // Find the largest value of orderWithinFamily for family person
        // is being moved to so we can position person at end of current
        // family members.
        def query = Person.where {
            family.id == destinationFamily.id
        }.projections {
            max('orderWithinFamily')
        }
        def lastOrder = query.find() as Integer
        lastOrder = lastOrder ?: 0

        personToMove.orderWithinFamily = lastOrder + 1

        personToMove.family = destinationFamily

        personToMove.save( flush:true, failOnError: true )

    }
    
}
