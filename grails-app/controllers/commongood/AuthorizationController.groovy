package commongood

class AuthorizationController {
    // static allowedMethods = [deauthorizeBlockConnector:'DELETE']
    def authorizationService
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )

        authorizationService.block( blockId, session )
        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        forward controller: "navigate", action: "block", id: blockId
    }
}
