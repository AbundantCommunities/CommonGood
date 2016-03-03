package commongood

class LogoutController {

    def index() {
        log.info "${session.user.getFullName()} logging out"
        session.user = null
        session.neighbourhood = null
        forward controller: "login"
    }
}
