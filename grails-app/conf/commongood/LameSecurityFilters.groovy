package commongood

class LameSecurityFilters {

    def authenticateService

    def filters = {
        all(controller:'*', action:'*') {
            before = {
                if( controllerName != 'answer' && controllerName != 'login' ) {
                    if( session.user ) {
                        log.debug "In Sensitive context; ${session.user.fullName} is authorized"
                        return true
                    } else {
                        log.warn "In Sensitive context; unauthenticated user"
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
