package commongood

class NeighbourhoodController {
    static allowedMethods = [addBlock:'POST']

    def authorizationService

    def blockConnectors( ) {
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
        List connectors = Block.executeQuery( query, [neighbourhoodId: session.neighbourhood.id] ).collect {
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

        if( block.code && block.description ) {
            block.save( flush:true, failOnError: true )
            forward controller: "navigate", action: "neighbourhood", id: neighbourhoodId
        } else {
            throw new RuntimeException("Bad code and/or description?")
        }
    }
}
