package commongood

import grails.transaction.Transactional

@Transactional
class ReorderService {

    // We assume that no two blocks within our hood have the same orderWithinNeighbourhood
    def neighbourhood( block, afterBlock ) {
        if( block.neighbourhood != afterBlock.neighbourhood ) {
            throw new Exception('Blocks from different neighbourhoods?!')
        }
        
        // First things first
        def nextNumber = afterBlock.orderWithinNeighbourhood + 1
        block.orderWithinNeighbourhood = nextNumber++

        // Now, reorder the blocks that follow afterBlock.
        // First, find those blocks.
        def crit = Block.createCriteria( )
        def blocks = crit.list {
            eq( 'neighbourhood', block.neighbourhood )
            and {
                gt( 'orderWithinNeighbourhood', afterBlock.orderWithinNeighbourhood )
            }
            order( 'orderWithinNeighbourhood' )
        }
        
        // Do the actual reordering of the blocks that follow afterBlock.
        log.debug "Reorder ${blocks}"
        blocks.each{
            if( it != block ) {
                // Remember: we already renumbered 'block'
                it.orderWithinNeighbourhood = nextNumber++
            }
        }
    }

    // Make this block the first in the hood.
    def neighbourhood( block ) {
        // First things first
        def nextNumber = 1
        block.orderWithinNeighbourhood = nextNumber++

        // Fetch the hood's blocks.
        def crit = Block.createCriteria( )
        def blocks = crit.list {
            eq( 'neighbourhood', block.neighbourhood )
            order( 'orderWithinNeighbourhood' )
        }
        
        // Do the actual reordering of the blocks.
        log.debug "Reorder ${blocks}"
        blocks.each{
            if( it != block ) {
                // Remember: we already renumbered 'block'
                it.orderWithinNeighbourhood = nextNumber++
            }
        }
    }

    // We assume that no two addresses within this block have the same orderWithinBlock
    def block( address, afterAddress ) {
        if( address.block != afterAddress.block ) {
            throw new Exception('Addresses from different blocks?!')
        }
        
        // First things first
        def nextNumber = afterAddress.orderWithinBlock + 1
        address.orderWithinBlock = nextNumber++

        // Now, reorder the addresses that follow afterAddress.
        // First, find those addresses.
        def crit = Address.createCriteria( )
        def addresses = crit.list {
            eq( 'block', address.block )
            and {
                gt( 'orderWithinBlock', afterAddress.orderWithinBlock )
            }
            order( 'orderWithinBlock' )
        }
        
        // Do the actual reordering of the addresses that follow afterAddress.
        log.debug "Reorder ${addresses}"
        addresses.each{
            if( it != address ) {
                // Remember: we already renumbered 'address'
                it.orderWithinBlock = nextNumber++
            }
        }
    }

    // Make this address the first in the block.
    def block( address ) {
        // First things first
        def nextNumber = 1
        address.orderWithinBlock = nextNumber++

        // Fetch the block's addresses.
        def crit = Address.createCriteria( )
        def addresses = crit.list {
            eq( 'block', address.block )
            order( 'orderWithinBlock' )
        }
        
        // Do the actual reordering of the addresses.
        log.debug "Reorder ${addresses}"
        addresses.each{
            if( it != address ) {
                // Remember: we already renumbered 'address'
                it.orderWithinBlock = nextNumber++
            }
        }
    }

    // We assume that no two addresses within this block have the same orderWithinBlock
    def family( person, afterPerson ) {
        if( person.family != afterPerson.family ) {
            throw new Exception('People from different families?!')
        }
        
        // First things first
        def nextNumber = afterPerson.orderWithinFamily + 1
        person.orderWithinFamily = nextNumber++

        // Now, reorder the people that follow afterPerson.
        // First, find those people.
        def crit = Person.createCriteria( )
        def people = crit.list {
            eq( 'family', person.family )
            and {
                gt( 'orderWithinFamily', afterPerson.orderWithinFamily )
            }
            order( 'orderWithinFamily' )
        }
        
        // Do the actual reordering of the people that follow afterPerson.
        log.debug "Reorder ${people}"
        people.each{
            if( it != person ) {
                // Remember: we already renumbered 'person'
                it.orderWithinFamily = nextNumber++
            }
        }
    }

    // Make this person the first in the family.
    def family( person ) {
        // First things first
        def nextNumber = 1
        person.orderWithinFamily = nextNumber++

        // Fetch the family members.
        def crit = Person.createCriteria( )
        def people = crit.list {
            eq( 'family', person.family )
            order( 'orderWithinFamily' )
        }
        
        // Do the actual reordering of the people.
        log.debug "Reorder ${people}"
        people.each{
            if( it != person ) {
                // Remember: we already renumbered 'person'
                it.orderWithinFamily = nextNumber++
            }
        }
    }
}
