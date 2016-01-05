package commongood

class LameSecurityFilters {

    def authenticateService

    def filters = {
        all(controller:'*', action:'*') {
            before = {
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
