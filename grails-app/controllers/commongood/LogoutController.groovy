package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

class LogoutController {

    def index() {
        log.info "${LogAid.who(session)} logging out"
        session.user = null
        session.neighbourhood = null
        redirect controller: "login"
    }
}
