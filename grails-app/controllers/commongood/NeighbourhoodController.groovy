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
        block.orderWithinNeighbourhood = Integer.valueOf( params.orderWithinNeighbourhood ?: '100' )

        if( block.code && block.description ) {
            block.save( flush:true, failOnError: true )
            forward controller: "navigate", action: "neighbourhood", id: neighbourhoodId
        } else {
            throw new RuntimeException("Bad code and/or description?")
        }
    }
}
