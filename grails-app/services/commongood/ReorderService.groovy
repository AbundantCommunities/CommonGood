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
}
