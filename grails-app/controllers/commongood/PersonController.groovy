package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

class PersonController {
    static allowedMethods = [save:'POST']
    def authorizationService
    def personService

    // Write a new person or update an existing person
    def save( ) {
        if( 'id' in params ) {
            // Update an existing person
            Integer personId = params.int('id')
            authorizationService.personWrite( personId, session )
            log.info "${LogAid.who(session)} SAVE changes to person/${personId}"
            if( personService.update(personId,params) ) {
                flash.message = "We updated that person"
                flash.nature = 'SUCCESS'
            } else {
                // UI should prevent dup email address
                flash.message = "FAILED to update person (duplicate email address?)"
                flash.nature = 'WARNING'
            }
            redirect controller:'navigate', action:'familymember', id:personId
        } else {
            // Create a new person
            def familyId = params.int('familyId')
            authorizationService.familyWrite( familyId, session )
            log.info "${LogAid.who(session)} ADD person to family/${familyId}"
            if( personService.insert(familyId,params) ) {
                flash.message = "We added that person to the database"
                flash.nature = 'SUCCESS'
            } else {
                // UI should prevent dup email address
                flash.message = "FAILED to save that person (duplicate email address?)"
                flash.nature = 'WARNING'
            }
            redirect controller:'navigate', action:'family', id:familyId
        }
    }
}
