package commongood

class LoginController {

    // Grails automagically injects instances of these services for us
    def authenticateService
    def domainAuthorizationService

    def index( ) {
         println 'Prepare login form'
    }

    def authenticate( ) {
        session.user = null
        session.neighbourhood = null

        def user = authenticateService.check( params.emailAddress, params.password )

        if( user ) {
            def neighbourhoodId = domainAuthorizationService.getNeighbourhoodAuthorization( user )
            if( neighbourhoodId ) {
                println "Will store info in session for NH with id=${neighbourhoodId}"
                
                // If the following "get" fails we do not want user in session:
                session.neighbourhood = Neighbourhood.get( neighbourhoodId )
                session.user = user
                flash.message = "You logged in successfully with access to ${session.neighbourhood.name}."
            } else {
                println "NO NH authorization to store in session"
                flash.message = 'You authenticated okay but WITHOUT access to a neighbourhood.'
            }
            forward controller: "homePageTest"

        } else {
            println 'LoginController.authenticate( ) FAILED to authenticate (back to login form)'
            flash.message = 'Login failure!'
            forward action: "index"
        }
    }
}
