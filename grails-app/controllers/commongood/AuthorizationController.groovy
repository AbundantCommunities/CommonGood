package commongood

class AuthorizationController {
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )

        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        forward controller: "navigate", action: "block", id: blockId
    }
}
