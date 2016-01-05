package commongood

class LogoutController {

    def index() {
        session.user = null
        flash.message = 'You have logged out'
        forward controller: "homePageTest", action: "youAreHome"
    }
}
