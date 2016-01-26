package commongood

class NeighbourhoodController {
    static allowedMethods = [addBlock:'POST']

    def authorizationService

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
