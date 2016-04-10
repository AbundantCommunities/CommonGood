package commongood

class LogoutController {

    def index() {
        log.info "${session.user.getLogName()} logging out"
        session.user = null
        session.neighbourhood = null
        redirect controller: "login"
    }
}
