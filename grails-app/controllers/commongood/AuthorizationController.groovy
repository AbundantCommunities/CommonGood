package commongood

class AuthorizationController {
    static allowedMethods = [deauthorizeBlockConnector:'POST']
    def authorizationService
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )
        log.info "${session.user.getLogName()} deauthorize person/${personId} as a BC for block/${blockId}"
        authorizationService.block( blockId, session )
        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        redirect controller: "navigate", action: "block", id: blockId
    }
}
