package commongood

class AuthorizationController {
    // static allowedMethods = [deauthorizeBlockConnector:'DELETE']
    def authorizationService
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )
        log.info "${session.user.getLogName()} requests person/${personId} no longer be a BC for block/${blockId}"
        authorizationService.block( blockId, session )
        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        redirect controller: "navigate", action: "block", id: blockId
    }
}
