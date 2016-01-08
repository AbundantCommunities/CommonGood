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

        if( params.emailAddress && params.password ) {
            session.user = authenticateService.check( params.emailAddress, params.password )
        }

        if( session.user ) {
            Person person = session.user
            def neighbourhoodId = domainAuthorizationService.getNeighbourhoodAuthorization( person )
            if( neighbourhoodId ) {
                println "Will store info in session for NH with id=${neighbourhoodId}"
                session.neighbourhood = Neighbourhood.get( neighbourhoodId )
                flash.message = 'You logged in successfully.'
                forward controller: "homePageTest", action: "youAreHome"
            }
        }

        flash.message = 'Login failure!'
        forward action: "index"
    }
}
