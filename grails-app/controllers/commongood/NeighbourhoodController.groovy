package commongood

class NeighbourhoodController {
    static allowedMethods = [addBlock:'POST']

    def authorizationService

    def addBlock( ) {
        def neighbourhoodId = Long.parseLong( params.id )
        authorizationService.neighbourhood( neighbourhoodId, session )
        def neighbourhood = Neighbourhood.get( neighbourhoodId )

        def block = new Block( )
        block.neighbourhood = neighbourhood
        block.code = params.code
        block.description = params.description
        block.orderWithinNeighbourhood = 100
        block.save( flush:true, failOnError: true )
        forward controller: "navigate", action: "neighbourhood", id: neighbourhoodId
    }
}
