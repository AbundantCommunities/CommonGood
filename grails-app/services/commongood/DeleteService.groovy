package commongood

import grails.transaction.Transactional

@Transactional
class DeleteService {

    def person( Person target ) {
        println "Supposed to delete person: ${person.logName}"
    }
}
