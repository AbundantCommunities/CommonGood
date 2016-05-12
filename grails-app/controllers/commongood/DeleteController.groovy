package commongood

class DeleteController {
    def authorizationService

    // Determine what answers would be lost if a given person were to be
    // deleted (cascading deletion of person's answers).
    def confirmPerson( ) {
        Person target = Person.get( params.long('id') )
        log.info "${session.user.getLogName()} confirm deletion of person ${target.logName}"
        authorizationService.person( target.id, session )

        def deleteThis = "PERSON ${target.firstNames} ${target.lastName}"
        def count = Answer.countByPerson( target )

        return [deleteThis: deleteThis, associatedTables: ["${count} Answers"] ]
    }
}
