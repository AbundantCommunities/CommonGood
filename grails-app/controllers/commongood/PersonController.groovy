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

    // Make a given person a BC for the block she lives on
    def setBlockConnector( ) {
        Long id = Long.parseLong( params.id )
        Person person = Person.get( id )
        def blockId = person.family.address.block.id
        log.info "${session.user.getLogName()} requests person/${id} be a BC for block ${blockId}"
        authorizationService.block( blockId, session )

        // The person becomes a BC for his block
        DomainAuthorization da = new DomainAuthorization( )
        da.person = person
        da.domainCode = DomainAuthorization.BLOCK
        da.domainKey = blockId as Integer
        da.orderWithinDomain = 100
        da.save( flush:true, failOnError: true )
        redirect controller:'navigate', action:'block', id:blockId
    }
}
