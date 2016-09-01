package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class NeighbourhoodController {
    static allowedMethods = [addBlock:'POST']
    def authorizationService
    def reorderService

    def reorder( ) {
        def block = Block.get( Long.valueOf( params.blockId ) )
        def nhood = block.neighbourhood
        authorizationService.neighbourhood( nhood.id, session )

        def afterId = Long.valueOf( params.afterId )
        if( afterId ) {
            def afterBlock = Block.get( afterId )
            log.info "${session.user.getLogName()} requests move ${block} after ${afterBlock}"
            reorderService.neighbourhood( block, afterBlock )
        } else {
            log.info "${session.user.getLogName()} requests move ${block} to top"
            reorderService.neighbourhood( block )
        }

        redirect controller:'navigate', action:'neighbourhood', id:nhood.id
    }

    // TODO BC can cover > 1 block; make easier for GSP
    def blockConnectors( ) {
        // This def and call to our authorizationService accomplishes very little
        // but without it, the code appears to lack authorization enforcement...
        def neighbourhoodId = session.neighbourhood.id
        authorizationService.neighbourhood( neighbourhoodId, session )
        log.info "${session.user.getLogName()} requests Block Connector Contact List for neighbourhood/${neighbourhoodId}"

        String query = '''SELECT blk.id,
                                blk.code,
                                blk.description,
                                bc.id,
                                bc.firstNames,
                                bc.lastName,
                                bc.phoneNumber,
                                bc.emailAddress,
                                a.text
                          FROM DomainAuthorization AS da,
                               Block AS blk,
                               Person AS bc,
                               Family as f,
                               Address as a
                          WHERE da.domainCode = 'B'
                          AND   da.domainKey = blk.id
                          AND   blk.neighbourhood.id = :neighbourhoodId
                          AND   da.person.id = bc.id
                          AND   bc.family.id = f.id
                          AND   f.address.id = a.id
                          ORDER BY bc.firstNames, bc.lastName, bc.id'''
        List connectors = Block.executeQuery( query, [neighbourhoodId:neighbourhoodId] ).collect {
            [
                blockId: it[0],
                blockCode: it[1],
                blockDescription: it[2],
                id: it[3],
                firstNames: it[4],
                lastName: it[5],
                phone: it[6],
                emailAddress: it[7],
                address: it[8]
            ]
        }
        [ connectors: connectors ]
    }

    def addBlock( ) {
        def neighbourhoodId = params.long('id')
        log.info "${session.user.getLogName()} requests addBlock for neighbourhood/${neighbourhoodId}"
        authorizationService.neighbourhood( neighbourhoodId, session )
        def neighbourhood = Neighbourhood.get( neighbourhoodId )

        def block = new Block( )
        block.neighbourhood = neighbourhood
        block.code = params.code.trim( )
        block.description = params.description.trim( )

        if( params.orderWithinNeighbourhood ) {
            block.orderWithinNeighbourhood = params.int('orderWithinNeighbourhood')
        } else {
            // Find the largest value of orderWithinNeighbourhood and go from there...
            def query = Block.where {
                neighbourhood.id == block.neighbourhood.id
            }.projections {
                max('orderWithinNeighbourhood')
            }
            def lastOrder = query.find() as Integer
            lastOrder = lastOrder ?: 0
            block.orderWithinNeighbourhood = lastOrder + 100
        }

        if( block.code ) {
            block.save( flush:true, failOnError: true )
            redirect controller: "navigate", action: "neighbourhood", id: neighbourhoodId
        } else {
            throw new RuntimeException("Missing block code")
        }
    }

    // Get a JSON list of blocks for a given neighbourhood
    def blocks( ) {
        def id = Long.valueOf( params.id )
        authorizationService.neighbourhood( id, session )
        log.info "${session.user.getLogName()} requests list of blocks for neighbourhood/${id}"

        def neighbourhoodBlocks = Block.findAll("from Block blk join blk.neighbourhood neigb where neigb.id=?", [ id ])

        def result = [ ]
        neighbourhoodBlocks.each {
            Block blk = it[0]
            result << [ id:blk.id, code:blk.code, description:blk.description ]
        }

        render JsonWriter.write( result )
    }



}
