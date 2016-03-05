package commongood

class LoginController {

    // Grails automagically injects instances of these services for us
    def authenticateService
    def domainAuthorizationService

    def index( ) {
         log.info 'Prepare login form'
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
                forward controller:'navigate', action:'neighbourhood', id:neighbourhoodId
            } else {
                log.warn "NO neighbourhood authorization to store in session for ${params.emailAddress}"
                flash.message = 'Please contact the system administrator'
                // TODO Count login failures; lock account
                forward action: "index"
            }
        } else {
            flash.message = 'Invalid login; please try again'
            log.warn "FAILED to authenticate ${params.emailAddress}"
            // TODO Count login failures; lock account
            forward action: "index"
        }
    }
}
