package commongood

class PersonController {
    static allowedMethods = [save:'POST', setBlockConnector:'POST']
    def authorizationService
    def personService

    // Write a new person or update an existing person
    def save( ) {
        if( 'id' in params ) {
            // Update an existing person
            Integer personId = params.int('id')
            authorizationService.person( personId, session )
            log.info "${session.user.getLogName()} SAVE changes to person/${personId}"
            personService.update( personId, params )
            redirect controller:'navigate', action:'familymember', id:personId
        } else {
            // Create a new person
            def familyId = params.int('familyId')
            authorizationService.family( familyId, session )
            log.info "${session.user.getLogName()} ADD person to family/${familyId}"
            personService.insert( familyId, params )
            redirect controller:'navigate', action:'family', id:familyId
        }
    }
}
