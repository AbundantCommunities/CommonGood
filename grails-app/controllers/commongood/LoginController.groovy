package commongood

class LoginController {

    def authenticateService // Grails automagically injects an AuthenticateService for us

    def index( ) {
         println 'Prepare login form'
    }

    def authenticate( ) {
        if( params.emailAddress && params.password ) {
            session.user = authenticateService.check( params.emailAddress, params.password )
        }

        if( session.user ) {
            flash.message = 'You logged in successfully.'
            forward controller: "homePageTest", action: "youAreHome"
        }

        flash.message = 'Login failure!'
        forward action: "index"
    }
}
