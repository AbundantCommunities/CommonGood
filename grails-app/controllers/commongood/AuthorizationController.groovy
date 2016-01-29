package commongood

class AuthorizationController {
    // TODO Why did nav/block's DELETE request not satisfy allowedMethods?
    // static allowedMethods = [deauthorizeBlockConnector:'DELETE']
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )

        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        forward controller: "navigate", action: "block", id: blockId
    }
}
