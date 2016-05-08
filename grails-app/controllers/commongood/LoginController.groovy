package commongood

import org.abundantcommunityinitiative.commongood.Authorization

class LoginController {
    static allowedMethods = [index:'GET', authenticate:'POST']

    // Grails automagically injects instances of these services for us
    def authenticateService
    def domainAuthorizationService

    def index( ) {
        // Tomcat's default 30 minute timeout is too brief.
        // Force it to several hours; later we might make it configurable.
        session.setMaxInactiveInterval( 6 * 3600 )
        log.info "Session timeout set to ${session.getMaxInactiveInterval()} seconds"
        if( session.user && session.neighbourhood ) {
            log.info( "LoginController found ${session.user} still logged in" )
            redirect controller: 'navigate', action:'neighbourhood', id:session.neighbourhood.id
        } else {
            log.debug 'Unauthenticated user needs to log in'
        }
    }

    // Any machine in the world can (optionally) pass us a JSESSIONID and ask if "this person"
    // is currently authenticated (currently  "logged in"). 
    def isAuthenticated( ) {
        if( authenticateService.isAuthenticated(session) ) {
            log.debug "${session.user.getLogName()} is authenticated"
            render 'true'
        } else {
            log.info( 'Not authenticated')
            render 'false'
        }
    }

    def authenticate( ) {
        session.user = null
        session.neighbourhood = null
        log.info("Authenticate ${params.emailAddress}; pwd len is ${params.password.size()}")

        def user = authenticateService.check( params.emailAddress, params.password )
        if( user ) {
            def authorization = domainAuthorizationService.getForPerson( user )
            if( authorization ) {
                log.info "${user.logName} authorized for ${authorization}"

                if( authorization.forNeighbourhood() ) {
                    session.neighbourhood = Neighbourhood.get( authorization.domainKey )
                    redirect controller:'navigate', action:'neighbourhood', id:authorization.domainKey
                } else {
                    session.block = Block.get( authorization.domainKey )
                    // TODO Reconsider storing the HOOD in session for BCs
                    session.neighbourhood = session.block.neighbourhood
                    redirect controller:'navigate', action:'block', id:authorization.domainKey
                }

                session.authorized = authorization
                session.user = user

            } else {
                log.warn "No valid Domain Authorization for ${user.logName}"
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
