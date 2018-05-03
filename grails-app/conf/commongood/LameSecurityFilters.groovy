package commongood

class LameSecurityFilters {

    def authenticateService

    def filters = {
        all(controller:'*', action:'*') {
            before = {
                if( controllerName != 'passwordReset' && controllerName != 'answer' && controllerName != 'login' && controllerName != 'admin' && controllerName != 'anonymous') {
                    if( session.user ) {
                        log.debug "In Sensitive Context; ${session.user.fullName} is authenticated"
                        return true
                    } else {
                        log.warn "In Sensitive Context; user is NOT authenticated"
                        redirect controller: 'login'
                        return false
                    }
                } else {
                    log.debug "Non sensitive context"
                    return true
                }
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
