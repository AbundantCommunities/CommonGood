package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

class AnonymousRequestController {

    def authorizationService

    def inbox( ) {
        def hoodId = session.neighbourhood.id
        authorizationService.neighbourhoodRead( hoodId, session )

        log.info "${LogAid.who(session)} Anonymous Request inbox for neighbourhood/${hoodId}"
        List requests = AnonymousRequest.where{ neighbourhood.id == hoodId }.list( sort:'dateCreated', order:'desc' )
        [
            authorized: session.authorized,
            requests: requests
        ]
    }

    def delete( ) {
        log.info "${LogAid.who(session)} Anonymous Request delete for ids ${params.deleteIds}"

        def hoodId = session.neighbourhood.id
        authorizationService.neighbourhoodWrite( hoodId, session )

        def idArray = params.deleteIds.tokenize("|")

        def oneId

        for ( anId in idArray ) {

            oneId = anId as long

            AnonymousRequest target = AnonymousRequest.get( oneId )

            if ( target ) {
                target.delete ( flush:true )
            }
        }

        flash.message = "Successfully deleted selected messages"
        flash.nature = 'SUCCESS'

        redirect controller: "anonymousRequest", action: "inbox"
    }
}
