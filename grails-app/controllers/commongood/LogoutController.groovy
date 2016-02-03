package commongood

class LogoutController {

    def index() {
        println "Logging out ${session.user}"
        session.user = null
        session.neighbourhood = null
        forward controller: "login"
    }
}
