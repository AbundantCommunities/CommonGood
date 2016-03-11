package commongood

import org.abundantcommunityinitiative.commongood.Authorization

class LoginController {
    static allowedMethods = [index:'GET', authenticate:'POST']

    // Grails automagically injects instances of these services for us
    def authenticateService
    def domainAuthorizationService

    def index( ) {
        if( session.user && session.neighbourhood ) {
            log.info( "LoginController found ${session.user} still logged in" )
            redirect controller: 'navigate', action:'neighbourhood', id:session.neighbourhood.id
        } else {
            log.info 'Unauthenticated user needs to log in'
        }
    }

    def authenticate( ) {
        session.user = null
        session.neighbourhood = null
        log.info("Request to authenticate, using ${params.emailAddress}; pwd len is ${params.password.size()}")

        def user = authenticateService.check( params.emailAddress, params.password )
        if( user ) {
            def neighbourhoodId = domainAuthorizationService.getNeighbourhoodAuthorization( user )
            if( neighbourhoodId ) {
                log.debug "Will store info in session for NH with id=${neighbourhoodId}"
                
                // If the following "get" fails we do not want user in session:
                session.neighbourhood = Neighbourhood.get( neighbourhoodId )
                session.user = user
                if( user.id % 2 ) {
                    // While we develop BC access, Odd #'ed users get to be NCs!
                    log.info 'Lucky user gets to be an NC!'
                    session.authorized = Authorization.getForNeighbourhood( )
                    redirect controller:'navigate', action:'neighbourhood', id:neighbourhoodId
                } else {
                    log.info 'Yay, we have a BC here!'
                    session.authorized = Authorization.getForBlock( )
                    redirect controller:'navigate', action:'neighbourhood', id:neighbourhoodId
                }

            } else {
                log.warn "NO neighbourhood authorization to store in session for ${params.emailAddress}"
                flash.message = 'Please contact the owner of this system'
                // TODO Count login failures; lock account
                redirect action: "index"
            }
        } else {
            flash.message = 'Invalid login; please try again'
            log.warn "FAILED to authenticate ${params.emailAddress}"
            // TODO Count login failures; lock account
            redirect action: "index"
        }
    }
}
