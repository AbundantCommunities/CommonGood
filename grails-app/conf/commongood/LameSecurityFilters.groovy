package commongood

class LameSecurityFilters {

    def authenticateService

    def filters = {
        all(controller:'*', action:'*') {
            before = {
//                if( params.emailAddress && params.password ) {
//                    session.user = authenticateService.check( params.emailAddress, params.password )
//                }
//                if( !session.user ) {
//                    redirect(controller: 'login', action: 'form')
//                    return false
//                }
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
