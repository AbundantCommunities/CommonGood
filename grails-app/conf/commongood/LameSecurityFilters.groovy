package commongood

class LameSecurityFilters {

    def authenticateService

    def filters = {
        all(controller:'*', action:'*') {
            before = {
                if( controllerName != 'answer' && controllerName != 'login' ) {
                    println "In Sensitive context"
                    if( session.user ) {
                        println "Request from user ${session.user.fullName} is authorized"
                        return true
                    } else {
                        println "UNAUTHENTICATED USER!"
                        redirect( controller: 'login' )
                        return false
                    }
                } else {
                    println "Non sensitive context"
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
