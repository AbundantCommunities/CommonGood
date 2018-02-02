package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

class AuthorizationController {
    static allowedMethods = [deauthorizeBlockConnector:'POST']
    def authorizationService
    def domainAuthorizationService;

    def deauthorizeBlockConnector( ) {
        Long personId = Long.valueOf( params.id )
        Long blockId = Long.valueOf( params.blockId )
        log.info "${LogAid.who(session)} deauthorize person/${personId} as a BC for block/${blockId}"
        authorizationService.blockWrite( blockId, session )
        domainAuthorizationService.deauthorizeBlockConnector( personId, blockId )
        redirect controller: "navigate", action: "block", id: blockId
    }
}
