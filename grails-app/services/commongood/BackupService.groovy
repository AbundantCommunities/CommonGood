package commongood

import grails.transaction.Transactional

@Transactional
class BackupService {

    def extractNeighbourhood( Long neighbourhoodId ) {
        Neighbourhood nh = Neighbourhood.get( neighbourhoodId )
        Block[] blocks = Block.findAllByNeighbourhood( nh, [sort: 'orderWithinNeighbourhood'] )
        blocks.each {
            println "block,${it.id},${it.code},${it.description}"
        }

        def addressesAll = [ ]

        blocks.each {
            Address[] addresses = Address.findAllByBlock( it, [sort: 'orderWithinBlock'] )
            addresses.each {
                println "address,${it.block.id},${it.id},${it.text},${it.note}"
                addressesAll << it
            }
        }

        // At this point we can dispense with the blocks, to save heap space
        blocks = null
        def familiesAll = [ ]

        addressesAll.each {
            Family[] families = Family.findAllByAddress( it, [sort: 'orderWithinAddress'] )
            families.each {
                println "family,${it.address.id},${it.id},${it.name},${it.note}"
                familiesAll << it
            }
        }

        // At this point we can dispense with the addresses, to save heap space
        addressesAll = null

        // TO BE CONTINUED!
    }
}
