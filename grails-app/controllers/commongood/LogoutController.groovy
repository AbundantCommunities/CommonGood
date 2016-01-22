package commongood

class LogoutController {

    def index() {
        session.user = null
        flash.message = "DON'T USE FLASH TO SAY You have logged out"
        forward controller: "login"
    }
}
