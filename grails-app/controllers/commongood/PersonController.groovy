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
            Person thePerson = personService.update( personId, params )
            if( thePerson ) {
                flash.message = "We saved your changes to ${thePerson.fullName}"
                flash.nature = 'SUCCESS'
            } else {
                // UI should prevent us from getting this far
                flash.message = "FAILED to save your changes becuase: duplicate email address"
                flash.nature = 'WARNING'
            }
            redirect controller:'navigate', action:'familymember', id:personId
        } else {
            // Create a new person
            def familyId = params.int('familyId')
            authorizationService.familyWrite( familyId, session )
            log.info "${LogAid.who(session)} ADD person to family/${familyId}"
            Person thePerson = personService.insert(familyId,params)
            if( thePerson ) {
                flash.message = "We added ${thePerson.fullName} to the database"
                flash.nature = 'SUCCESS'
            } else {
                // UI should prevent dup email address
                flash.message = "FAILED to add new person to database: duplicate email address"
                flash.nature = 'WARNING'
            }
            redirect controller:'navigate', action:'family', id:familyId
        }
    }
}
